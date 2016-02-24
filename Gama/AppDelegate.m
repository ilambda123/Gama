//
//  AppDelegate.m
//  Gama
//
//  Created by Paul on 15/12/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseAppDelegate.h"


#import "MZ+UINavigationItem.h"
#import "FileUtils+Gama.h"
#import "ShareManager.h"
#import "AppUtils.h"
#import "NSNotificationKey.h"
#import "NotificationManager.h"

#import "UpdateUtiles.h"
#import "StatisticManager.h"

#define kAlertUpdateTag 13
#define kAlertForceUpdateTag 134

@interface AppDelegate () <UIAlertViewDelegate>
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0;
    [FileUtils createGamaNeedFilePath];
    
    UIColor *color = [UIColor colorWithRed:19.0 / 255.0
                                     green:190.0 / 255.0
                                      blue:236.0 / 255.0
                                     alpha:1.0];

    [BaseAppDelegate navBarTitlFontSize:18 color:color];
    [BaseAppDelegate transparentBars];
    [BaseAppDelegate resetBackBtImageName:@"item_back"
                                   insets:UIEdgeInsetsMake(0, 30, 0, 0)
                                withTitle:false];
    
    [[NotificationManager shareInstance] regJPush:launchOptions];
    [[StatisticManager shareInstance] regAppId];
    [[StatisticManager shareInstance] onceEvent:kStarAppEvent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    if ([AppUtils isShare])
    {
        [AppUtils removeShareStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoteShareFail
                                                            object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 4.0到9.0使用这个
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [[ShareManager shareInstance] applicationOpenUrl:url];
    return true;
}

#pragma mark - 9.0以上要使用这个
- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<NSString *,id> *)options
{
    [[ShareManager shareInstance] applicationOpenUrl:url];
    return true;
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[NotificationManager shareInstance] showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - 消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *eviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"1----  %@",eviceToken);
    [[NotificationManager shareInstance] registerDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NotificationManager shareInstance] handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[NotificationManager shareInstance] handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSString *version = [AppUtils getProjectVersion];
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSRange range = [message rangeOfString:version];
    if (range.length > 0)
    {
        [UpdateUtiles needUpdateVersion:version];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"稍后"
                                              otherButtonTitles:@"去更新", nil];
        [alert setTag:kAlertUpdateTag];
        [alert show];
    }
    
    range = [message rangeOfString:[version stringByAppendingString:@"~"]];
    if (range.length > 0)
    {
        [UpdateUtiles needForceUpdeateVersion:version];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert setTag:kAlertForceUpdateTag];
        [alert show];
    }
    
    range = [message rangeOfString:[version stringByAppendingString:@"不用更新"]];
    if (range.length > 0)
    {
        [UpdateUtiles cancelUpdate];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Regist fail%@",error);
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [alertView tag];
    if ((tag == kAlertUpdateTag && buttonIndex == 1) ||
        (tag == kAlertForceUpdateTag && buttonIndex == 0))
    {
        [AppUtils openAppStore:kIOSAppId];
    }
}
@end
