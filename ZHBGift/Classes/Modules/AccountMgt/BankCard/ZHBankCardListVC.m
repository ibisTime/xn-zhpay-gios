//
//  ZHBankCardListVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardListVC.h"
#import "ZHBankCardAddVC.h"
#import "ZHBankCardCell.h"
#import "TLPageDataHelper.h"
#import "ZHBankCard.h"
@interface ZHBankCardListVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *bankCardTV;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHBankCardListVC

- (instancetype)init {

    if (self = [super init]) {
        self.isFirst = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.bankCardTV beginRefreshing];
        self.isFirst = NO;
    }

}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"我的银行卡";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    TLTableView *bankCardTV = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    self.bankCardTV = bankCardTV;
    bankCardTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bankCardTV];
    bankCardTV.rowHeight = 140;
    
    //footer
    bankCardTV.tableFooterView = [self footerView];
//    bankCardTV.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无银行卡"];
    
    //
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = bankCardTV;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    [pageDataHelper modelClass:[ZHBankCard class]];
    [bankCardTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            if (weakSelf.banks.count) {
//                self.navigationItem.rightBarButtonItem = nil;
                weakSelf.bankCardTV.tableFooterView = nil;
            } else {
            
                weakSelf.bankCardTV.tableFooterView = [self footerView];
            
            }
            
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [bankCardTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}


- (UIButton *)footerView {

    UIButton *footerV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [footerV addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    //
    UIView *innerFooterV = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 130)];
    innerFooterV.userInteractionEnabled = NO;
    [footerV addSubview:innerFooterV];
    innerFooterV.backgroundColor = [UIColor whiteColor];
    innerFooterV.layer.cornerRadius = 10;
    
    //
    UIImageView *addImageV = [[UIImageView alloc] init];
    [innerFooterV addSubview:addImageV];
    addImageV.image = [UIImage imageNamed:@"account_添加"];
    
    //
    UILabel *addLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor] font:FONT(16)
                                    textColor:[UIColor accountSettingThemeColor]];
    [innerFooterV addSubview:addLbl];
    addLbl.text =  @"添加银行卡";
    
    //
    [addImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(innerFooterV.mas_centerX);
        make.centerY.equalTo(innerFooterV.mas_centerY).offset(-20);
        
    }];
    [addLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addImageV.mas_centerX);
        make.top.equalTo(addImageV.mas_bottom).offset(10);
    }];
    
    return footerV;

}

#pragma mark- 添加银行卡
- (void)add {

    ZHBankCardAddVC *VC= [[ZHBankCardAddVC alloc] init];
    VC.addSuccess = ^(ZHBankCard *card){
    
        [self.bankCardTV beginRefreshing];
        
    };
    [self.navigationController pushViewController:VC animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.banks.count;

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"删除"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                       
                                                                        [self deleteBankCardWithTableView:tableView index:indexPath];
                                                                        
                                                                    }];
    return @[action];

}

//

//
- (void)deleteBankCardWithTableView:(UITableView *)tv index:(NSIndexPath *)indexPath {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802011";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"code"] = self.banks[indexPath.row].code;
    http.parameters[@"userId"] = [ZHUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //
        [self.bankCardTV beginRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    ZHBankCardAddVC *displayAddVC = [[ZHBankCardAddVC alloc] init];
    displayAddVC.bankCard = self.banks[indexPath.row];
    displayAddVC.addSuccess = ^(ZHBankCard *card){
        
        [self.bankCardTV beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:displayAddVC animated:YES];

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *bankCardCellId = @"bankCardCellId";
    ZHBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardCellId];
    if (!cell) {
        cell = [[ZHBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCardCellId];
    }
    cell.bankCard = self.banks[indexPath.row];
    return cell;

}


@end
