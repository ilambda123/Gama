//
//  PreviewProductViewController.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "PreviewProductViewController.h"
#import "BaseViewController+TableView.h"
#import "AddViewController.h"

#import "AddHeadView.h"
#import "AddFooterView.h"

#import "AddPicDetailCell.h"
#import "ProductData.h"

#import "ShareData.h"
#import "ShareWindow.h"
#import "MZ+UIImage.h"
#import "BrandManager.h"
#import "NSNotificationKey.h"

@interface PreviewProductViewController ()
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_topLc;
    AddHeadView *_headView;
    AddFooterView *_footerView;
}
- (IBAction)_shareAction:(UIButton *)sender;
@end

@implementation PreviewProductViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _data = [[BrandManager shareInstance] previewData];
    
    [self _createObject];
    _list = [[NSMutableArray alloc] initWithArray:_data.productDecList];
    [_tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutHeadView:_headView tableView:_tableView];
    [self layoutFooter:_footerView tableView:_tableView];
}

- (void) _createObject
{
    [_topLc setConstant:(-[self navBarHieght])];
    
    _headView = [AddHeadView nodeFormClass];
    [_headView setRootVC:self];
    [_headView previewData:_data];
    [_tableView setTableHeaderView:_headView];
    
    _footerView = [AddFooterView nodeFormClass];
    [_footerView preview:([_data.productDecList count] > 0)];
    [_tableView setTableFooterView:_footerView];
    
    UIBarButtonItem *item = [self createItem:@"item_edit" action:@selector(_editAction)];
    [self.navigationItem setRightBarButtonItem:item];
    
    item = [self createItem:@"item_back" action:@selector(_backAction:)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, _editView.bounds.size.height, 0);
    [_tableView setScrollIndicatorInsets:insets];
    [_tableView setContentInset:insets];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_reloadDataNote)
                                                 name:kNoteRefreshData
                                               object:nil];
}

- (void) _reloadDataNote
{
    _data = [[BrandManager shareInstance] previewData];
    _list = [[NSMutableArray alloc] initWithArray:_data.productDecList];
    [_headView previewData:_data];
    [_tableView reloadData];
}

- (void) _backAction:(UIButton *)bt
{
    [super _backAction:bt];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNoteRefreshData
                                                  object:nil];
}

#pragma mark - Click bt
- (void) _editAction
{
    BrandManager *managar = [BrandManager shareInstance];
    [managar setProductData:_data];
    
    AddViewController *vc = (AddViewController *)
        [self goToStoryBoard:kStoryMain key:kShowAddVC];
    [vc setDataId:managar.productData.dataId];
    [vc setEditProduct:true];
}

- (IBAction)_shareAction:(UIButton *)sender
{
    ShareContentData *data = [[ShareContentData alloc] init];
    data.title = _data.name;
    data.dec = _data.dec;
    data.shareUrl = @"http://www.baidu.com";
    data.style = Style_Image;
    NSString *imagePath = [_data imagePath:_data.cover];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image)
        {
            data.iconImage = image;
            [data setThumbImage:image];
        }
    }
    
    [ShareWindow showShareWindow:data finish:^(ShareViewType type)
     {
     }];
    
    [[StatisticManager shareInstance] onceEvent:kPreviewShare];

}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    AddPicDetailCell *cell = (AddPicDetailCell *)
        [_tableView dequeueReusableCellWithIdentifier:@"AddPicDetailCell"];
    if (cell == nil)
    {
        cell = [AddPicDetailCell nodeFormClass];
    }
    [cell previewData:_list[row]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AddPicDetailCell cellHeight] * SCREEN_WIDTH_RATIO;
}

@end