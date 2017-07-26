//
//  CDGoodsMgtVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsMgtVC.h"
#import "ZHSegmentView.h"
#import "CDPutawayGoodsListVC.h"
#import "CDOutOfStockListVC.h"
#import "ZHCategoryManager.h"

@interface CDGoodsMgtVC ()<ZHSegmentViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) CDOutOfStockListVC *outOfStockVC;


@end

@implementation CDGoodsMgtVC




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    ZHCategoryManager *categoryManager = [ZHCategoryManager manager];
    [categoryManager getCategorySuccess:^{
        
        [self removePlaceholderView];
        
        //
        [self getShopCategoryAfter];
        
    } failure:^{
        
        [self addPlaceholderView];
        
    }];
    //先获取商品类型

    
}

- (void)getShopCategoryAfter {

    
    ZHSegmentView *segmentView = [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    [segmentView layoutIfNeeded];
    segmentView.tagNames = @[@"在线商品",@"下架商品"];
    segmentView.bootomLine.backgroundColor = [UIColor goodsThemeColor];

    //
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - segmentView.yy)];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    self.bgScrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, bgScrollView.height);;
    self.bgScrollView.scrollEnabled = NO;
    
    
    //左上架
    CDPutawayGoodsListVC *listVC = [CDPutawayGoodsListVC new];
    [self addChildViewController:listVC];
    listVC.view.frame = CGRectMake(0, 0, bgScrollView.width, bgScrollView.height);
    [bgScrollView addSubview:listVC.view];
    [listVC refresh];
    
    //右下架
    CDOutOfStockListVC *outOfStockListVC = [CDOutOfStockListVC new];
    [self addChildViewController:outOfStockListVC];
    outOfStockListVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, bgScrollView.width, bgScrollView.height);
    [bgScrollView addSubview:outOfStockListVC.view];
    self.outOfStockVC = outOfStockListVC;

}

- (BOOL)segmentSwitch:(NSInteger)idx {

    //
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * idx, 0)];
    
    if (idx == 1) {
        
        [self.outOfStockVC refresh];

    }

    return YES;
    
}

@end
