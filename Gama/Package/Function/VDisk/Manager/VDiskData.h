//
//  VDiskData.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDiskData : NSObject

@end

@interface VDiskTokenData : NSObject
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, copy, readonly) NSString *expiresIn;
@property (nonatomic, copy, readonly) NSString *timeLeft;
@property (nonatomic, copy, readonly) NSString *uid;
- (void) loadData:(NSDictionary *)dic;
- (void) updateToken:(NSString *)token;
@end

@interface VDiskUserData : NSObject
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, copy, readonly) NSString *thumbAvatar;

@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSString *sianId;
@property (nonatomic, copy, readonly) NSString *uid;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;


- (void) loadData:(NSDictionary *)dic;
@end