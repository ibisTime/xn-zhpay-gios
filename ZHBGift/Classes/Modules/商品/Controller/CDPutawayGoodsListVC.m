//
//  CDPutawayGoodsListVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDPutawayGoodsListVC.h"
#import "CDGoodsOnlineCell.h"
#import "TLPageDataHelper.h"
#import "ZHGoodsModel.h"
#import "MJRefresh.h"
#import "CDGoodsAddCell.h"
#import "CDGoodsAddVC.h"

@interface CDPutawayGoodsListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, copy) NSArray <ZHGoodsModel *>*goodsModels;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CDPutawayGoodsListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    

    
}

- (void)refresh {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isFirst) {
            
            [self.collectionV.mj_header beginRefreshing];
            self.isFirst = NO;
            
        }
        
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    self.view.backgroundColor = [UIColor orangeColor];

    CGFloat horizonMargin = 10;
    CGFloat verticalMargin = 10;

    CGFloat w = (SCREEN_WIDTH - 3*horizonMargin)/2.0;
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.itemSize = CGSizeMake(w, 150);
    fl.minimumLineSpacing = horizonMargin;
    fl.minimumInteritemSpacing = horizonMargin;
    fl.sectionInset = UIEdgeInsetsMake(verticalMargin, horizonMargin, verticalMargin, horizonMargin);
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) collectionViewLayout:fl];
    self.collectionV = collectionV;
    collectionV.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:collectionV];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    
    //
    [collectionV registerClass:[CDGoodsOnlineCell class] forCellWithReuseIdentifier:@"CDGoodsOnlineCell"];
    //
    [collectionV registerClass:[CDGoodsAddCell class] forCellWithReuseIdentifier:@"CDGoodsAddCell"];
    
    //
    //加载数据
    ///
    __weak typeof(self) weakself = self;
    TLPageDataHelper *goodsHelper = [[TLPageDataHelper alloc] init];
    goodsHelper.code = @"808025";
    goodsHelper.parameters[@"status"] = GOODS_STATUS_SHANG_JIA;
    goodsHelper.isAutoDeliverCompanyCode = NO;
    goodsHelper.parameters[@"companyCode"] = [ZHUser user].userId;
    [goodsHelper modelClass:[ZHGoodsModel class]];
    
    collectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself.collectionV.mj_footer resetNoMoreData];

        [goodsHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.goodsModels = objs;
            [weakself.collectionV reloadData];
            
            [weakself.collectionV.mj_header endRefreshing];

            if (!stillHave) {
                
                [weakself.collectionV.mj_footer endRefreshingWithNoMoreData];

                
            }
            
        } failure:^(NSError *error) {
            [weakself.collectionV.mj_header endRefreshing];

            
        }];
        
    }];

    
    collectionV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [goodsHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.goodsModels = objs;
            [collectionV reloadData];
            if (stillHave) {
                
                [weakself.collectionV.mj_footer endRefreshing];

            } else {
            
                [weakself.collectionV.mj_footer endRefreshingWithNoMoreData];

            }

        } failure:^(NSError *error) {
            
            [weakself.collectionV.mj_footer endRefreshing];

        }];
        
    }];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refresh_good_list" object:nil];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)refreshList {
    
    [self.collectionV.mj_header beginRefreshing];
    
}

#pragma mark -delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CDGoodsAddVC *vc = [[CDGoodsAddVC alloc] init];

    if (indexPath.row != 0) {
        
        vc.goods = self.goodsModels[indexPath.row - 1];
        
    }
    
    [vc setAddSuccess:^{
        
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1 + self.goodsModels.count;

}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        CDGoodsAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDGoodsAddCell" forIndexPath:indexPath];
        
        return cell;
    }

    CDGoodsOnlineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDGoodsOnlineCell" forIndexPath:indexPath];
    
    cell.goodsModel = self.goodsModels[indexPath.row - 1];
    return cell;

}


@end
