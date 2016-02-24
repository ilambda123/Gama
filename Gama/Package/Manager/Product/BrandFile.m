//
//  BrandFile.m
//  Gama
//
//  Created by Paul on 16/1/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BrandFile.h"
#import "FileUtils+Gama.h"
#import "MZ+NSDictionary.h"

#define kFilePlist @"File.plist"
#define kConfigPlist @"config.plist"

#define kDefaultBrand @"未选择品牌"
#define kDefaultType @"未选择产品类型"
#define kDefaultSkin @"未选择肤质"
#define kPageSize 20


@implementation BrandFile
#pragma mark - 产品列表保存路径
+ (NSString *) filePath
{
    NSString *path = [FileUtils filePath];
    NSString *savePath = [path stringByAppendingPathComponent:kFilePlist];
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [@[] writeToFile:savePath atomically:true];
    }
    return savePath;
}

+ (NSArray *) fileList
{
    NSString *path = [BrandFile filePath];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

#pragma mark - 产品属性路径
+ (NSString *) configKey:(ConfigType)type
{
    NSArray *keys = @[kBrandList,kCosmeticsTypeList,kSkinList];
    return keys[type];
}

+ (NSString *) configPath
{
    NSString *path = [FileUtils filePath];
    NSString *savePath = [path stringByAppendingPathComponent:kConfigPlist];
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        NSDictionary *dic = @{kBrandList : @[kDefaultBrand],
                              kCosmeticsTypeList : @[kDefaultType],
                              kSkinList : @[kDefaultSkin],
                              kLastID : @"0",
                              };
        [dic writeToFile:savePath atomically:true];
    }
    return savePath;
}

+ (NSDictionary *) configDic
{
    NSString *savePath = [BrandFile configPath];
    return [[NSDictionary alloc] initWithContentsOfFile:savePath];
}

+ (NSArray *) configList:(ConfigType)type
{
    NSString *key = [BrandFile configKey:type];
    NSDictionary *configDic = [BrandFile configDic];
    if ([configDic hasKey:key])
    {
        return [configDic getListValue:key];
    }
    return @[];
}

+ (NSArray *) configListRemoveDefaut:(ConfigType)type
{
    NSString *key = [BrandFile configKey:type];
    NSDictionary *configDic = [BrandFile configDic];
    if ([configDic hasKey:key])
    {
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[configDic getListValue:key]];
        NSString *defaultName = [BrandFile configDefault:type];
        if ([list containsObject:defaultName])
        {
            [list removeObject:defaultName];
        }
        return list;
    }
    return @[];
}

+ (NSString *) configDefault:(ConfigType)type
{
    NSString *text = @"";
    switch (type)
    {
        case Brand: text = kDefaultBrand;  break;
        case CosmeticsType: text = kDefaultType;  break;
        case Skin: text = kDefaultSkin;  break;
        default:
            break;
    }
    return text;
}

+ (NSString *) configName:(ConfigType)type
{
    NSString *key = @"";
    switch (type)
    {
        case Brand:         key = @"品牌";    break;
        case CosmeticsType: key = @"产品类型"; break;
        case Skin: key = @"适用肤质"; break;
        default:
            break;
    }
    return key;
}

#pragma mark - Search
+ (NSArray *) searchList:(NSString *)key
{
    NSString *searchRecordKey = kName;
    
    NSArray *configList = [BrandFile configList:Brand];
    if ([configList containsObject:key])
    {
        searchRecordKey = kBrand;
    }
    
    NSArray *list = [BrandFile fileList];
    NSMutableArray *searchList = [[NSMutableArray alloc] init];
    for (NSDictionary *cell in list)
    {
        NSString *value = [cell getValue:searchRecordKey];
        NSRange range = [value rangeOfString:key];
        if (range.length > 0)
        {
            NSString *dataId = [cell getValue:kID];
            [searchList addObject:dataId];
        }
    }
    return searchList;
}

#pragma mark - 获取产品
+ (NSArray *) sortList:(ConfigType)type
{
    NSArray *configList = [BrandFile configList:type];
    NSArray *dataList = [BrandFile fileList];
    if ([dataList count] == 0)
    {
        return nil;
    }
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index<[configList count]; index++)
    {
        [list addObject:@[]];
    }
    
    NSString *key = (type == Brand) ? kBrand : kCosmeticsType;
    for (NSDictionary *cell in dataList)
    {
        NSString *value = [cell getValue:key];
        NSInteger index = [configList indexOfObject:value];
        NSMutableArray *cellList = [[NSMutableArray alloc] initWithArray:list[index]];
        [cellList addObject:[cell getValue:kID]];
        [list replaceObjectAtIndex:index withObject:cellList];
    }
    return list;
}

+ (NSArray *) getList:(NSInteger)page
{
    NSInteger begin = (page - 1) * kPageSize;
    NSArray *list = [BrandFile fileList];
    NSInteger count = [list count];
    if (count <= begin)
    {
        return @[];
    }
    
    NSRange range = NSMakeRange(begin, kPageSize);
    if (count < (begin + kPageSize))
    {
        range = NSMakeRange(begin, count - kPageSize * (page - 1));
    }
    
    NSArray *arr = [list subarrayWithRange:range];
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:20];
    for (NSDictionary *cell in arr)
    {
        NSString *dataId = [cell getValue:kID];
        [dataArr addObject:dataId];
    }
    return dataArr;
}
@end