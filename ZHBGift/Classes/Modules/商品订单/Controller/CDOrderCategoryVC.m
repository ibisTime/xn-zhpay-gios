//
//  CDOrderCategoryVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDOrderCategoryVC.h"
#import "CDOrderCell.h"
#import "CDOrderDetaiVC.h"
#import "TLPageDataHelper.h"

@interface CDOrderCategoryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) TLTableView *orderTableView; //订单

@property (nonatomic,strong) NSMutableArray <ZHOrderModel *> *orderModels; //订单
@property (nonatomic, assign) BOOL isFirst;


@end

@implementation CDOrderCategoryVC


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isFirst) {
            
            [self.orderTableView beginRefreshing];
            self.isFirst = NO;
        }

    });
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor orderThemeColor];
    self.isFirst = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    //
    TLTableView *orderTableView = [TLTableView tableViewWithframe:self.view.bounds delegate:self dataSource:self];
    [self.view addSubview:orderTableView];
    
    [orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    orderTableView.rowHeight = 122;;
    self.orderTableView = orderTableView;
    self.orderTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无订单"];
    orderTableView.rowHeight = 150;
    
    //订单列表
    __weak typeof(self) weakself = self;
    TLPageDataHelper *orderDataHelper = [[TLPageDataHelper alloc] init];
    orderDataHelper.code = @"808065";
    //  ORDER_QUERY;
    
    orderDataHelper.isAutoDeliverCompanyCode = NO;
    //此处应该把用户取消的订单去掉
    //  orderDataHelper.parameters[@"status"] = @"effect";
    //    orderDataHelper.parameters[@"toUser"] = [ZHUser user].userId;
    
    //  orderDataHelper.isAutoDeliverCompanyCode = NO;
    //    1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
    switch (self.type) {
        case CDOrderTypeWillSend:
            
            orderDataHelper.parameters[@"statusList"] = @[ORDER_STATUS_WILL_SEND];

            break;
            
        case CDOrderTypeHasSend:
            
            orderDataHelper.parameters[@"statusList"] = @[ORDER_STATUS_HAS_SEND];

            break;
            
        case CDOrderTypeFinshed:
            
            orderDataHelper.parameters[@"statusList"] = @[ORDER_STATUS_HAS_RECEIVER];

            break;

    }
//    orderDataHelper.parameters[@"statusList"] = @[@"2",@"3",@"4",@"92",@"93"];

//    orderDataHelper.parameters[@"statusList"] = @[@"4"];
    
    orderDataHelper.parameters[@"companyCode"] = [ZHUser user].userId;
    
    //    statusList = @[,,]
    [orderDataHelper modelClass:[ZHOrderModel class]];
    orderDataHelper.tableView = self.orderTableView;
    
    //订单列表
    [self.orderTableView addRefreshAction:^{
        
        [orderDataHelper refresh:^(NSMutableArray <ZHOrderModel *>*objs, BOOL stillHave) {
            
            weakself.orderModels = objs;
            [weakself.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    [self.orderTableView addLoadMoreAction:^{
        
        [orderDataHelper loadMore:^(NSMutableArray <ZHOrderModel *>*objs, BOOL stillHave) {
            
            weakself.orderModels = objs;
            [weakself.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
}


#pragma mark- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.orderModels.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat rowH = 150;
    switch (self.type) {
        case CDOrderTypeWillSend:
            rowH = 110;
            
            break;
        case CDOrderTypeHasSend:
            rowH = 140;

            break;
        case CDOrderTypeFinshed:
            rowH = 160;

            break;
            
    }
    
    return rowH + 10;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDOrderDetaiVC *detailVC = [[CDOrderDetaiVC alloc] init];
    detailVC.orderModel = self.orderModels[indexPath.row];
    detailVC.deliverSuccess = ^(){
    
            [self.orderTableView beginRefreshing];
    
    };
    switch (self.type) {
        case CDOrderTypeWillSend:
            detailVC.title = @"待发货详情";
            
            break;
        case CDOrderTypeHasSend:
            detailVC.title = @"待收货详情";

            break;
        case CDOrderTypeFinshed:
            detailVC.title = @"已完成详情";

            break;
            
    }

    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    ZHDeliverGoodsVC *deliverVC = [[ZHDeliverGoodsVC alloc] init];
 
    //    deliverVC.orderModel = self.orderModels[indexPath.row];
    //    [self.navigationController pushViewController:deliverVC animated:YES];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    ZHGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHGoodsCellId"];
    //    if (!cell) {
    //
    //        cell = [[ZHGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHGoodsCellId"];
    //    }
    //
    //    if ([tableView isEqual:self.orderTableView]) {
    //
    //        cell.model = self.orderModels[indexPath.row];
    //
    //    }
    
    CDOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHGoodsCellId"];
    if (!cell) {
        
        cell = [[CDOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHGoodsCellId"];
    }
    
    if ([tableView isEqual:self.orderTableView]) {
        
        cell.orderModel = self.orderModels[indexPath.row];
        
    }
    
    
    return cell;
    
    
}

@end
