//
//  HomeViewController.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseViewController+TableView.h"
#import "AddViewController.h"
#import "UserCenterViewController.h"
#import "PreviewProductViewController.h"

#import "BrandManager.h"
#import "ProductData.h"
#import "HomeCell.h"
#import "NSNotificationKey.h"
#import "SwipeDeleteTableView.h"
#import "HomeHeadView.h"
#import "HomeToolView.h"
#import "HomeTypeWindow.h"

#import "UserCenterHeadView.h"
#import "Masonry.h"
#import "AppUtils.h"

#import "ShareWindow.h"
#import "UpdateUtiles.h"

#define kAlertDeleteTag 2523
#define kAlertUpdateTag 13
#define kAlertForceUpdateTag 134

@interface HomeViewController ()
<UIAlertViewDelegate,HomeToolViewDelegate>
{
    NSString *_deleteId;
    __weak IBOutlet NSLayoutConstraint *_topLc;
    __weak IBOutlet NSLayoutConstraint *_bottomLc;
    HomeHeadView *_headView;
    HomeToolView *_toolView;
    HomeType _curType;
    ConfigType _configType;
    
    NSArray *_configList;
}
- (IBAction)_addProductAction:(UIButton *)sender;
@end

@implementation HomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createObject];
    [self _reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:false];
}

- (void) _createObject
{
    _curType = BrandSort;
    [self setTitle:@"Gama"];
    
    [self addBarView];
    _headView = [HomeHeadView nodeFormClass];
    [_headView setRootVC:self];
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

    _toolView = [HomeToolView nodeFormClass];
    [_toolView setDelegate:self];
    CGSize toolSize = self.navigationController.toolbar.bounds.size;
    [_toolView reloadBounds:self.navigationController.toolbar.bounds];
    [_toolView setCenter:CGPointMake(toolSize.width * 0.5, toolSize.height * 0.5)];
    [self.navigationController.toolbar addSubview:_toolView];
    
    UIBarButtonItem *item = [self createItem:@"bt_add" action:@selector(_showAddVC)];
    [self.navigationItem setRightBarButtonItem:item];
    
    item = [self createItem:@"item_more" action:@selector(_showTypeView)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    [_topLc setConstant:(-[self navBarHieght])];
    [_bottomLc setConstant:(-[self toolHeight])];
    UIEdgeInsets insets = UIEdgeInsetsMake([self navBarHieght], 0, 0, 0);
    [_tableView setScrollIndicatorInsets:insets];
    [_tableView setContentInset:insets];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(_reloadData)
                   name:kNoteRefreshData
                 object:nil];
    
    [center addObserver:self
               selector:@selector(_reloadData)
                   name:kNoteAddData
                 object:nil];
    
    [center addObserver:self
               selector:@selector(_reloadData)
                   name:kNoteDeleteData
                 object:nil];
    
    [self _checkUpdate];
}

- (void) _checkUpdate
{
    if ([UpdateUtiles needUpdate])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                        message:@"有全新版本哦，赶快更新吧！"
                                                       delegate:self
                                              cancelButtonTitle:@"稍后"
                                              otherButtonTitles:@"去更新", nil];
        [alert setTag:kAlertUpdateTag];
        [alert show];
    }
    else if ([UpdateUtiles needForceUpdate])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示"
                                                        message:@"有全新版本哦，赶快更新吧！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert setTag:kAlertForceUpdateTag];
        [alert show];
    }
}

#pragma mark - loadData
- (void) _reloadData
{
    _configType = (ConfigType)(_curType - 1);
    NSArray *list = [[BrandManager shareInstance] sortList:_configType];
    if ([list count] > 0)
    {
        _list = [[NSMutableArray alloc] initWithArray:list];
        _configList = [[BrandManager shareInstance] configList:_configType];
        [_tableView reloadData];
        [_addBt setHidden:[_list count] > 0];
    }
}

#pragma mark - Click bt
- (void) _showAddVC
{
    [[StatisticManager shareInstance] onceEvent:kAddProduct];

    BrandManager *managar = [BrandManager shareInstance];
    [managar createNewProduct];

    AddViewController *vc = (AddViewController *)
        [self goToStoryBoard:kStoryMain key:kShowAddVC];
    [vc setDataId:managar.productData.dataId];
    [vc setEditProduct:false];
    
//    NSString *title = [NSString stringWithFormat:@"添加产品 ID：%@",
//                       managar.productData.dataId];
//    [vc setTitle:title];
    
    [vc setTitle:@"添加产品"];

}

