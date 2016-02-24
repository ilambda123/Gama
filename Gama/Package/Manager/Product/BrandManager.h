//
//  BrandManager.h
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigType.h"

typedef void (^DeleteBlock)(NSString *text);

@class ProductData;
@interface BrandManager : NSObject{}
@property (nonatomic) ProductData *productData;
@property (nonatomic) NSString *previewId;

+ (BrandManager *) shareInstance;
- (void) createNewProduct;
- (void) saveProduct;
- (void) saveEditProduct;
- (void) removeProduct;
- (void) deleteProduct:(NSString *)dataId;

//配置
- (void) updateConfig:(ConfigType)type config:(NSString *)config;
- (void) deleteConfig:(ConfigType)type config:(NSString *)config;
- (void) exchangeConfif:(ConfigType)type
                  index:(NSInteger)root
               desIndex:(NSInteger)index;
- (BOOL) canDelete:(ConfigType)type
            config:(NSString *)config
       deleteBlcok:(DeleteBlock)block;



//获取列表
- (NSArray *) sortList:(ConfigType)type;

- (ProductData *) productData:(NSString *)productId;
- (ProductData *) previewData;

//搜索
- (NSArray *) searchList:(NSString *)key;

//产品属性配置
- (NSString *) configName:(ConfigType)type;
- (NSArray *) configList:(ConfigType)type;
- (NSArray *) configListRemoveDefault:(ConfigType)type;


@end