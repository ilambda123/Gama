//
//  UpdateUtiles.m
//  Gama
//
//  Created by Paul on 16/1/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "UpdateUtiles.h"
#import "AppUtils.h"

#define kNeedUpdateForce @"kNeedUpdateForce"
#define kNeedUpdate @"kNeedUpdate"
#define kNeedUpdateVersion @"kNeedUpdateVersion"

@implementation UpdateUtiles
+ (void) needUpdateVersion:(NSString *)version
{
    [self _needUpdateKey:kNeedUpdate version:version];
}

+ (void) needForceUpdeateVersion:(NSString *)version
{
    [self _needUpdateKey:kNeedUpdateForce version:version];
}

+ (void) _needUpdateKey:(NSString *)key version:(NSString *)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:key];
    [userDefaults setObject:version forKey:kNeedUpdateVersion];
}

+ (void) cancelUpdate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kNeedUpdateVersion];
    [userDefaults removeObjectForKey:kNeedUpdateForce];
    [userDefaults removeObjectForKey:kNeedUpdate];
}

#pragma mark - Need Update
+ (BOOL) needUpdate
{
    return [self _needUpdate:kNeedUpdate];
}

+ (BOOL) needForceUpdate
{
    return [self _needUpdate:kNeedUpdateForce];
}

+ (BOOL) _needUpdate:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *update = [userDefaults objectForKey:key];
    NSString *versionStr = [userDefaults objectForKey:kNeedUpdateVersion];
    
    CGFloat version = [versionStr floatValue];
    CGFloat systemVersion = [[AppUtils getProjectVersion] floatValue];
    if (version == systemVersion)
    {
        return [update boolValue];
    }
    return false;
}
@end
