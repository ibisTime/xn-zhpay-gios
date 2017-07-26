//
//  ZHGoodsListVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/1/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHGoodsListVC.h"
#import "ZHSegmentView.h"
#import "ZHGoodsModel.h"
#import "TLPageDataHelper.h"
#import "ZHGoodsCell.h"
//#import "ZHAddGoodsVC.h"
#import "ZHCategoryManager.h"
#import "CDGoodsAddVC.h"

@interface ZHGoodsListVC ()<UITableViewDelegate, UITableViewDataSource,ZHSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,strong) NSMutableArray <ZHGoodsModel *> *goodsModels; //商品
@property (nonatomic,assign) BOOL isFirst;


//@property (nonatomic,strong) NSMutableArray <ZHGoodsModel *> *treasureModels; //商品
//@property (nonatomic,strong) TLTableView *treasureTableView; //商品

@end

@implementation ZHGoodsListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

//    if (self.isFirst) {
//        
//        self.isFirst = NO;
//        [self.goodsTableView beginRefreshing];
////        [self.treasureTableView beginRefreshing];
//        
//    }
    
}

- (void)addMore {

    
//    ZHAddGoodsVC *addVC = [[ZHAddGoodsVC alloc] init];
//    [self.navigationController pushViewController:addVC animated:YES];
    

    CDGoodsAddVC *addVC = [CDGoodsAddVC new];
    [self.navigationController pushViewController:addVC animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    ZHCategoryManager *categoryManager = [ZHCategoryManager manager];
    [categoryManager getCategorySuccess:^{
        
        [self removePlaceholderView];

        //
        [self getShopCategoryAfter];
        [self.goodsTableView beginRefreshing];
        
    } failure:^{
        
        [self addPlaceholderView];

    }];
    //先获取商品类型
    
 
}


- (void)getShopCategoryAfter {

    
    self.isFirst = YES;
    self.goodsModels = [NSMutableArray array];
    UIBarButtonItem *addMoreItem  = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addMore)];
    self.navigationItem.rightBarButtonItem = addMoreItem;
    
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    bgScrollView.scrollEnabled = NO;
    bgScrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, bgScrollView.height);
    
    //普通商品
    TLTableView *goodsTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:goodsTableView];
    goodsTableView.rowHeight = [ZHGoodsCell rowHeight];
    [self.bgScrollView addSubview:goodsTableView];
    self.goodsTableView = goodsTableView;
    
    //    //一元夺宝商品呢
    //    TLTableView *treasureTableView = [TLTableView tableViewWithframe:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) delegate:self dataSource:self];
    //    [self.view addSubview:treasureTableView];
    //    treasureTableView.rowHeight = [ZHGoodsCell rowHeight];
    //    [self.bgScrollView addSubview:treasureTableView];
    //    self.treasureTableView = treasureTableView;
    
    
    
    ///
    __weak typeof(self) weakself = self;
    TLPageDataHelper *goodsHelper = [[TLPageDataHelper alloc] init];
    goodsHelper.code = @"808025";
    goodsHelper.isAutoDeliverCompanyCode = NO;
    goodsHelper.parameters[@"companyCode"] = [ZHUser user].userId;
    [goodsHelper modelClass:[ZHGoodsModel class]];
    goodsHelper.tableView = self.goodsTableView;
    
    self.goodsTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品\n点击右上角可以进行添加噢"];
    
    [self.goodsTableView addRefreshAction:^{
        
        [goodsHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.goodsModels = objs;
            [weakself.goodsTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [self.goodsTableView addLoadMoreAction:^{
        
        [goodsHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.goodsModels = objs;
            [weakself.goodsTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
    }];


}

- (BOOL)segmentSwitch:(NSInteger)idx {

    [self.bgScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
    
    
    return YES;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//  ZHAddGoodsVC *addVC = [[ZHAddGoodsVC alloc] init];
//  addVC.goods = self.goodsModels[indexPath.row];
//  [self.navigationController pushViewController:addVC animated:YES];
    
    
    CDGoodsAddVC *addVC = [CDGoodsAddVC new];
    addVC.goods = self.goodsModels[indexPath.row];
    [self.navigationController pushViewController:addVC animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if ([tableView isEqual:self.goodsTableView]) {
//        
//        return self.goodsModels.count;
//        
//    }
    return self.goodsModels.count;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHGoodsCellId"];
    if (!cell) {
        
        cell = [[ZHGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZHGoodsCellId"];
    }
    
    
    cell.model = self.goodsModels[indexPath.row];
 
//    if ([tableView isEqual:self.goodsTableView]) {
//        
//        
//    } else {
//        
////        cell.model = self.treasureModels[indexPath.row];
//    
//    }
    
    return cell;
    
}

@end
