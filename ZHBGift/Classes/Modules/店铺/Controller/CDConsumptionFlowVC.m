//
//  ZHBillVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "CDConsumptionFlowVC.h"
#import "TLPageDataHelper.h"


#import "CDOneBillDetailVC.h"
#import "CDConsumptionFlowCell.h"
#import "CDConsumptionModel.h"

@interface CDConsumptionFlowVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <CDConsumptionModel *>*consumptions;
@property (nonatomic,strong) TLTableView *billTV;
@property (nonatomic,assign) BOOL isFirst;



@end

@implementation CDConsumptionFlowVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isFirst) {
        [self.billTV beginRefreshing];
        self.isFirst = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费记录查询";
    
//    if (!self.accountNumber) {
//        NSLog(@"请传入账户编号");
//        return;
//    }
    
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                        delegate:self
                                                      dataSource:self];
    [self.view addSubview:billTableView];
    self.isFirst = YES;
    
    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    billTableView.estimatedRowHeight = 110;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.billTV = billTableView;
    self.billTV.allowsSelection = NO;
    
    //--//
    

    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"808248";
    pageDataHelper.tableView = billTableView;
    pageDataHelper.parameters[@"token"] = [ZHUser user].token;
//    pageDataHelper.parameters[@"userId"] = [ZHUser user].userId;
    pageDataHelper.parameters[@"storeCode"] = [ZHShop shop].code;
//    pageDataHelper.parameters[@"accountNumber"] = self.accountNumber;
    
    [pageDataHelper modelClass:[CDConsumptionModel class]];
    [billTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.consumptions = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [billTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.consumptions = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CDOneBillDetailVC *detailVC = [CDOneBillDetailVC new];
//    detailVC.billModel = self.consumptions[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.bills.count;
    return self.consumptions.count;
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //    return self.bills[indexPath.row].dHeightValue + 110;
//    return 70;
//    
//}

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
    
//    static NSString *billCellId = @"CDBillCellID";
//    CDBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
//    
//    if (!cell) {
//        cell = [[CDBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
//    }
////    cell.billModel = self.bills[indexPath.row];
//    
//    return cell;
    
    CDConsumptionFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDConsumptionFlowCell"];
    if (!cell) {
        
        cell = [[CDConsumptionFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    CDConsumptionModel *model =  self.consumptions[indexPath.row];

    
    cell.userLbl.text = [NSString stringWithFormat:@"消费者：%@",model.userMobile];
    cell.moneyLbl.text = [NSString stringWithFormat:@"消费金额：%@",[model.price convertToRealMoney]] ;
    
//                          支付方式：%@",[model getPayTypeName]
    
    cell.timeLbl.text = [NSString stringWithFormat:@"消费时间：%@",[self.consumptions[indexPath.row].payDatetime convertToDetailDate]];

    
    return cell;
    
    
}

@end
