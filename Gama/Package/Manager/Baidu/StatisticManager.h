//
//  StatisticManager.h
//  CoinConsumer
//
//  Created by Paul on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticKey.h"

@interface StatisticManager : NSObject

+ (StatisticManager *) shareInstance;
- (void) regAppId;
//一次性统计
- (void) onceEvent:(NSString *)eventId;
//- (void) onceEvent:(NSString *)eventId type:(StatisticType)type;
- (void) onceEvent:(NSString *)eventId eventInfo:(NSString *)info;
//- (void) onceEvent:(NSString *)eventId type:(StatisticType)type productId:(NSString *)pId;

//事件时长统计
- (void) beginEvent:(NSString *)eventId eventInfo:(NSString *)info;
- (void) endEvent:(NSString *)eventId eventInfo:(NSString *)info;

//页面统计
- (void) viewStart:(NSString *)name;
- (void) viewEnd:(NSString *)name;

- (void) pageViewStart:(NSString *)key;
- (void) pageViewEnd:(NSString *)key;
@end
