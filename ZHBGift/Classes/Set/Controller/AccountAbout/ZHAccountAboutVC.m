//
//  ZHAccountAboutVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountAboutVC.h"
#import "ZHSetGroup.h"
#import "ZHSetCell.h"
#import "ZHPwdRelatedVC.h"
#import "ZHChangeMobileVC.h"
#import "ZHBankCardListVC.h"
#import "ZHAboutUsVC.h"
#import "CDVoicePlayer.h"
#import "ZHRealNameAuthVC.h"

@interface ZHAccountAboutVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray <ZHSetGroup *> *groups;
@property (nonatomic, strong) UITableView *setTableView;
//@property (nonatomic, strong) NSString *realNameLbl;
@end

@implementation ZHAccountAboutVC


//- (UILabel *)lbl {
//    
//    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(LEFT_W, 0, SCREEN_WIDTH - LEFT_W - 30, 44)
//                              textAligment:NSTextAlignmentRight
//                           backgroundColor:[UIColor whiteColor]
//                                      font:FONT(15)
//                                 textColor:[UIColor zh_textColor2]];
//    lbl.xx_size = SCREEN_WIDTH - 35;
//    
//    return lbl;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户安全";
    UITableView *accoutnTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:accoutnTableView];
    accoutnTableView.dataSource = self;
    accoutnTableView.delegate = self;
    self.setTableView = accoutnTableView;
    
    //
    self.groups = @[[self group00]];
    
    //退出登录
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 44) title:@"退出登录" backgroundColor:[UIColor whiteColor]];
    [footerView addSubview:loginOutBtn];
    [loginOutBtn setTitleColor:[UIColor accountSettingThemeColor] forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    accoutnTableView.tableFooterView = footerView;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:kUserInfoChange object:nil];
    
    
}

- (void)userInfoChange {

    [self.setTableView reloadData];

}

- (void)loginOut {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    
}

- (ZHSetGroup *)group00 {

    __weak typeof(self) weakSelf = self;
    ZHSetGroup *group = [[ZHSetGroup alloc] init];
    
    //
    ZHSetItem *bankCardItem = [[ZHSetItem alloc] init];
    bankCardItem.title = @"我的银行卡";
    bankCardItem.action = ^(){
        
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    //
    ZHSetItem *realNameItem = [[ZHSetItem alloc] init];
    realNameItem.title = @"实名认证";
    realNameItem.action = ^(){
        
        ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    
    //
    ZHSetItem *item00 = [[ZHSetItem alloc] init];
    item00.title = @"修改手机号";
    item00.action = ^(){
    
        ZHChangeMobileVC *vc = [[ZHChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };

    ZHSetItem *item01 = [[ZHSetItem alloc] init];
    item01.title = @"修改登录密码";
    item01.action = ^(){
        
        ZHPwdRelatedVC *vc = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeReset];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    ZHSetItem *item02 = [[ZHSetItem alloc] init];
    item02.title = @"修改支付密码";
    item02.action = ^(){
        
        ZHPwdRelatedVC *vc = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    ZHSetItem *aboutUsItem = [[ZHSetItem alloc] init];
    aboutUsItem.title = @"关于我们";
    aboutUsItem.action = ^(){
        
        ZHAboutUsVC *vc = [[ZHAboutUsVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    ZHSetItem *clearItem = [[ZHSetItem alloc] init];
    clearItem.title = @"清除缓存";
    clearItem.action = ^(){
        
        [TLProgressHUD showWithStatus:nil];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            [TLProgressHUD dismiss];
            [TLAlert alertWithSucces:@"清除成功"];
            [weakSelf.setTableView reloadData];

        }];
        
    };
    
    //
    ZHSetItem *voiceHintItem = [[ZHSetItem alloc] init];
    voiceHintItem.title = @"收款提醒";
    voiceHintItem.type = ZHSetItemAccessoryTypeSwitch;
    voiceHintItem.switchAction  = ^(BOOL on){
        
        [CDVoicePlayer player].canPlay = on;
        
    };
    //
    
    group.setItems = @[bankCardItem,realNameItem,item00,item01,item02,aboutUsItem,clearItem];
    return group;
    
}

#pragma mark-- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZHSetItem *item = self.groups[indexPath.section].setItems[indexPath.row];
    if(item.action){
        item.action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark-- dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHSetCellId"];
    
    if (!cell) {
        
        cell = [[ZHSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ceZHSetCellIdll"];
        
    }
    cell.setItem = self.groups[indexPath.section].setItems[indexPath.row];

    //
    if ([cell.setItem.title isEqualToString:@"清除缓存"]) {
        cell.detailTextLabel.font = FONT(15);
        cell.detailTextLabel.textColor = [UIColor textColor];
        
        //计算
        NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
        //
        if (cacheSize >= 1024*1024.0) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",cacheSize/(1024.0*1024)];

            
        } else  {
        
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkb",cacheSize/(1024.0)];
        
        }

    } else if ([cell.setItem.title isEqualToString:@"实名认证"]) {
        
        cell.detailTextLabel.font = FONT(15);
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.text = [ZHUser user].realName ? : @"尚未认证";
        
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZHSetGroup *group = self.groups[section];
    return group.setItems.count;
    
}

@end
