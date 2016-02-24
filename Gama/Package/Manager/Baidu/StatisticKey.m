//
//  StatisticKey.m
//  CoinConsumer
//
//  Created by Paul on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "StatisticKey.h"

@implementation StatisticKey
+ (NSDictionary *) eventIdAndInfo
{
    NSDictionary *dic = @{kStarAppEvent : @"启动事件",
                          kAddProduct : @"添加产品",
                          kAddProductSuccess : @"添加产品成功",
                          kSearchProduct : @"搜索产品",
                          kUsevDisk : @"使用微盘",
                          kUsevDiskRecovery : @"使用微盘恢复",
                          kUsevDiskBackup : @"使用微盘备份",
                          kUseBrand : @"用户中心使用品牌",
                          kUseType : @"用户中心使用类型",
                          kUseSkin : @"用户中心使用肤质",
                          
                          kHomeEdit : @"首页修改",
                          kHomeShare : @"首页分享",
                          kHomeDelete : @"首页删除",
                          kHomeClickIndex : @"首页产品点击",
                          kPreviewShare : @"详细页分享",

                          };
    return dic;
}
@end