- (void) _showTypeView
{
    __weak HomeViewController *weakSelf = self;
    [HomeTypeWindow showWebWindow:_curType
                                y:[self navBarHieght]
                           finish:^(HomeType type)
     {
         [weakSelf _typeAction:type];
    }];
}

- (void) _typeAction:(HomeType)type
{
    if (type == None)
    {
        return;
    }
    
    if (type == BrandSort || type == TypeSort)
    {
        _curType = type;
        [self _reloadData];
    }
    else if (type == ReviewApp)
    {
        [AppUtils appStoreReview:IOSAppKey];
    }
    else if (type == ShareApp)
    {
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",IOSAppKey];
        NSString *text = [NSString stringWithFormat:@"Gama--你的产品我整理 %@",url];
        
        ShareContentData *data = [[ShareContentData alloc] init];
        data.title = @"Gama -- 你的产品管家";
        data.dec = text;
        data.shareUrl = url;
        data.style = Style_Image;
        UIImage *image = [UIImage imageNamed:@"share_app_icon"];
        if (image)
        {
            data.iconImage = image;
            [data setThumbImage:image];
        }

        [ShareWindow showShareWindow:data
                              finish:^(ShareViewType type)
        {
            
        }];
    }
}

#pragma mark - Click bt
- (IBAction)_addProductAction:(UIButton *)sender
{
    [self _showAddVC];
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_configList count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UserCenterHeadView *view = [UserCenterHeadView nodeFormClass];
    [view loadData:_configList[section]];
    return view;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _list[section];
    return [list count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSArray *list = _list[section];

    HomeCell *cell = (HomeCell *)
    [_tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (cell == nil)
    {
        cell = [HomeCell nodeFormClass];
    }
    [cell loadData:list[row]];
    [cell editAction:^(NSString *dataId)
     {
         BrandManager *managar = [BrandManager shareInstance];
         [managar setPreviewId:dataId];
         [managar setProductData:[managar previewData]];
         
         AddViewController *vc = (AddViewController *)
            [self goToStoryBoard:kStoryMain key:kShowAddVC];
         [vc setDataId:managar.productData.dataId];
         [vc setEditProduct:true];
    }];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeCell cellHeight] * SCREEN_WIDTH_RATIO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSArray *list = _list[section];
    NSString *dataId = list[row];
    
    PreviewProductViewController *vc = (PreviewProductViewController *)
        [self goToStoryBoard:kStoryMain key:kShowPreviewProductVC];
    [vc setTitle:@"产品预览"];
    [[BrandManager shareInstance] setPreviewId:dataId];
    [[StatisticManager shareInstance] onceEvent:kHomeClickIndex];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        NSArray *list = _list[section];
        
        _deleteId = list[row];
        BrandManager *manager = [BrandManager shareInstance];
        ProductData *data = [manager productData:_deleteId];
        NSString *text = [NSString stringWithFormat:@"删除 %@: %@ ？",data.brand, data.name];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert setTag:kAlertDeleteTag];
        [alert show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    
    }
}

#pragma mark - 
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    switch (tag)
    {
        case kAlertDeleteTag:
        {
            if (buttonIndex == 1)
            {
                [[BrandManager shareInstance] deleteProduct:_deleteId];
                _deleteId = nil;
                [[StatisticManager shareInstance] onceEvent:kHomeDelete];
                return;
            }
        }break;
        default:
            break;
    }
    
    if ((tag == kAlertUpdateTag && buttonIndex == 1) ||
        (tag == kAlertForceUpdateTag && buttonIndex == 0))
    {
        [AppUtils openAppStore:kIOSAppId];
    }
}

#pragma mark - HomeToolViewDelegate
- (void) homeToolView:(HomeToolView *)view didClick:(ToolType)type
{
    switch (type)
    {
        case Home:
        {
            [self popToViewController:NSStringFromClass([HomeViewController class])];
        }break;
        case UserCenter:
        {
            BOOL pop = [self popToViewController:NSStringFromClass([UserCenterViewController class])];
            if (!pop)
            {
                [self goToStoryBoard:kStoryUser key:kShowUserCenterVC];
            }
        }; break;
        default:
            break;
    }
}

@end