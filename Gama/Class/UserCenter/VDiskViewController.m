//
//  VDiskViewController.m
//  Gama
//
//  Created by Paul on 16/1/9.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "VDiskViewController.h"
#import "UserCenterViewController.h"
#import "TextCell.h"

#import "MBProgressHUD.h"
#import "UserCenterHeadView.h"

#import "FileUtils+Gama.h"
#import "ZipUtils.h"
#import "AppUtils.h"

#import "RequestManager.h"
#import "VDiskManager.h"
#import "SinaVdiskRequest.h"

#define kAlertLogoutTag 123
#define kAlertUploadTag 342
#define kAlertRecoveryTag 235

@interface VDiskViewController ()
<RequestManagerDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_topLc;
    MBProgressHUD *_hud;
}
@end

@implementation VDiskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _list = [[NSMutableArray alloc] initWithArray:
             @[@[@"备份本地数据",@"恢复还原数据"],@[@"退出"]]];
    [_tableView reloadData];
    
    [_topLc setConstant:(-[self navBarHieght])];
    UIEdgeInsets insets = UIEdgeInsetsMake([self navBarHieght], 0, 0, 0);
    [_tableView setScrollIndicatorInsets:insets];
    [_tableView setContentInset:insets];
    
    [self setTitle:@"新浪微盘"];
    
    [self _filesRequest];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:true];
}


#pragma mark - Request
- (void) _filesRequest
{
    [[RequestManager shareInstance] setHost:@"https://api.weipan.cn/2"];
    VDiskFilesRequest *request = [[VDiskFilesRequest alloc] init];
    [request setSinaToken:[VDiskManager shareInstance].tokenData.accessToken];
    [[RequestManager shareInstance] addRequest:request delegate:self];
}

- (void) _createFolder:(NSString *)name
{
    [[RequestManager shareInstance] setHost:@"https://api.weipan.cn/2"];
    VDiskCreateFolderRequest *request  = [[VDiskCreateFolderRequest alloc] init];
    [request setSinaToken:[VDiskManager shareInstance].tokenData.accessToken];
    [request setFolderName:name];
    [[RequestManager shareInstance] addRequest:request delegate:self];
}

#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_list count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *list = @[@"网盘功能", @"用户设置"];
    UserCenterHeadView *view = [UserCenterHeadView nodeFormClass];
    [view loadData:list[section]];
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
    TextCell *cell = (TextCell *)
    [_tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    if (cell == nil)
    {
        cell = [TextCell nodeFormClass];
    }
    
    [cell loadText:list[row]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TextCell cellHeight] * SCREEN_WIDTH_RATIO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *alertText = @"";
    NSString *okText = @"";
    NSInteger tag = 0;
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (row == 0 && section == 0)
    {
        alertText = @"把数据备份上微盘，将会覆盖微盘上的的Gama备份？";
        okText = @"确定";
        tag = kAlertUploadTag;
    }
    else if (row == 1 && section == 0)
    {
        alertText = @"恢复数据，将会覆盖本地数据？";
        okText = @"确定";
        tag = kAlertRecoveryTag;
    }
    else if (row == 0 && section == 1)
    {
        alertText = @"退出当前账号？";
        okText = @"退出";
        tag = kAlertLogoutTag;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertText
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:okText, nil];
    [alert setTag:tag];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1)
    {
        return;
    }
    
    NSInteger tag = [alertView tag];
    switch (tag)
    {
        case kAlertLogoutTag:
        {
            [[VDiskManager shareInstance] removeToken];
            [self _backToUserVCAndReload];
        }break;
        case kAlertRecoveryTag:
        {
            [self _recoveryRequest];
        }break;
        case kAlertUploadTag:
        {
            __weak VDiskViewController *weakSelf = self;
            NSString *path = [[FileUtils filePath] stringByDeletingLastPathComponent];
            [ZipUtils zipFileDefaultData:path block:^(BOOL finish, NSString *filePath)
             {
                 [weakSelf _backupRequest];
             }];
        }break;
        default:
            break;
    }
}

- (void) _backToUserVCAndReload
{
    UserCenterViewController *vc = (UserCenterViewController *)
        [self popBackToViewController:NSStringFromClass([UserCenterViewController class])];
    if (vc)
    {
        [vc reloadBackUp];
    }
}


#pragma mark - tip view
- (void) _tipStart:(NSString *)text
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_hud setMode:MBProgressHUDModeIndeterminate];
    [_hud setLabelText:text];
}

- (void) _tipProgress:(NSString *)text progress:(float)progress
{
    NSString *pro = [NSString stringWithFormat:@"%ld",(long)(progress * 100)];
    [_hud setLabelText:[NSString stringWithFormat:@"%@ %@%%",text, pro]];
}

- (void) _tipFinish
{
    [MBProgressHUD hideHUDForView:self.view animated:true];
    _hud = nil;
}

#pragma mark - back up
- (void) _backupRequest
{
    NSString *path = [[FileUtils filePath] stringByDeletingLastPathComponent];
    NSString *file = [path stringByAppendingPathComponent:@"File.zip"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        [[StatisticManager shareInstance] onceEvent:kUsevDiskBackup];
        [self _tipStart:@"备份 0%"];
        
        VDiskUploadRequest *request = [[VDiskUploadRequest alloc] init];
        NSString *api = [request.apiUrl stringByAppendingPathComponent:@"Game_Back_Up.zip"];
        
        [request setApiUrl:api];
        [request setFilePath:file];
        [request setSinaToken:[VDiskManager shareInstance].tokenData.accessToken];

        __weak VDiskViewController *weakSelf = self;
        [[VDiskManager shareInstance] putRequest:request
                                        progress:^(float progress)
        {
            [weakSelf _tipProgress:@"备份中" progress:progress];
        }
            result:^(ResultType type)
        {
            [weakSelf _tipFinish];
            if (ResultType_Success == type)
            {
                [AppUtils showAlert:@"备份成功" inView:self.view];
            }
            else
            {
                [AppUtils showAlert:@"备份失败，请重试" inView:self.view];
            }
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }];
    }
}

- (void) _recoveryRequest
{
    [[StatisticManager shareInstance] onceEvent:kUsevDiskRecovery];
    [self _tipStart:@"恢复中 0%"];
    
    VDiskRecoveryRequest *request = [[VDiskRecoveryRequest alloc] init];
    NSString *api = [request.apiUrl stringByAppendingPathComponent:@"Game_Back_Up.zip"];
    [request setApiUrl:api];
    [request setSinaToken:[VDiskManager shareInstance].tokenData.accessToken];
    
    __weak VDiskViewController *weakSelf = self;
    [[VDiskManager shareInstance] getRequest:request progress:^(float progress)
    {
        [weakSelf _tipProgress:@"恢复中" progress:progress];
    } result:^(ResultType type)
    {
        [weakSelf _tipFinish];

        if (ResultType_Success == type)
        {
            [AppUtils showAlert:@"还原成功" inView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoteAddData object:nil];
        }
        else
        {
            [AppUtils showAlert:@"网盘上不存在此文件 或 网络问题" inView:self.view];
        }

    }];
}


#pragma mark - 
- (void) httpRequsetDidSuccessful:(NSDictionary *)dic type:(NSString *)type
{}

- (void) httpRequsetDidFailed:(NetError *)error type:(NSString *)type
{}
@end