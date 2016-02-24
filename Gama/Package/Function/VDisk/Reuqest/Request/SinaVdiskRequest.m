//
//  SinaVdiskRequest.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SinaVdiskRequest.h"
#import "SinaVdiskResponse.h"

#define kDefaultRoot @"basic"
//#define kDefaultRoot @"sandbox"
@implementation SinaVdiskRequest

@end

//获取Auth Token
@implementation AuthorizeTokenRequest
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectUri = _redirectUri;
@synthesize code = _code;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _apiUrl = @"/oauth2/access_token";
        _requestType = RequestType_Post;
        _responseClass = NSStringFromClass([AuthorizeTokenResponse class]);
        _loadingTip = @"获取Token";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [self setParam:_appKey key:@"client_id"];
    [self setParam:_appSecret key:@"client_secret"];
    [self setParam:_redirectUri key:@"redirect_uri"];
    [self setParam:@"authorization_code" key:@"grant_type"];
    [self setParam:_code key:@"code"];
    return _paramDic;
}
@end

//获取用户信息
@implementation VDiskUserInfoRequest
@synthesize sinaToken = _sinaToken;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _apiUrl = @"/account/info";
        _requestType = RequestType_Get;
        _responseClass = NSStringFromClass([VDiskUserInfoResponse class]);
        _loadingTip = @"获取用户信息";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [self setParam:_sinaToken key:@"access_token"];

    return _paramDic;
}
@end

//创建文件夹
@implementation VDiskCreateFolderRequest
@synthesize sinaToken = _sinaToken;
@synthesize root = _root;
@synthesize folderName = _folderName;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _apiUrl = @"/fileops/create_folder";
        _requestType = RequestType_Post;
        _responseClass = NSStringFromClass([VDiskCreateFolderResponse class]);
        _loadingTip = @"获取文件夹信息";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [self setParam:_sinaToken key:@"access_token"];
    [self setParam:kDefaultRoot key:@"root"];
    [self setParam:_folderName key:@"path"];
    
    return _paramDic;
}
@end

//获取文件夹信息
@implementation VDiskFilesRequest
@synthesize sinaToken = _sinaToken;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _apiUrl = [NSString stringWithFormat:@"/delta/%@",kDefaultRoot];
        _requestType = RequestType_Get;
        _responseClass = NSStringFromClass([VDiskFilesResponse class]);
        _loadingTip = @"获取文件夹信息";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [self setParam:_sinaToken key:@"access_token"];
    
    return _paramDic;
}
@end

//POST方式上传文件
@implementation VDiskUploadRequest
@synthesize filePath = _filePath;
@synthesize sinaToken = _sinaToken;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _userInfo = [[NSMutableDictionary alloc] init];
        _apiUrl = [NSString stringWithFormat:@"/files_put/%@",kDefaultRoot];
        _requestType = RequestType_Post;
        _responseClass = NSStringFromClass([VDiskUploadResponse class]);
        _loadingTip = @"上传文件";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [_userInfo setValue:_filePath forKey:@"path"];
    [self setParam:_sinaToken key:@"access_token"];
    [self setParam:@"1" key:@"overwrite"];
    [self setParam:@"1" key:@"parent_rev"];

    return _paramDic;
}
@end

//回复文件
@implementation VDiskRecoveryRequest
@synthesize filePath = _filePath;
@synthesize sinaToken = _sinaToken;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _userInfo = [[NSMutableDictionary alloc] init];
        _apiUrl = [NSString stringWithFormat:@"/files/%@",kDefaultRoot];
        _requestType = RequestType_Post;
        _responseClass = NSStringFromClass([VDiskUploadResponse class]);
        _loadingTip = @"恢复文件";
    }
    return self;
}

- (NSDictionary *) getParam
{
    [_userInfo setValue:_filePath forKey:@"path"];
    [self setParam:_sinaToken key:@"access_token"];
    return _paramDic;
}
@end