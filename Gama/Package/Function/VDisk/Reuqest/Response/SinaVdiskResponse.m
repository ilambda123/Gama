//
//  SinaVdiskResponse.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SinaVdiskResponse.h"
#import "MZ+NSDictionary.h"
#import "VDiskManager.h"

#pragma mark - 获取Auth Token ------------------------------------------
@implementation AuthorizeTokenResponse
- (void) responseData:(NSDictionary *)dic
{
    BOOL success = [dic hasKey:@"access_token"];
    if (success)
    {
        _resultType = ResultType_Success;
        [[VDiskManager shareInstance] updateTokenData:dic];
    }
    else
    {
        _resultType = ResultType_Fail;
        _error = [[NetError alloc] initWithCode:0 msg:@"获取Token失效"];
    }
}
@end

#pragma mark - 获取用户信息 ------------------------------------------
@implementation VDiskUserInfoResponse
- (void) responseData:(NSDictionary *)dic
{
    BOOL success = [dic hasKey:@"uid"];
    if (success)
    {
        _resultType = ResultType_Success;
        [[VDiskManager shareInstance] updateUserData:dic];
    }
    else
    {
        _resultType = ResultType_Fail;
        _error = [[NetError alloc] initWithCode:0 msg:@"获取用户信息失败"];
    }
}
@end


#pragma mark - 创建文件夹 ------------------------------------------
@implementation VDiskCreateFolderResponse
- (void) responseData:(NSDictionary *)dic
{
    BOOL success = [dic hasKey:@"path"];
    if (success)
    {
        _resultType = ResultType_Success;
    }
    else
    {
        _resultType = ResultType_Fail;
        _error = [[NetError alloc] initWithCode:0 msg:@"创建文件失效"];
    }
}
@end

#pragma mark - 获取文件夹信息 ------------------------------------------
@implementation VDiskFilesResponse
- (void) responseData:(NSDictionary *)dic
{
    BOOL success = [dic hasKey:@"entries"];
    if (success)
    {
        _resultType = ResultType_Success;
        [[VDiskManager shareInstance] updateFolder:dic];
    }
    else
    {
        _resultType = ResultType_Fail;
        _error = [[NetError alloc] initWithCode:0 msg:@"获取用户文件夹失效"];
    }
}
@end

#pragma mark - POST方式上传文件 ------------------------------------------
@implementation VDiskUploadResponse
- (void) responseData:(NSDictionary *)dic
{
    BOOL success = [dic hasKey:@"entries"];
    if (success)
    {
        _resultType = ResultType_Success;
    }
    else
    {
        _resultType = ResultType_Fail;
        _error = [[NetError alloc] initWithCode:0 msg:@"备份失败，请重新再试"];
    }
}
@end