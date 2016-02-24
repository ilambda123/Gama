//
//  ProductData.m
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "ProductData.h"
#import "FileUtils+Gama.h"
#import <UIKit/UIKit.h>

#define kDefaultBrand @"请选择品牌"
#define kDefaultType @"请选择产品类型"
#define kDefaultSkin @"请选择适合肤质"

@implementation ProductData
@synthesize dataId = _dataId;
@synthesize lastDecId = _lastDecId;
@synthesize filePath = _filePath;

@synthesize cover = _cover;
@synthesize name = _name;
@synthesize dec = _dec;
@synthesize brand = _brand;
@synthesize skin = _skin;
@synthesize cosmeticsType = _cosmeticsType;
@synthesize does = _does;
@synthesize effect = _effect;
@synthesize productDecList = _productDecList;

- (instancetype) initWithDataId:(NSString *)dataId
                       filePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        _dataId = dataId;
        _filePath = filePath;
        _cover = kCover;
        
        _brand = kDefaultBrand;
        _skin = kDefaultSkin;
        _cosmeticsType = kDefaultType;
        
        _dec = @"";
        _does = @"";
        _effect = @"";
        _productDecList = [[NSMutableArray alloc] init];
        
        _lastDecId = @"0";
    }
    return self;
}

- (void) loadData:(NSDictionary *)dic
{
    _dataId = [dic getValue:kID];
    _lastDecId = [dic getValue:kLastDecID];
    _cover = [dic getValue:kCover];
    
    _name = [dic getValue:kName];
    _dec = [dic getValue:kDec];
    _brand = [dic getValue:kBrand];
    _skin = [dic getValue:kSkin];
    _cosmeticsType = [dic getValue:kCosmeticsType];
    _does = [dic getValue:kDoes];
    _effect = [dic getValue:kEffect];
    NSArray *list = [dic getListValue:kProductDecList];
    
    NSMutableArray *decList = [[NSMutableArray alloc] init];
    for (NSDictionary *cell in list)
    {
        ProductDecData *data = [[ProductDecData alloc] init];
        [data loadData:cell filePath:_filePath];
        [decList addObject:data];
    }
    _productDecList = [[NSMutableArray alloc] initWithArray:decList];
}

- (NSDictionary *) getDic
{
    NSMutableArray *decList = [[NSMutableArray alloc] init];
    for (ProductDecData *cell in _productDecList)
    {
        NSString *path = [cell imagePath];
        if (cell.dec == nil || ![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            continue;
        }
        
        [decList addObject:[cell getDic]];
    }
    NSDictionary *dic = @{ kID : _dataId,
                           kLastDecID : _lastDecId,
                           kCover : _cover,
                           
                           kName : _name,
                           kDec : _dec,
                           kBrand : _brand,
                           kSkin : _skin,
                           kCosmeticsType : _cosmeticsType,
                           kDoes : _does,
                           kEffect : _effect,
                           kProductDecList : decList};
    return dic;
}

#pragma mark - Dec
- (void) addProductDecData
{
    NSInteger lastId = [_lastDecId integerValue];
    NSInteger index = (lastId + 1);
    NSString *decId = [[NSString alloc] initWithFormat:@"%ld", (long)index];
    _lastDecId = decId;
    ProductDecData *data = [[ProductDecData alloc] initWithDataId:_dataId
                                                            decId:decId
                                                         filePath:_filePath];
    [_productDecList addObject:data];
}

- (void) updateProductDecData:(ProductDecData *) data
{
    for (ProductDecData *cell in _productDecList)
    {
        if ([cell.dataId isEqualToString:data.decId])
        {
            cell.dec = data.dec;
            return;
        }
    }
}

- (NSArray *) previewDecDatas
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *texts = [[NSMutableArray alloc] init];
    for (ProductDecData *cell in _productDecList)
    {
        NSString *path = [cell imagePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [images addObject:image];
            [texts addObject:cell.dec];
        }
    }
    return @[images, texts];
}

- (NSInteger) decDatasIndex:(NSString *)decId
{
    for (NSInteger index = 0; index < [_productDecList count]; index++)
    {
        ProductDecData *cell =  _productDecList[index];
        if ([cell.decId isEqualToString:decId])
        {
            return index;
        }
    }
    return 0;
}

#pragma mark - Image
- (void) saveImage:(UIImage *)image name:(NSString *)name
{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *savePath = [_filePath stringByAppendingPathComponent:name];
    if ([data writeToFile:savePath atomically:true]){}
}

- (NSString *) imagePath:(NSString *)name
{
    NSString *savePath = [_filePath stringByAppendingPathComponent:name];
    return savePath;
}

- (void) saveConfig:(ConfigType)config text:(NSString *)text
{
    switch (config)
    {
        case Brand: _brand = text; break;
        case CosmeticsType:  _cosmeticsType = text; break;
        case Skin: _skin = text; break;
        default:
            break;
    }
}
@end

@implementation ProductDecData
@synthesize dataId = _dataId;
@synthesize picName = _picName;
@synthesize dec = _dec;
@synthesize decId = _decId;
@synthesize filePath = _filePath;

- (instancetype) initWithDataId:(NSString *)dataId
                          decId:(NSString *)decId
                       filePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        _dataId = dataId;
        _decId = decId;
        _filePath = filePath;
        NSString *name = [NSString stringWithFormat:@"dec_pic_%@",_decId];
        _picName = name;
    }
    return self;
}

- (void) loadData:(NSDictionary *)dic filePath:(NSString *)filePath
{
    _dataId = [dic getValue:kID];
    _dec = [dic getValue:kDec];
    _decId = [dic getValue:kDecID];
    NSString *name = [NSString stringWithFormat:@"dec_pic_%@",_decId];
    _picName = name;
    _filePath = filePath;
}

- (NSDictionary *) getDic
{
    NSDictionary *dic = @{ kID : _dataId,
                           kDecID : _decId,
                           kImageName : _picName,
                           kDec : _dec};
    return dic;
}

- (NSString *) imagePath
{
    NSString *savePath = [_filePath stringByAppendingPathComponent:_picName];
    return savePath;
}

- (BOOL) hasData
{
    NSString *imagePath = [self imagePath];
    BOOL hasImage = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    BOOL hasDec = [_dec length] > 0;
    return (hasDec && hasImage) ||
        (hasImage == false && hasDec == false);
}

@end
