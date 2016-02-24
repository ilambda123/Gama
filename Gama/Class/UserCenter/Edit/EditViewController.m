//
//  EditViewController.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "EditViewController.h"
#import "BaseViewController+TableView.h"

#import "AddView.h"
#import "TextCell.h"
#import "AppUtils.h"
#import "UserCenterHeadView.h"

#import "EditHeadView.h"
#import "EditFooterView.h"
#import "Masonry.h"

@interface EditViewController ()
{
    EditHeadView *_headView;
    EditFooterView *_footerView;
}
- (IBAction)_addContentAction:(UIButton *)sender;

@end

@implementation EditViewController
@synthesize type = _type;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createObjects];
    
    NSArray *list = [[BrandManager shareInstance] configListRemoveDefault:_type];
    _list = [[NSMutableArray alloc] initWithArray:list];
    [_tableView reloadData];
    
    UIBarButtonItem *item = [self createItem:@"bt_add" action:@selector(_showAddView)];
    [self.navigationItem setRightBarButtonItem:item];
    
    NSString *key = [[BrandManager shareInstance] configName:_type];
    NSString *name = [NSString stringWithFormat:@"点击添加%@",key];
    [_addBt setTitle:name forState:UIControlStateNormal];
    [_addBt setHidden:[_list count]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteRefreshData object:nil];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_footerView)
    {
        [self layoutFooter:_footerView tableView:_tableView];
    }
}

#pragma mark -
- (void) _createObjects
{
    if (_type != Brand && _type != CosmeticsType)
    {
        return;
    }
    
    _headView = [EditHeadView nodeFormClass];
    [_headView loadType:_type];
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
    
    __weak EditViewController *weakSelf = self;
    _footerView = [EditFooterView nodeFormClass];
    [_footerView loadConfig:_type edit:^(BOOL adjust)
    {
        [weakSelf _editTable:adjust];
    }];
    [_tableView setTableFooterView:_footerView];
}

- (void) _editTable:(BOOL)edit
{
    _isAdjust = edit;
    [_tableView setEditing:_isAdjust animated:true];
}

- (void) _showAddView
{
    AddView *view = [AddView nodeFormClass];
    [view setList:_list];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(self.view);
     }];
    
    __weak EditViewController *weakSelf = self;
    [view finish:^(NSString *text)
    {
        [weakSelf _addText:text];
    }];
}

#pragma mark - 
- (void) _addText:(NSString *)text
{
    [_tableView beginUpdates];
    [_list insertObject:text atIndex:[_list count]];
    NSInteger row = [_list count] - 1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[path]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    
    [[BrandManager shareInstance] updateConfig:_type config:text];
    [_addBt setHidden:[_list count] > 0];
}

- (void) _removeText:(NSString *)text
{
    NSInteger index = [_list indexOfObject:text];
    [_list removeObject:text];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_addBt setHidden:[_list count] > 0];
}

#pragma mark - Click bt
- (IBAction)_addContentAction:(UIButton *)sender
{
    [self _showAddView];
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
    TextCell *cell = (TextCell *)
    [_tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    if (cell == nil)
    {
        cell = [TextCell nodeFormClass];
    }
    [cell loadText:_list[row] remove:nil];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TextCell cellHeight] * SCREEN_WIDTH_RATIO;
}

#pragma mark - TableView Edit
- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
       toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRow = [sourceIndexPath row];
    NSInteger row = [destinationIndexPath row];
    [[BrandManager shareInstance] exchangeConfif:_type
                                           index:sourceRow
                                        desIndex:row];
    [_list exchangeObjectAtIndex:sourceRow withObjectAtIndex:row];
    [_tableView reloadData];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *deleteText = _list[indexPath.row];
        BOOL canDelete = [[BrandManager shareInstance] canDelete:_type
                                                          config:deleteText
                                                     deleteBlcok:^(NSString *text)
        {
            [self _removeText:text];
        }];
        
        if (canDelete)
        {
            [self _removeText:deleteText];
            [[BrandManager shareInstance] deleteConfig:_type config:deleteText];
        }
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
@end