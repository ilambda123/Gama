//
//  SearchViewController.m
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SearchViewController.h"
#import "PreviewProductViewController.h"
#import "AddViewController.h"

#import "SearchHeadView.h"
#import "UserCenterHeadView.h"
#import "HomeCell.h"
#import "SearchHistoryCell.h"

#import "BrandManager.h"
#import "ProductData.h"
#import "SearchUtils.h"
#import "MZ+UI.h"
#import "Masonry.h"

@interface SearchViewController ()
<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_topLc;
    __weak IBOutlet NSLayoutConstraint *_bottomLc;
    SearchHeadView *_headView;
    NSMutableArray *_historyList;
    NSArray *_searchList;
    NSArray *_contentList;
}
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"搜 索"];
    [self _createObject];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
}

- (void) _reloadSearchHistory
{
    _historyList = [[NSMutableArray alloc] initWithArray:[SearchUtils recodeSearchList]];
    _searchList = @[_historyList,_contentList];
    [_tableView reloadData];
}

- (void) _createObject
{
    _contentList = @[];
    
    __weak SearchViewController *weakSelf = self;
    _headView = [SearchHeadView nodeFormClass];
    [_headView search:^(NSString *key)
     {
         [weakSelf _recordHistroyKey:key];
    }];
    [_tableView setTableHeaderView:_headView];
    NSInteger height = _headView.bounds.size.height * SCREEN_WIDTH_RATIO;
    [_headView setFrame:CGRectMake(0,0,self.view.bounds.size.width,height)];
    if (!isIOS7)
    {
        [_headView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(0);
             make.left.mas_equalTo(0);
             make.right.mas_equalTo(0);
             make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, height));
         }];
    }
    
    [_topLc setConstant:(-[self navBarHieght])];
    [_bottomLc setConstant:(-[self toolHeight])];
    UIEdgeInsets insets = UIEdgeInsetsMake([self navBarHieght], 0, 0, 0);
    [_tableView setScrollIndicatorInsets:insets];
    [_tableView setContentInset:insets];
    
    [self _reloadSearchHistory];
}

#pragma mark - Click bt
- (void) _removeHistroyKey:(NSString *)key
{
    [_headView hideKeyBoard];
    
    NSInteger index = [_historyList indexOfObject:key];
    [_historyList removeObject:key];
    [SearchUtils removeSearch:key];
    
    if ([_historyList count] == 0)
    {
        [_tableView reloadData];
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) _recordHistroyKey:(NSString *)key
{
    [[StatisticManager shareInstance] onceEvent:kSearchProduct];
    
    NSArray *list = [[BrandManager shareInstance] searchList:key];
    _contentList = [[NSMutableArray alloc] initWithArray:list];
    
    [SearchUtils recodeSearch:key];
    if ([_historyList containsObject:key])
    {
        [_historyList removeObject:key];
    }
    [_historyList insertObject:key atIndex:0];
    
    _searchList = @[_historyList,_contentList];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_searchList count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleList = @[@"搜索历史",@"搜索结果"];
    UserCenterHeadView *view = [UserCenterHeadView nodeFormClass];
    [view loadData:titleList[section]];
    return view;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _searchList[section];
    if (section == 0)
    {
        return MIN(3, [list count]);
    }
    return [list count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tempCell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        SearchHistoryCell *cell = (SearchHistoryCell *)
        [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
        if (cell == nil)
        {
            cell = [SearchHistoryCell nodeFormClass];
        }
        
        __weak SearchViewController *weakSelf = self;
        [cell setTitle:_historyList[row] removeAction:^(NSString *key)
         {
             [weakSelf _removeHistroyKey:key];
         }];
        tempCell = cell;
    }
    else if (section == 1)
    {
        HomeCell *cell = (HomeCell *)
        [_tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        if (cell == nil)
        {
            cell = [HomeCell nodeFormClass];
        }
        [cell loadData:_contentList[row]];
        [cell hideBts:true];
        tempCell = cell;
    }
    return tempCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = [SearchHistoryCell cellHeight];
    if (indexPath.section == 1)
    {
        height = [HomeCell cellHeight];
    }
    return height * SCREEN_WIDTH_RATIO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_headView hideKeyBoard];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        NSString *key = _historyList[row];
        [self _recordHistroyKey:key];
    }
    else
    {
        NSString *dataId = _contentList[row];
        
        PreviewProductViewController *vc = (PreviewProductViewController *)
        [self goToStoryBoard:kStoryMain key:kShowPreviewProductVC];
        [vc setTitle:@"产品预览"];
        [[BrandManager shareInstance] setPreviewId:dataId];
    }
}
@end
