//
//  ZHOrderVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/1/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHOrderVC.h"
#import "ZHOrderModel.h"
#import "TLPageDataHelper.h"
#import "ZHSegmentView.h"
#import "ZHGoodsCell.h"
#import "CDOrderCell.h"
#import "CDOrderDetaiVC.h"
#import "CDOrderCategoryVC.h"


@interface ZHOrderVC ()<UIScrollViewDelegate,ZHSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*statusArr;

@end


@implementation ZHOrderVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品订单管理";
    
    self.statusArr = @[@1,@0,@0].mutableCopy;
    
    ZHSegmentView *segmentView = [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
//    segmentView.bootomLine.backgroundColor = [UIColor orderThemeColor];
    segmentView.tagNames = @[@"待发货订单",@"待收货订单",@"已完成订单"];
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - segmentView.height)];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    bgScrollView.scrollEnabled = NO;
    bgScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, bgScrollView.height);
    
//    //
    
    CDOrderCategoryVC *willSendVC = [[CDOrderCategoryVC alloc] init];
    [self addChildViewController:willSendVC];
    willSendVC.view.frame = CGRectMake(0, 0, self.bgScrollView.width, self.bgScrollView.height);
    willSendVC.type = CDOrderTypeWillSend;
    [self.bgScrollView addSubview:willSendVC.view];
    
}


- (BOOL)segmentSwitch:(NSInteger)idx {
    
    [self.bgScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
    
    if ([self.statusArr[idx] isEqual:@1]) {
        return YES;
    }
    self.statusArr[idx] = @1;
    
    //
    if (idx == 1) {
        
        CDOrderCategoryVC *hasSendVC = [[CDOrderCategoryVC alloc] init];
        [self addChildViewController:hasSendVC];
        hasSendVC.type = CDOrderTypeHasSend;

        hasSendVC.view.frame = CGRectMake(self.bgScrollView.width, 0, self.bgScrollView.width, self.bgScrollView.height);
        [self.bgScrollView addSubview:hasSendVC.view];
        
    } else if (idx == 2) {
    
        CDOrderCategoryVC *finishSendVC = [[CDOrderCategoryVC alloc] init];
        [self addChildViewController:finishSendVC];
        finishSendVC.type = CDOrderTypeFinshed;

        finishSendVC.view.frame = CGRectMake(2*self.bgScrollView.width, 0, self.bgScrollView.width, self.bgScrollView.height);
        [self.bgScrollView addSubview:finishSendVC.view];
        
    }
    
    
    return YES;
    
}





@end
