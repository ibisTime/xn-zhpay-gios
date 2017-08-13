//
//  ZHBillVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillVC.h"
#import "TLPageDataHelper.h"
//#import "ZHBillCell.h"
#import "ZHBillModel.h"
#import "CDBillCell.h"
#import "CDOneBillDetailVC.h"
#import "CDBillHistoryVC.h"
#import "ZHUser.h"
#import "AppCopyConfig.h"

@interface ZHBillVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;
@property (nonatomic,assign) BOOL isFirst;


@end

@implementation ZHBillVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {
        [self.billTV beginRefreshing];
        self.isFirst = NO;
    }

}

- (void)lookHistory {

    CDBillHistoryVC *vc = [[CDBillHistoryVC alloc] init];
    vc.accountNumber = self.accountNumber;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日账单";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史查询" style:0 target:self action:@selector(lookHistory)];
 
    if (!self.accountNumber) {
        NSLog(@"请传入账户编号");
        return;
    }
    
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    [self.view addSubview:billTableView];
    self.isFirst = YES;

    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    billTableView.rowHeight = 110;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.billTV = billTableView;
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802524"; //我的流水查询传时间无效
    
//    pageDataHelper.code = @"802520";
//    pageDataHelper.code = @"802531"; //我的历史查询
    
    pageDataHelper.tableView = billTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
    pageDataHelper.parameters[@"type"] =     [AppCopyConfig config].terminalType;

    pageDataHelper.parameters[@"accountNumber"] = self.accountNumber;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    //
//    pageDataHelper.parameters[@"dateStart"] = [formatter stringFromDate:[NSDate date]];
//    pageDataHelper.parameters[@"dateEnd"] = [formatter stringFromDate:[NSDate date]];
    
    
//    pageDataHelper.isAutoDeliverCompanyCode = NO;
//    
//    pageDataHelper.parameters[@"companyCode"] = [ZHShop shop].code;
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
//    pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    [pageDataHelper modelClass:[ZHBillModel class]];
    [billTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [billTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
   
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CDOneBillDetailVC *detailVC = [CDOneBillDetailVC new];
    detailVC.billModel = self.bills[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.bills.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    return self.bills[indexPath.row].dHeightValue + 110;
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *billCellId = @"ZHBillCellID";
//    ZHBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
//    
//    if (!cell) {
//        cell = [[ZHBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
//    }
//    cell.billModel = self.bills[indexPath.row];
//    
//    return cell;
    
    static NSString *billCellId = @"CDBillCellID";
    CDBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
    
    if (!cell) {
        cell = [[CDBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
    }
    cell.billModel = self.bills[indexPath.row];
    
    return cell;
    
}

@end
