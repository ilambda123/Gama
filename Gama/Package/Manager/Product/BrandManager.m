//
//  BrandManager.m
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BrandManager.h"
#import <UIKit/UIKit.h>
#import "FileUtils+Gama.h"
#import "MZ+NSDictionary.h"
#import "ProductData.h"

#import "BrandFile.h"

#define kAlertDeleteTag 235



typedef NS_ENUM(NSInteger, UpdateConfigType)
{
    ConfigInsert = 1,
    ConfigUpdate,
    ConfigDelete,
};

@interface BrandManager () <UIAlertViewDelegate>
{
    NSString *_deleteKey;
    ConfigType _deleteType;

}
@property (nonatomic, copy) DeleteBlock block;
@end

static BrandManager *s_brandManager = nil;
@implementation BrandManager
@synthesize block = _block;
@synthesize productData = _productData;
@synthesize previewId = _previewId;

+ (BrandManager *)shareInstance
{
    @synchronized(self)
    {
        if (!s_brandManager)
        {
            s_brandManager = [[self alloc] init];
        }
    }
    return s_brandManager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

#pragma mark - 创建新产品
- (void) createNewProduct
{
    NSDictionary *configDic = [BrandFile configDic];
    NSInteger newId = [configDic[kLastID] integerValue] + 1;
    NSString *dataId = [NSString stringWithFormat:@"%ld", (long)newId];
    
    NSString *path = [self _productSavePath:dataId];
    _productData = [[ProductData alloc] initWithDataId:dataId filePath:path];
    [_productData addProductDecData];
}

- (NSString *) _productSavePath:(NSString *)dataId
{
    NSString *path = [FileUtils filePath];
    NSString *productName = [NSString stringWithFormat:@"Product_%@",dataId];
    NSString *savePath = [path stringByAppendingPathComponent:productName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [FileUtils createFilePath:savePath];
    }
    return savePath;
}

#pragma mark - Save
- (void) saveProduct
{
    NSDictionary *dic = [_productData getDic];
    NSString *path = [BrandFile filePath];
    NSMutableArray *list = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [list addObject:dic];
    [list writeToFile:path atomically:true];
    
    NSString *configPath = [BrandFile configPath];
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
    NSInteger newId = [configDic[kLastID] integerValue] + 1;
    NSString *dataId = [NSString stringWithFormat:@"%ld", (long)newId];
    [configDic setValue:dataId forKey:kLastID];
    [configDic writeToFile:configPath atomically:true];
    
    _productData = [[ProductData alloc] initWithDataId:@"0" filePath:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteAddData object:nil];
}

- (void) saveEditProduct
{
    NSDictionary *dic = [_productData getDic];
    NSString *path = [BrandFile filePath];
    NSMutableArray *list = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (NSInteger index = 0; index < [list count]; index++)
    {
        NSDictionary *cell = list[index];
        NSString *dataId = [cell getValue:kID];
        if ([dataId isEqualToString:_productData.dataId])
        {
            [list replaceObjectAtIndex:index withObject:dic];
            break;
        }
    }
    [list writeToFile:path atomically:true];
    _productData = [[ProductData alloc] initWithDataId:@"0" filePath:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteRefreshData object:nil];
}


- (void) removeProduct
{
    if (_productData.dataId)
    {
        NSString *path = [self _productSavePath:_productData.dataId];
        [FileUtils removePath:path];
        _productData = [[ProductData alloc] initWithDataId:@"0" filePath:@""];
    }
}

- (void) deleteProduct:(NSString *)dataId
{
    NSString *filePath = [BrandFile filePath];
    NSMutableArray *list = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    for (NSDictionary *dic in list)
    {
        NSString *dicDataId = [dic getValue:kID];
        if ([dicDataId isEqualToString:dataId])
        {
            NSString *path = [self _productSavePath:dataId];
            [FileUtils removePath:path];
            
            [list removeObject:dic];
            if ([list writeToFile:filePath atomically:true])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoteDeleteData
                                                                    object:nil];
            }
            return;
        }
    }
}

- (ProductData *) productData:(NSString *)productId
{
    NSArray *list = [BrandFile fileList];
    for (NSDictionary *cell in list)
    {
        NSString *dataId = [cell getValue:kID];
        if ([dataId isEqualToString:productId])
        {
            NSString *path = [self _productSavePath:dataId];
            ProductData *data = [[ProductData alloc] initWithDataId:dataId filePath:path];
            [data loadData:cell];
            return data;
        }
    }
    return nil;
}

- (ProductData *) previewData
{
    return [self productData:_previewId];
}

#pragma mark - Config
- (void) updateConfig:(ConfigType)type config:(NSString *)config
{
    [self _updateConfig:type config:config update:ConfigInsert];
}

- (void) deleteConfig:(ConfigType)type config:(NSString *)config
{
    [self _updateConfig:type config:config update:ConfigDelete];
}

