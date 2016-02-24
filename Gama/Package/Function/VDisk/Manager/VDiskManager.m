//
//  VDiskManager.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "VDiskManager.h"
#import "MZ+NSString.h"
#import "MZ+NSDictionary.h"

#import "AFNetworking.h"
#import "FileUtils+Gama.h"
#import "ZipUtils.h"
#define kVdiskAuthorizeURL @"https://auth.sina.com.cn/oauth2/authorize"

@interface VDiskManager ()<NSURLSessionDelegate>

@end

static VDiskManager *s_vDiskManager = nil;
@implementation VDiskManager
@synthesize hadBackUpFolder = _hadBackUpFolder;
@synthesize tokenData = _tokenData;
@synthesize userData = _userData;
@synthesize progressBlock = _progressBlock;
@synthesize resultBlock = _resultBlock;

+ (VDiskManager *)shareInstance
{
    @synchronized(self)
    {
        if (!s_vDiskManager)
        {
            s_vDiskManager = [[self alloc] init];
        }
    }
    return s_vDiskManager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _hadBackUpFolder = false;
    }
    return self;
}

#pragma mark - 
- (BOOL) hasSinaToken
{
    NSObject *object = [[NSUserDefaults standardUserDefaults] valueForKey:kVDiskToken];
    if ([object isKindOfClass:[NSString class]])
    {
        if (_tokenData == nil)
        {
            _tokenData = [[VDiskTokenData alloc] init];
        }
        [_tokenData updateToken:(NSString *)object];
        return true;
    }
    return false;
}

- (void) removeToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVDiskToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVDiskName];

    _tokenData = [[VDiskTokenData alloc] init];
    _userData = [[VDiskUserData alloc] init];
}

- (NSString *) userName
{
    NSObject *object = [[NSUserDefaults standardUserDefaults] valueForKey:kVDiskName];
    if ([object isKindOfClass:[NSString class]])
    {
        return (NSString *)object;
    }
    return @"";
}


#pragma mark - Token 
- (void) updateTokenData:(NSDictionary *)dic
{
    _tokenData = [[VDiskTokenData alloc] init];
    [_tokenData loadData:dic];
}

- (void) updateUserData:(NSDictionary *)dic
{
    _userData = [[VDiskUserData alloc] init];
    [_userData loadData:dic];
}

- (void) updateFolder:(NSDictionary *)dic
{
    if ([dic hasKey:@"entries"])
    {
        NSArray *list = dic[@"entries"];
        if ([list count] <= 0)
        {
            return;
        }
        
        NSString *keyName = [NSString stringWithFormat:@"/%@",kGamaBackUp];
        for (NSArray *cell in list)
        {
            if ([cell containsObject:keyName])
            {
                _hadBackUpFolder = true;
                return;
            }
        }
    }
}

#pragma mark - 
+ (NSString *) authoriszeUrl
{
    NSDictionary *params = @{@"client_id" : kAppKey,
                          @"redirect_uri" : kRedirectURI,
                          @"response_type" : @"code",
                          @"display" : @"mobile",
                          @"forcelogin": @"truw"};
    NSString *urlString = [VDiskManager serializeURL:kVdiskAuthorizeURL
                                              params:params
                                          httpMethod:@"GET"];
    return urlString;

}

