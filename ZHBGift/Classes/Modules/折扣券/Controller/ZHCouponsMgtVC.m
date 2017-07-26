//
//  ZHCouponsMgtVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCouponsMgtVC.h"
#import "ZHCouponsAddVC.h"
#import "CDCouponCell.h"
#import "TLPageDataHelper.h"
#import "ZHCoupon.h"
#import "ZHShop.h"

@interface ZHCouponsMgtVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *couponsTableView;
@property (nonatomic,strong) NSMutableArray <ZHCoupon *>*coupons; //优惠券
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) BOOL isAdding; //


@end

@implementation ZHCouponsMgtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抵扣券管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"增加"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    _isFirst = YES;
    

    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = [CDCouponCell rowHeight];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无抵扣券"];
    self.couponsTableView = tableView;
    
    __weak typeof(self) weakself = self;
    TLPageDataHelper *goodsHelper = [[TLPageDataHelper alloc] init];
    goodsHelper.code = @"808255";
    goodsHelper.parameters[@"storeCode"] = [ZHShop shop].code;
    
    [goodsHelper modelClass:[ZHCoupon class]];
    [self.couponsTableView addRefreshAction:^{
        
        [goodsHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakself.couponsTableView resetNoMoreData_tl];
            weakself.coupons = objs;
            [weakself.couponsTableView reloadData_tl];
            [weakself.couponsTableView endRefreshHeader];
            if (!stillHave) {
                [weakself.couponsTableView endRefreshingWithNoMoreData_tl];
            }
            
        } failure:^(NSError *error) {
            
            [weakself.couponsTableView endRefreshHeader];
            
        }];
        
    }];
    
    [self.couponsTableView addLoadMoreAction:^{
        
        [goodsHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.coupons = objs;
            
            [weakself.couponsTableView reloadData_tl];
            [weakself.couponsTableView endRefreshFooter];
            if (!stillHave) {
                [weakself.couponsTableView endRefreshingWithNoMoreData_tl];
            }
            
            
        } failure:^(NSError *error) {
            
            [weakself.couponsTableView endRefreshFooter];
            
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (_isFirst) {
        [self.couponsTableView beginRefreshing];
        _isFirst = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHCouponsAddVC *vc = [[ZHCouponsAddVC alloc] init];
    vc.coupon = self.coupons[indexPath.row];
    vc.addSuccess = ^(){
    
        [self.couponsTableView beginRefreshing];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * couponsCellId = @"couponsCellId";
    CDCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsCellId];
    
    if (!cell) {
        cell = [[CDCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsCellId];
    }
    cell.coupon = self.coupons[indexPath.row];
    return cell;
}

//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return nil;
//    
//    ZHCoupon *coupon = self.coupons[indexPath.row];
//    if (![coupon.status isEqualToString:@"91"]) {
//        
//        return nil;
//    }
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"808221";
//        http.parameters[@"code"] = coupon.code;
//        http.parameters[@"token"] = [ZHUser user].token;
//        
//        [http postWithSuccess:^(id responseObject) {
//            
//          [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//
//    }];
//    return @[deleteAction];
//
//
//}

#pragma mark- 添加抵扣券时间
- (void)add {

    ZHCouponsAddVC *vc = [[ZHCouponsAddVC alloc] init];
    vc.addSuccess = ^(){
    
        [self.couponsTableView beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