- (void) exchangeConfif:(ConfigType)type index:(NSInteger)root desIndex:(NSInteger)index
{
    NSString *key = [NSString stringWithFormat:@"%ld %ld",(long)root,index];
    [self _updateConfig:type config:key update:ConfigUpdate];
}

- (void) _updateConfig:(ConfigType)type
                config:(NSString *)config
                update:(UpdateConfigType)update
{
    [self _updateDefault:type update:ConfigDelete];
    
    NSString *path = [BrandFile configPath];
    NSString *key = [BrandFile configKey:type];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSArray *cellList = [dic getListValue:key];
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:cellList];
    if (update == ConfigDelete && [list containsObject:config])
    {
        [list removeObject:config];
        [self _deleteRecordData:type config:config];
    }
    else if (update == ConfigInsert)
    {
        [list addObject:config];
    }
    else if (update == ConfigUpdate)
    {
        NSArray *indexs = [config componentsSeparatedByString:@" "];
        [list exchangeObjectAtIndex:[indexs[0] integerValue]
                  withObjectAtIndex:[indexs[1] integerValue]];
    }
    [dic setObject:list forKey:key];
    [dic writeToFile:path atomically:true];
    
    [self _updateDefault:type update:ConfigInsert];
}

- (void) _deleteRecordData:(ConfigType)type
                    config:(NSString *)config
{
    if ([_deleteKey length] <= 0)
    {
        return;
    }
    
    NSMutableArray *fileList = [[NSMutableArray alloc] initWithArray:[BrandFile fileList]];
    NSString *keyName = [self configName:type];
    for (NSMutableDictionary *cellDic in fileList)
    {
        NSString *cellKey = @"";
        if (type == Brand)
        {
            cellKey = kBrand;
        }
        else if (type == CosmeticsType)
        {
            cellKey = kCosmeticsType;
        }
        
        NSString *recodeValue = cellDic[cellKey];
        if ([recodeValue isEqualToString:config])
        {
            NSString *value = [NSString stringWithFormat:@"未选择%@",keyName];
            [cellDic setObject:value forKey:cellKey];
        }
    }
    [fileList writeToFile:[BrandFile filePath] atomically:true];
}

- (void) _updateDefault:(ConfigType)type update:(UpdateConfigType)update
{
    NSString *defualt = [BrandFile configDefault:type];
    NSString *path = [BrandFile configPath];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *key = [BrandFile configKey:type];
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:dic[key]];
    
    BOOL save = false;
    if (update == ConfigInsert)
    {
        if (![list containsObject:defualt])
        {
            [list addObject:[BrandFile configDefault:type]];
            save = true;
        }
    }
    else if (update == ConfigDelete)
    {
        if ([list containsObject:defualt])
        {
            [list removeObject:defualt];
            save = true;
        }
    }
    
    if (save)
    {
        [dic setObject:list forKey:key];
        [dic writeToFile:path atomically:YES];
    }
}

- (BOOL) canDelete:(ConfigType)type
            config:(NSString *)config
       deleteBlcok:(DeleteBlock)block
{
    NSInteger count = 0;
    NSArray *list = [BrandFile fileList];
    for (NSDictionary *dic in list)
    {
        NSString *key = @"";
        if (type == Brand)
        {
            key = dic[kBrand];
        }
        else if (type == CosmeticsType)
        {
            key = dic[kCosmeticsType];
        }
        
        if ([key isEqualToString:config])
        {
            count++;
        }
    }
    
    NSString *keyName = [self configName:type];
    NSString *alert = @"";
    if (count > 0)
    {
        _block = block;
        _deleteKey = config;
        _deleteType = type;
        alert = [NSString stringWithFormat:@"产品列表中，有%ld个产品使用了这个%@，删除后该产品的%@将会改为未选择%@", (long)count,keyName,keyName,keyName];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alert
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"删除", nil];
        [alertView setTag:kAlertDeleteTag];
        [alertView show];

        return false;
    }
    return true;;
}

#pragma mark - list
- (NSArray *) sortList:(ConfigType)type
{
    return [BrandFile sortList:type];
}

#pragma mark - Search
- (NSArray *) searchList:(NSString *)key
{
    return [BrandFile searchList:key];
}

#pragma mark - Config
- (NSString *) configName:(ConfigType)type
{
    return [BrandFile configName:type];
}

- (NSArray *) configList:(ConfigType)type
{
    return [BrandFile configList:type];
}

- (NSArray *) configListRemoveDefault:(ConfigType)type
{
    return [BrandFile configListRemoveDefaut:type];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [alertView tag];
    if (tag == kAlertDeleteTag)
    {
        if (buttonIndex == 1)
        {
            if (_block)
            {
                [self deleteConfig:_deleteType config:_deleteKey];
                _block(_deleteKey);
            }
        }
        _block = nil;
        _deleteKey = nil;
        _deleteType = Max;
    }
}
@end