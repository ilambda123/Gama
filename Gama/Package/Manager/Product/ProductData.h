//
//  ProductData.h
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseData.h"
#import "ConfigType.h"

@class UIImage;
@class ProductDecData;
@interface ProductData : BaseData
@property (nonatomic, copy, readonly) NSString *dataId;
@property (nonatomic, copy, readonly) NSString *lastDecId;
@property (nonatomic, copy, readonly) NSString *filePath;

@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dec;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *skin;
@property (nonatomic, copy) NSString *cosmeticsType;
@property (nonatomic, copy) NSString *does;
@property (nonatomic, copy) NSString *effect;

@property (nonatomic, copy) NSMutableArray *productDecList;
- (instancetype) initWithDataId:(NSString *)dataId
                       filePath:(NSString *)filePath;
- (NSDictionary *) getDic;

- (void) addProductDecData;
- (void) updateProductDecData:(ProductDecData *) data;

- (void) saveImage:(UIImage *)image name:(NSString *)name;
- (NSString *) imagePath:(NSString *)name;
- (void) saveConfig:(ConfigType)config text:(NSString *)text;

- (NSArray *) previewDecDatas;
- (NSInteger) decDatasIndex:(NSString *)decId;
@end


@interface ProductDecData : BaseData
@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *dataId;
@property (nonatomic, copy, readonly) NSString *decId;

@property (nonatomic, copy) NSString *picName;
@property (nonatomic, copy) NSString *dec;

- (instancetype) initWithDataId:(NSString *)dataId
                          decId:(NSString *)decId
                       filePath:(NSString *)filePath;
- (void) loadData:(NSDictionary *)dic filePath:(NSString *)filePath;
- (NSDictionary *) getDic;
- (NSString *) imagePath;

- (BOOL) hasData;
@end