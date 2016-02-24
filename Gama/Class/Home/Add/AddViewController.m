//
//  AddViewController.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "AddViewController.h"
#import "BaseViewController+TableView.h"
#import "AddHeadView.h"
#import "AddFooterView.h"

#import "AddPicDetailCell.h"
#import "ProductData.h"
#import "BrandManager.h"
#import "AppUtils.h"

#define kAlertExitTag 234

@interface AddViewController ()
<UITableViewDataSource, UITableViewDelegate,
AddFooterViewDelegate, UIAlertViewDelegate, AddHeadViewDelegate>
{
    AddHeadView *_headView;
    AddFooterView *_footerView;
    __weak IBOutlet NSLayoutConstraint *_topLc;
}
- (IBAction)_saveAction:(UIButton *)sender;
@end

@implementation AddViewController
@synthesize dataId = _dataId;
@synthesize editProduct = _editProduct;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createObject];
    [self _reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
}

- (void) _reloadData
{
    [_headView loadData];
    [_tableView reloadData];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutHeadView:_headView tableView:_tableView];
    [self layoutFooter:_footerView tableView:_tableView];
}

#pragma mark -
- (void) _createObject
{
    [_topLc setConstant: -[self navBarHieght]];
    
    _headView = [AddHeadView nodeFormClass];
    [_headView setDelegate:self];
    [_headView setRootVC:self];
    [_headView.layer setZPosition:-1];
    [_tableView setTableHeaderView:_headView];
    
    _footerView = [AddFooterView nodeFormClass];
    [_footerView setDelegate:self];
    [_footerView.layer setZPosition:-1];
    [_tableView setTableFooterView:_footerView];
    
    UIBarButtonItem *item = [self createItem:@"item_back" action:@selector(_backAction:)];
    [self.navigationItem setLeftBarButtonItem:item];
}

#pragma mark - Check
- (BOOL) _checkFinish
{
    BOOL finish = [_headView checkFinish];
    if (finish)
    {
        ProductData *data = [BrandManager shareInstance].productData;
        NSArray *list = data.productDecList;
        for (NSInteger index = 0; index < [list count]; index++)
        {
            ProductDecData *decData = list[index];
            if (![decData hasData])
            {
                [AppUtils showAlert:@"没有记录图片 或者 没有输入描述" inView:self.view];
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                AddPicDetailCell * cell = [_tableView cellForRowAtIndexPath:path];
                if (cell != nil)
                {
                    [_tableView scrollToRowAtIndexPath:path
                                      atScrollPosition:UITableViewScrollPositionMiddle
                                              animated:true];
                    if ([decData.dec length] <= 0)
                    {
                        [cell uploadFail:addDec];
                    }
                    else if (![[NSFileManager defaultManager] fileExistsAtPath:[decData imagePath]])
                    {
                        [cell uploadFail:addImage];
                    }
                }
                return false;
            }
        }
    }
    return finish;
}

#pragma mark - Click bt
- (IBAction)_saveAction:(UIButton *)sender
{
    if ([self _checkFinish])
    {
        if (_editProduct)
        {
            [[BrandManager shareInstance] saveEditProduct];
        }
        else
        {
            [[BrandManager shareInstance] saveProduct];
        }
        [super _backAction:nil];
    }
}

- (IBAction) _backAction:(UIButton *)bt
{
    NSString *title = @"";
    NSString *cancel = @"";
    NSString *ok = @"";
    
    if (!_editProduct)
    {
        title = @"信息将会删除，退出?";
        cancel = @"退出";
        ok = @"保存";
    }
    else
    {
        title = @"保存信息？";
        cancel = @"不保存";
        ok = @"保存";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:ok, nil];
    [alert setTag:kAlertExitTag];
    [alert show];
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    ProductData *data = [BrandManager shareInstance].productData;
    return [data.productDecList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductData *data = [BrandManager shareInstance].productData;
    NSArray *list = data.productDecList;
    
    NSInteger row = indexPath.row;
    AddPicDetailCell *cell = (AddPicDetailCell *)
        [_tableView dequeueReusableCellWithIdentifier:@"AddPicDetailCell"];
    if (cell == nil)
    {
        cell = [AddPicDetailCell nodeFormClass];
    }
    [cell loadData:list[row]];
    [cell setRootVC:self];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AddPicDetailCell cellHeight];
}

#pragma mark - TableView Edit
- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
       toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    ProductData *data = [BrandManager shareInstance].productData;

    NSInteger sourceRow = [sourceIndexPath row];
    NSInteger row = [destinationIndexPath row];
    
    [data.productDecList exchangeObjectAtIndex:sourceRow
                             withObjectAtIndex:row];
    [_tableView reloadData];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ProductData *data = [BrandManager shareInstance].productData;
        [data.productDecList removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];

    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView
            editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

#pragma mark - AddHeadViewDelegate
- (void) addHeadView:(AddHeadView *)view uploadError:(UIView *)moveView
{
    CGRect rc = [_tableView convertRect:moveView.frame toView:_tableView];
    [_tableView scrollRectToVisible:rc animated:true];
}

#pragma mark - AddFooterViewDelegate
- (void) addFooterViewDidAddCell:(AddFooterView *)view
{
    [_tableView beginUpdates];
    ProductData *data = [BrandManager shareInstance].productData;
    [data addProductDecData];
    NSInteger row = [data.productDecList count] - 1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[path]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

- (void) addFooterView:(AddFooterView *)view adjust:(BOOL)adjust
{
    _isAdjust = adjust;
    [_tableView setEditing:adjust animated:true];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [alertView tag];
    switch (tag)
    {
        case kAlertExitTag:
        {
            if (buttonIndex == 1)
            {
                if (_editProduct)
                {
                    if ([self _checkFinish])
                    {
                        [[BrandManager shareInstance] saveEditProduct];
                        [super _backAction:nil];
                    }
                }
                else
                {
                    if ([self _checkFinish])
                    {
                        [[BrandManager shareInstance] saveProduct];
                        [[StatisticManager shareInstance] onceEvent:kAddProductSuccess];
                        [super _backAction:nil];
                    }
                }
            }
            else
            {
                if (buttonIndex == 0 && _editProduct)
                {
                    [super _backAction:nil];
                }
                else if (buttonIndex == 0)
                {
                    [[BrandManager shareInstance] removeProduct];
                    [super _backAction:nil];
                }
            }
        }break;
        default:
            break;
    }
}
@end