+ (NSString *)serializeURL:(NSString *)baseURL
                    params:(NSDictionary *)params
                httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"] || !params || [params count] < 1)
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString *query = [self stringFromDictionary:params];
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [dict keyEnumerator])
    {
        if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
        {
            continue;
        }
        NSString *value = [dict objectForKey:key];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [value encodeToPercentEscapeString]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

#pragma mark - Request
- (void) putRequest:(Request *)request progress:(PutProgressBlock)pblock result:(PutResultBlock)rBlock
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    _progressBlock = pblock;
    _resultBlock = rBlock;
    
    NSDictionary *param = [request getParam];
    NSString *apiUrl = request.apiUrl;
    NSString *url = [NSString stringWithFormat:@"http://upload-vdisk.sina.com.cn/2%@",apiUrl];
    MZLog(@"------------------------\n%@\n%@\n------------------------",url,param);
    
    NSString *filePath = [request getUserInfo][@"path"];
    NSURL *nsurl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:nsurl
                                                              cachePolicy:0
                                                          timeoutInterval:100.0f];
    urlRequest.HTTPMethod = @"PUT";
    NSString *key = [NSString stringWithFormat:@"OAuth2 %@",param[@"access_token"]];
    [urlRequest setValue:key forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *fileUrl = [[NSURL alloc] initWithString:filePath];
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:urlRequest
                                                         fromFile:fileUrl
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (_resultBlock)
        {
            ResultType type = (error == nil) ? ResultType_Success : ResultType_Fail;
            _resultBlock(type);
        }
    }];
    [task resume];
}

- (void) getRequest:(Request *)request progress:(PutProgressBlock)pblock result:(PutResultBlock)rBlock
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    _progressBlock = pblock;
    _resultBlock = rBlock;
    
    NSDictionary *param = [request getParam];
    NSString *apiUrl = request.apiUrl;
    NSString *url = [NSString stringWithFormat:@"https://api.weipan.cn/2%@",apiUrl];

    NSString *response = request.responseClass;
    NSString *requestType = NSStringFromClass([request class]);
    
    __weak VDiskManager *weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress)
    {
        float progress = (float)downloadProgress.completedUnitCount /
                        (float)downloadProgress.totalUnitCount;
        if (_progressBlock)
        {
            _progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [weakSelf _httpResponseSuccess:responseObject type:requestType response:response];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [weakSelf _loadingFail:error type:requestType];
     }];
}

- (void) _httpResponseSuccess:(id)responseObject
                         type:(NSString *)requestType
                     response:(NSString *)response
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    NSData *data = (NSData *)responseObject;
    NSString *file = [[FileUtils sysDocumentPath] stringByAppendingPathComponent:@"File.zip"];
    if ([data writeToFile:file atomically:false])
    {
        [ZipUtils unzipFileDefaultData:[FileUtils sysDocumentPath]
                                 block:^(BOOL finish, NSString *filePath)
        {
            if (finish)
            {
                if (_resultBlock)
                {
                    _resultBlock(ResultType_Success);
                }
            }
            else
            {
                if (_resultBlock)
                {
                    _resultBlock(ResultType_Fail);
                }
            }
        }];
    }
    else
    {
        if (_resultBlock)
        {
            _resultBlock(ResultType_Fail);
        }
    }
}


- (void) _loadingFail:(NSError *)error type:(NSString *)type
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    NSInteger code = error.code;
    NSString *msg = [NSString stringWithFormat:@"%ld:%@\n%@",
                     (long)code,error.domain,error.userInfo];
    NSLog(@"%ld: %@",(long)code, msg);
    
    if (_resultBlock)
    {
        _resultBlock(ResultType_Fail);
    }
}

#pragma mark - 上传进度的代理方法
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    // bytesSent totalBytesSent totalBytesExpectedToSend
    // 发送字节(本次发送的字节数)    总发送字节数(已经上传的字节数)     总希望要发送的字节(文件大小)
//    NSLog(@"%lld-%lld-%lld-", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    // 已经上传的百分比
    float progress = (float)totalBytesSent / totalBytesExpectedToSend;
    NSLog(@"%f", progress);
    if (_progressBlock)
    {
        _progressBlock(progress);
    }
}

#pragma mark - 上传完成的代理方法
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSLog(@"完成 %@", [NSThread currentThread]);
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    if (_resultBlock)
    {
        ResultType type = (error == nil) ? ResultType_Success : ResultType_Fail;
        _resultBlock(type);
        if (type == ResultType_Success)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoteVDiskUploadSuccess object:nil];
        }
    }
}
@end
