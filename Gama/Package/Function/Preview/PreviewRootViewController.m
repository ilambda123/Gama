//
//  PreviewRootViewController.m
//  XianGu
//
//  Created by Paul on 16/1/29.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "PreviewRootViewController.h"
#import "PreviewView.h"
#import "Masonry.h"

#import "MZ+UIImage.h"
#import "FileUtils.h"
#import "AppUtils.h"
//#import "LoadingAnimationView.h"

//#import "CookBookData.h"

#import "RequestManager.h"
//#import "UserRequest.h"
//#import "CookBookRequest.h"

#define kCollentCookBook @"收藏菜谱"
#define kCollentMaterial @"收藏食材"
#define kSavePhoto @"保存图片"
#define kCancel @"取消"


@interface PreviewRootViewController () <PreviewViewDelegate, RequestManagerDelegate>
{
    NSArray *_sheetList;
    UIImage *_longPushImage;
//    LoadingAnimationView *_loadingView;
}
@end

@implementation PreviewRootViewController
@synthesize delegate = _delegate;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) createView:(NSArray *)images
              texts:(NSArray *)texts
           curIndex:(NSInteger)index
           showRect:(CGRect)rect
{
    CGSize realSize = CGSizeMake(1, 1);
    NSObject *object = images[index];
    if ([object isKindOfClass:[UIImage class]])
    {
        UIImage *image = images[index];
        realSize = [image changeSizeWithLength:rect.size.width equalWidth:true];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        NSString *url = images[index];
        NSString *saveFile = [FileUtils saveImageCachesPath:url];
        UIImage *image = [UIImage imageWithContentsOfFile:saveFile];
        if (image)
        {
            realSize = [image changeSizeWithLength:rect.size.width equalWidth:true];
        }
    }
    
    rect = CGRectMake(rect.origin.x,
                      rect.origin.y + (rect.size.height - realSize.height) / 2,
                      realSize.width,
                      realSize.height);
    
    PreviewView *view = [PreviewView nodeFormClass];
    [view loadData:images texts:texts];
    [view setDelegate:self];
    [self.view addSubview:view];
    
    [view showView:rect curIndex:index];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - PreviewViewDelegate
- (void) previewViewDidBack:(PreviewView *)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(previewRootViewControllerDidBack:)])
    {
        [_delegate previewRootViewControllerDidBack:self];
    }
}

- (void) previewView:(PreviewView *)view didLongPush:(UIImage *)image
{
//    CookBookDetailData *detailData = nil;
//    if ([_data isKindOfClass:[CookBookDetailData class]])
//    {
//        _longPushImage = image;
//        detailData = (CookBookDetailData *)_data;
//    }
//    else
//    {
//        return;
//    }
//    
//    NSMutableArray *list = [[NSMutableArray alloc] init];
//    if (!detailData.isCollect)
//    {
//        [list addObject:kCollentCookBook];
//    }
//    [list addObjectsFromArray:@[kCollentMaterial,kSavePhoto, kCancel]];
//    
////    [list addObjectsFromArray:@[kSavePhoto,kCancel]];
//    _sheetList = [[NSArray alloc] initWithArray:list];
//    
//    __weak PreviewRootViewController *weakSelf = self;
//    [self sheetName:_sheetList
//             action:^(NSInteger index)
//     {
//         [weakSelf _sheetAction:index];
//    }];
}

- (void) _sheetAction:(NSInteger) index
{
    NSString *key = _sheetList[index];
    if ([key isEqualToString:kCancel])
    {
        return;
    }
    else if ([key isEqualToString:kCollentCookBook])
    {
//        CookBookDetailData *detailData = (CookBookDetailData *)_data;
//        CookBookCollectRequest *request = [[CookBookCollectRequest alloc] init];
//        [request setDataId:detailData.dataId];
//        [[RequestManager shareInstance] addRequest:request delegate:self];
//        
//        _loadingView = [LoadingAnimationView showLoading:self.view
//                                                ignoring:false];

    }
    else if ([key isEqualToString:kCollentMaterial])
    {
//        CookBookDetailData *detailData = (CookBookDetailData *)_data;
//        CollectIngredientsRequest *request = [[CollectIngredientsRequest alloc] init];
//        [request setDataId:detailData.dataId];
//        [[RequestManager shareInstance] addRequest:request delegate:self];
//        
//        _loadingView = [LoadingAnimationView showLoading:self.view
//                                                ignoring:false];
    }
    else if ([key isEqualToString:kSavePhoto])
    {
//        [self.view setUserInteractionEnabled:false];
//        _loadingView = [LoadingAnimationView showLoading:self.view
//                                                ignoring:false];
//        [self.view bringSubviewToFront:_loadingView];
//        
//        UIImageWriteToSavedPhotosAlbum(_longPushImage,
//                                       self,
//                                       @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),
//                                       nil);
    }
}

#pragma mark - SaveImage
- (void)imageSavedToPhotosAlbum:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"成功保存到相册";
        [AppUtils showAlert:message inView:self.view];
    }else
    {
        message = @"请在iPhone的“设置-隐私-照片”选择项中，允许鲜咕访问你的照片";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法保存"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil, nil];
        [alertView show];        
    }
//    [_loadingView hideLoading];
//    _loadingView = nil;
    [self.view setUserInteractionEnabled:true];
}

#pragma mark - RequestManagerDelegate
- (void) httpRequsetDidSuccessful:(NSDictionary *)dic type:(NSString *)type
{
//    if ([type sameClass:[CollectIngredientsRequest class]])
//    {
//        [self showAlert:@"采购成功，可以到用户中心-食材清单查看" delegate:nil];
//    }
//    else if ([type sameClass:[CookBookCollectRequest class]])
//    {
//        [AppUtils showAlert:@"收藏成功" inView:self.view];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNoteCollectCB object:nil];
//    }
//    [_loadingView hideLoading];
//    _loadingView = nil;
}

- (void) httpRequsetDidFailed:(NetError *)error type:(NSString *)type
{
//    [_loadingView hideLoading];
//    _loadingView = nil;
}
@end