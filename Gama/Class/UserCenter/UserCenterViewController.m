//
//  UserCenterViewController.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "UserCenterViewController.h"
#import "EditViewController.h"
#import "TextCell.h"

#import "WebWindow.h"
#import "VDiskManager.h"
#import "RequestManager.h"
#import "SinaVdiskRequest.h"
#import "ZipUtils.h"
#import "FileUtils+Gama.h"
#import "UserCenterHeadView.h"

@interface UserCenterViewController ()
<UITableViewDataSource, UITableViewDelegate, RequestManagerDelegate>

@end

@implementation UserCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我"];
    
    _rootList = @[[self _data:@"品牌" subText:@""],
                  [self _data:@"产品类型" subText:@""],
                  [self _data:@"适用肤质" subText:@""]];
    [self reloadBackUp];
    [self.navigationItem setHidesBackButton:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:false];
}

#pragma mark - data
- (TextCellData *) _data:(NSString *)text subText:(NSString *)subText
{
    TextCellData *data = [[TextCellData alloc] init];
    [data setText:text];
    [data setSubText:subText];
    return data;
}

- (void) reloadBackUp
{
    NSString *userName = [[VDiskManager shareInstance] userName];
    _backUpList = [[NSMutableArray alloc] init];
    [_backUpList addObject:[self _data:@"新浪微盘备份" subText:userName]];
    _centerList = [[NSMutableArray alloc] initWithArray:@[_rootList, _backUpList]];
    [_tableView reloadData];
}

#pragma mark - Request
- (void) _loadVDisk
{
    [[StatisticManager shareInstance] onceEvent:kUsevDisk];
    if ([[VDiskManager shareInstance] hasSinaToken])
    {
        [self _userInfoRequest];
    }
    else
    {
        __weak UserCenterViewController *weakSelf = self;
        [WebWindow showWebWindow:[VDiskManager authoriszeUrl]
                          finish:^(NSString *code, BOOL finish)
         {
             if (finish)
             {
                 [weakSelf _tokenRequest:code];
             }
         }];
    }
}

- (void) _tokenRequest:(NSString *)code
{
    [[RequestManager shareInstance] setHost:@"https://auth.sina.com.cn"];
    AuthorizeTokenRequest *request = [[AuthorizeTokenRequest alloc] init];
    [request setAppKey:kAppKey];
    [request setAppSecret:kAppSecret];
    [request setRedirectUri:kRedirectURI];
    [request setCode:code];
    [[RequestManager shareInstance] addRequest:request delegate:self];
}

- (void) _userInfoRequest
{
    [[RequestManager shareInstance] setHost:@"https://api.weipan.cn/2"];
    VDiskUserInfoRequest *request = [[VDiskUserInfoRequest alloc] init];
    [request setSinaToken:[VDiskManager shareInstance].tokenData.accessToken];
    [[RequestManager shareInstance] addRequest:request delegate:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_centerList count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *list = @[@"产品属性", @"数据备份"];
    UserCenterHeadView *view = [UserCenterHeadView nodeFormClass];
    [view loadData:list[section]];
    return view;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _centerList[section];
    return [list count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = _centerList[indexPath.section];
    NSInteger row = indexPath.row;
    
    TextCell *cell = (TextCell *)
    [_tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    if (cell == nil)
    {
        cell = [TextCell nodeFormClass];
    }
    [cell loadData:list[row]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TextCell cellHeight] * SCREEN_WIDTH_RATIO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        NSInteger row = indexPath.row;
        switch (row) {
            case 0: [[StatisticManager shareInstance] onceEvent:kUseBrand]; break;
            case 1: [[StatisticManager shareInstance] onceEvent:kUseType]; break;
            case 2: [[StatisticManager shareInstance] onceEvent:kUseSkin]; break;
            default:
                break;
        }
        
        TextCellData *data = _centerList[0][row];
        EditViewController *vc = (EditViewController *)
        [self goToStoryBoard:kStoryUser key:kShowUserEditVC];
        [vc setType:(ConfigType)row];
        [vc setTitle:data.text];
    }
    else
    {
        [self _loadVDisk];
    }
}

#pragma mark - RequestManagerDelegate
- (void) httpRequsetDidSuccessful:(NSDictionary *)dic type:(NSString *)type
{
    if ([type sameClass:[AuthorizeTokenRequest class]])
    {
        [self _userInfoRequest];
    }
    else if ([type sameClass:[VDiskUserInfoRequest class]])
    {
        [self reloadBackUp];        
        [self goToStoryBoard:kStoryLogin key:kShowVDiskVC];
    }
}

- (void) httpRequsetDidFailed:(NetError *)error type:(NSString *)type
{
    if ([type sameClass:[AuthorizeTokenRequest class]])
    {
        [self reloadBackUp];
    }
    else if ([type sameClass:[VDiskUserInfoRequest class]])
    {
        [[VDiskManager shareInstance] removeToken];
        [self _loadVDisk];
    }
}
@end