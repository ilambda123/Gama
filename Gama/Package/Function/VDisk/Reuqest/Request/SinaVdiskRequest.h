//
//  SinaVdiskRequest.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "Request.h"

@interface SinaVdiskRequest : Request

@end

//获取Auth Token
@interface AuthorizeTokenRequest : Request
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *redirectUri;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *code;
@end

//获取用户信息
@interface VDiskUserInfoRequest : Request
@property (nonatomic, copy) NSString *sinaToken;
@end

//创建文件夹
@interface VDiskCreateFolderRequest : Request
@property (nonatomic, copy) NSString *root;
@property (nonatomic, copy) NSString *folderName;
@property (nonatomic, copy) NSString *sinaToken;
@end

//获取文件夹信息
@interface VDiskFilesRequest : Request
@property (nonatomic, copy) NSString *sinaToken;
@end

//POST方式上传文件
@interface VDiskUploadRequest : Request
@property (nonatomic) NSString *filePath;
@property (nonatomic, copy) NSString *sinaToken;
@end

//回复文件
@interface VDiskRecoveryRequest : Request
@property (nonatomic) NSString *filePath;
@property (nonatomic, copy) NSString *sinaToken;

@end

