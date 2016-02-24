//
//  StatisticManager.m
//  CoinConsumer
//
//  Created by Paul on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "StatisticManager.h"
#import "BaiduMobStat.h"
#import "MZ+NSDictionary.h"

@interface StatisticManager ()
{
//    StatisticType _curType;
}
@end

@implementation StatisticManager
static StatisticManager *s_statisticManager = nil;
+ (StatisticManager *)shareInstance
{
    @synchronized(self)
    {
        if (!s_statisticManager)
        {
            s_statisticManager = [[self alloc] init];
        }
    }
    return s_statisticManager;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
//        _curType = StatisticType_None;
    }
    return self;
}


#pragma mark - Reg
- (void) regAppId
{
    BaiduMobStat *manager = [BaiduMobStat defaultStat];
    [manager startWithAppId:kBaiduAppKey];
}

#pragma mark - Even
- (void) onceEvent:(NSString *)eventId
{
    [self onceEvent:eventId eventInfo:[self _textForKey:eventId]];
//    [self onceEvent:eventId type:StatisticType_None];
}

- (void) onceEvent:(NSString *)eventId eventInfo:(NSString *)info
{
    BaiduMobStat *manager = [BaiduMobStat defaultStat];
    [manager logEvent:eventId eventLabel:info];
    
    NSLog(@"百度记录：ID:%@ INFO:%@",eventId,info);
}

//- (void) onceEvent:(NSString *)eventId type:(StatisticType)type
//{
//    if (type == StatisticType_None)
//    {
//        [self onceEvent:eventId eventInfo:[self _textForKey:eventId]];
//    }
//    else
//    {
//        NSString *newKey = [self _newkey:eventId type:type];
//        NSString *info = [self _infoKey:eventId type:type];
//        [self onceEvent:newKey eventInfo:info];
//    }
//}

//- (void) onceEvent:(NSString *)eventId type:(StatisticType)type productId:(NSString *)pId
//{
//    NSArray *indexArr = [StatisticKey indexKey];
//    NSString *newKey = [NSString stringWithFormat:eventId,indexArr[type],pId];
//    
//    indexArr = [StatisticKey infoKey];
//    NSString *codeKey = indexArr[type];
//    NSDictionary *dic = [StatisticKey eventIdAssemble];
//    NSString *assembleTemp = dic[eventId];
//    NSString *assemble = [NSString stringWithFormat:@"%@-%@",codeKey,assembleTemp];
//    NSString *info = [NSString stringWithFormat:assemble,pId];
//    [self onceEvent:newKey eventInfo:info];
//}

- (void) beginEvent:(NSString *)eventId eventInfo:(NSString *)info
{
    BaiduMobStat *manager = [BaiduMobStat defaultStat];
    [manager eventStart:eventId eventLabel:eventId];
}

- (void) endEvent:(NSString *)eventId eventInfo:(NSString *)info
{
    BaiduMobStat *manager = [BaiduMobStat defaultStat];
    [manager eventEnd:eventId eventLabel:eventId];
}

#pragma mark -
- (void) viewStart:(NSString *)name
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:name];
}

- (void) viewEnd:(NSString *)name
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:name];
}

#pragma mark -
- (NSString *) _textForKey:(NSString *)key
{
    NSString *value = [[StatisticKey eventIdAndInfo] getValue:key];
    if ([value isEqualToString:@""])
    {
        value = key;
    }
    return value;
}

//- (NSString *) _newkey:(NSString *)key type:(StatisticType)type
//{
//    NSArray *indexArr = [StatisticKey indexKey];
//    NSString *newKey = [NSString stringWithFormat:key,indexArr[type]];
//    return newKey;
//}
//
//- (NSString *) _infoKey:(NSString *)key type:(StatisticType)type
//{
//    NSArray *indexArr = [StatisticKey infoKey];
//    NSString *codeKey = indexArr[type];
//    NSDictionary *dic = [StatisticKey eventIdAssemble];
//    return [NSString stringWithFormat:@"%@-%@",codeKey,dic[key]];
//}

#pragma mark - 
- (void) pageViewStart:(NSString *)key
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:key];
}

- (void) pageViewEnd:(NSString *)key
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:key];
}

@end