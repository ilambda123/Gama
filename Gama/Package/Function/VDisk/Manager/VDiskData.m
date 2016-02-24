//
//  VDiskData.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "VDiskData.h"
#import "MZ+NSDictionary.h"

@implementation VDiskData

@end


@implementation VDiskTokenData
@synthesize accessToken = _accessToken;
@synthesize refreshToken = _refreshToken;
@synthesize expiresIn = _expiresIn;
@synthesize timeLeft = _timeLeft;
@synthesize uid = _uid;
- (void) loadData:(NSDictionary *)dic
{
    _accessToken = [dic getValue:@"access_token"];
    _refreshToken = [dic getValue:@"refresh_token"];
    _expiresIn = [dic getValue:@"expires_in"];
    _timeLeft = [dic getValue:@"time_left"];
    _uid = [dic getValue:@"uid"];
    
    if ([_accessToken length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_accessToken
                                                 forKey:kVDiskToken];
    }
}

- (void) updateToken:(NSString *)token
{
    _accessToken = token;
}
@end

@implementation VDiskUserData
@synthesize avatar = _avatar;
@synthesize thumbAvatar = _thumbAvatar;
@synthesize gender = _gender;
@synthesize location = _location;
@synthesize sianId = _sianId;
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize screenName = _screenName;

- (void) loadData:(NSDictionary *)dic
{
    _avatar = [dic getValue:@"avatar_large"];
    _thumbAvatar = [dic getValue:@"profile_image_url"];
    _gender = [dic getValue:@"gender"];
    _location = [dic getValue:@"location"];
    _sianId = [dic getValue:@"sina_uid"];
    _uid = [dic getValue:@"uid"];
    _name = [dic getValue:@"user_name"];
    _screenName = [dic getValue:@"screen_name"];
    
    if ([_screenName length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_screenName
                                                 forKey:kVDiskName];
    }
}
@end