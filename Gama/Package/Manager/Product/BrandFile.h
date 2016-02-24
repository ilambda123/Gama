//
//  BrandFile.h
//  Gama
//
//  Created by Paul on 16/1/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigType.h"

@interface BrandFile : NSObject
//产品列表保存路径
+ (NSString *) filePath;
+ (NSArray *) fileList;

//产品属性路径
+ (NSString *) configKey:(ConfigType)type;
+ (NSString *) configPath;
+ (NSDictionary *) configDic;
+ (NSArray *) configList:(ConfigType)type;
+ (NSString *) configDefault:(ConfigType)type;
+ (NSString *) configName:(ConfigType)type;
+ (NSArray *) configListRemoveDefaut:(ConfigType)type;

//搜索
+ (NSArray *) searchList:(NSString *)key;

//获取产品
+ (NSArray *) sortList:(ConfigType)type;
+ (NSArray *) getList:(NSInteger)page;

@end
