//
//  StatisticKey.h
//  CoinConsumer
//
//  Created by Paul on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "GoType.h"

//typedef NS_ENUM(NSInteger, StatisticType)
//{
//    StatisticType_None = 0,
//    StatisticType_Home,
//    StatisticType_Game,
//    StatisticType_ZipCode,
//    
//    StatisticType_GoOn,  //继续上一个统计
//};

//注册Key
#define kBaiduAppKey @"1fd2ce0108"


//不会重复的界面
#define kStarAppEvent       @"start_app"                //启动事件
#define kAddProduct         @"add_pro"                  //添加产品
#define kAddProductSuccess  @"add_pro_success"          //添加产品成功

#define kSearchProduct      @"search_pro"               //搜索产品
#define kUsevDisk           @"use_vDisk"                //使用微盘
#define kUsevDiskRecovery   @"use_vDiskRecovery"         //使用微盘恢复
#define kUsevDiskBackup     @"use_vDiskBackup"          //使用微盘备份
#define kUseBrand           @"usercenter_Brand"         //用户中心使用品牌
#define kUseType            @"usercenter_Type"          //用户中心使用类型
#define kUseSkin            @"usercenter_Skin"          //用户中心使用肤质

#define kHomeEdit           @"home_edit"                //首页修改
#define kHomeShare          @"home_share"               //首页分享
#define kHomeDelete         @"home_delete"              //首页删除

#define kHomeClickIndex     @"home_click_index"         //首页产品点击
#define kPreviewShare       @"pre_share"                //详细页分享

@interface StatisticKey : NSObject
+ (NSDictionary *) eventIdAndInfo; //不会变化的
@end