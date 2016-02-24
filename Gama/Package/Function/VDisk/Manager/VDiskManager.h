//
//  VDiskManager.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDiskData.h"
#import "Request.h"
#import "RequestManager.h"

#define kAppKey @"3173863255"
#define kAppSecret @"898eaba1826468e8395be54d63ae86be"
#define kRedirectURI @"http://com.dodwow.demotest"

#define kNoteVDiskUploadSuccess @"kNoteVDiskUploadSuccess"

typedef void (^PutProgressBlock)(float progress);
typedef void (^PutResultBlock)(ResultType type);

@interface VDiskManager : NSObject
@property (nonatomic, copy) PutProgressBlock progressBlock;
@property (nonatomic, copy) PutResultBlock resultBlock;

@property (nonatomic) VDiskTokenData *tokenData;
@property (nonatomic) VDiskUserData *userData;
@property (nonatomic) BOOL hadBackUpFolder;

+ (VDiskManager *) shareInstance;
+ (NSString *) authoriszeUrl;

- (NSString *) userName;
- (BOOL) hasSinaToken;
- (void) removeToken;

- (void) updateTokenData:(NSDictionary *)dic;
- (void) updateUserData:(NSDictionary *)dic;
- (void) updateFolder:(NSDictionary *)dic;

- (void) putRequest:(Request *)request
           progress:(PutProgressBlock)pblock
             result:(PutResultBlock)rBlock;
- (void) getRequest:(Request *)reqeust
           progress:(PutProgressBlock)pblock
             result:(PutResultBlock)rBlock;
@end
