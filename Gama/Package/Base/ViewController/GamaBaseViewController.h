//
//  GamaBaseViewController.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController+UINavigationBar.h"
#import "LoadingType.h"
#import "StatisticManager.h"

typedef void (^RefreshBlock)();
@interface GamaBaseViewController : BaseViewController
{
    NSInteger _page;
    LoadingType _loadingType;
    NSMutableArray *_list;
    
    UIImageView *_iv;
}
@property (nonatomic, copy) RefreshBlock block;
@property (nonatomic, copy) RefreshBlock headBlock;

- (void) addBarView;

- (void) loadingFinish:(NSArray *)addList
            scrollView:(UIScrollView *)view
             liminSize:(NSInteger)size;
- (void) refreshIFHead:(NSMutableArray *)list;

- (void) setUpFooterRefresh:(UIScrollView *)view
                    refresh:(RefreshBlock)refresh;
- (void) finishFooterRefresh:(UIScrollView *)view
                       isEnd:(BOOL)isEnd;

- (void) setUpHeadRefresh:(UIScrollView *)view
            refreshHeight:(NSInteger)height
                  refresh:(RefreshBlock)refresh;
- (void) finishHeadRefresh:(UIScrollView *)view;

@end
