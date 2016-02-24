//
//  GamaBaseViewController.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"
#import "MJRefresh.h"

@interface GamaBaseViewController ()

@end

@implementation GamaBaseViewController
@synthesize block = _block;
@synthesize headBlock = _headBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page = kStartPage;
    _loadingType = Loading_None;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[StatisticManager shareInstance] pageViewStart:NSStringFromClass([self class])];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[StatisticManager shareInstance] pageViewEnd:NSStringFromClass([self class])];
}

- (void) addBarView
{
    if (_iv)
    {
        [_iv removeFromSuperview];
    }
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSInteger height = [self navBarHieght];
    
    CGRect frame = CGRectMake(0,
                              -statusBarHeight,
                              self.view.bounds.size.width,
                              height);
    _iv = [[UIImageView alloc] initWithFrame:frame];
    [bar addSubview:_iv];
    [_iv setBackgroundColor:[UIColor blackColor]];
    [_iv setAlpha:.8];
    [bar sendSubviewToBack:_iv];
}

#pragma mark - 设置刷新
- (void) setUpFooterRefresh:(UIScrollView *)view
                    refresh:(RefreshBlock)refresh
{
    _block = refresh;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^
                                        {
                                            if (_loadingType == Loading_End)
                                            {
                                                [view.mj_footer endRefreshing];
                                            }
                                            else
                                            {
                                                if (_block)
                                                {
                                                    _block();
                                                }
                                            }
                                        }];
    
    [footer setTitle:@"  " forState:MJRefreshStateIdle];
    [footer setTitle:@"加载ing" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    [footer.stateLabel setFont:FontSize(11 * SCREEN_WIDTH_RATIO)];
    view.mj_footer = footer;
    
    if (isIOS7)
    {
        [view layoutIfNeeded];
    }
}

- (void) setUpHeadRefresh:(UIScrollView *)view
            refreshHeight:(NSInteger)height
                  refresh:(RefreshBlock)refresh
{
    _headBlock = refresh;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^
    {
        if (_headBlock)
        {
            _headBlock();
        }
    }];
    view.mj_header = header;
    [header.lastUpdatedTimeLabel setHidden:true];
//    [header setTitle:@"" forState:MJRefreshStateIdle];
//    [header setTitle:@"" forState:MJRefreshStateRefreshing];
//    [header setTitle:@"" forState:MJRefreshStateNoMoreData];

    
    if (isIOS7)
    {
        [view layoutIfNeeded];
    }
}

- (void) finishHeadRefresh:(UIScrollView *)view;
{
    [view.mj_header endRefreshing];
}

- (void) finishFooterRefresh:(UIScrollView *)view isEnd:(BOOL)isEnd
{
    if (isEnd)
    {
        [view.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [view.mj_footer endRefreshing];
    }
}

- (LoadingType) loadingTypeState:(NSArray *)arr liminSize:(NSInteger)size
{
    return (([arr count] % size) == 0 && [arr count] > 0) ?
            Loading_None:
            Loading_End;
}

- (void) loadingFinish:(NSArray *)addList
            scrollView:(UIScrollView *)view
             liminSize:(NSInteger)size
{
    _loadingType = [self loadingTypeState:addList liminSize:size];
    if (_loadingType == Loading_None)
    {
        _page++;
        [self finishFooterRefresh:view isEnd:false];
    }
    else if (_loadingType == Loading_End)
    {
        [self finishFooterRefresh:view isEnd:true];
    }
    [self finishHeadRefresh:view];
}

- (void) refreshIFHead:(NSMutableArray *)list
{
    if ([list count] > 0 && _page == kStartPage)
    {
        [list removeAllObjects];
    }
}

@end
