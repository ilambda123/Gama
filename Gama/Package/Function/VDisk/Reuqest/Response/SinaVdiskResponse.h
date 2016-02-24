//
//  SinaVdiskResponse.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "Response.h"

@interface SinaVdiskResponse : Response

@end

//获取Auth Token
@interface AuthorizeTokenResponse : Response
@end

//获取用户信息
@interface VDiskUserInfoResponse : Response
@end

//创建文件夹
@interface VDiskCreateFolderResponse : Response
@end

//获取用户信息
@interface VDiskFilesResponse : Response
@end

//POST方式上传文件
@interface VDiskUploadResponse : Response
@end

