//
//  CDShopMgtVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopMgtVC.h"
#import "CDShopMgtType1View.h"
#import "CDShopMgtType2View.h"
#import "CDShopMgtTopBottomView.h"
#import "CDShopInfoChangeVC.h"
#import "ZHCouponsMgtVC.h"
#import "CDFenHongQuanVC.h"
#import "CDProfitAndCountModel.h"
#import "ZHShopUpgradeVC.h"
#import "CDConsumptionFlowVC.h"
#import "ZHSJIntroduceVC.h"

@interface CDShopMgtVC ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
//店铺装修
@property (nonatomic, strong) CDShopMgtType1View *shopFitUpView;
@property (nonatomic, strong) UISwitch *shopStatusSwitch;

//店铺升级
@property (nonatomic, strong) CDShopMgtType1View *shopLeveUpView;


//抵扣券管理
//@property (nonatomic, strong) CDShopMgtType2View *couponMgtView;

//我的收益
@property (nonatomic, strong) CDShopMgtTopBottomView *profitPoolMoneyView;
@property (nonatomic, strong) CDShopMgtTopBottomView *profitTotalCountView;

@property (nonatomic, strong) CDShopMgtTopBottomView *mineProfitMoneyView;
@property (nonatomic, strong) CDShopMgtTopBottomView *mineProfitCountView;

////抵扣券
//@property (nonatomic, strong) NSNumber *hasSellCount;
//@property (nonatomic, strong) NSNumber *usedCount; //已使用
//@property (nonatomic, strong) NSNumber *outOfDateCount; //


@property (nonatomic, strong) CDProfitAndCountModel *profitAndCountModel;
@end

@implementation CDShopMgtVC {

    dispatch_group_t _group;

}

- (void)viewDidLoad {
    
  [super viewDidLoad];
  self.title = @"店铺管理";
    _group = dispatch_group_create();
//  [self.navigationController.navigationBar setBarTintColor:[UIColor themeColor]];

    self.profitAndCountModel = [CDProfitAndCountModel new];
  
  //先加载店铺信息
  [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
  [self tl_placeholderOperation];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopInfoChange) name:kShopInfoChange object:nil];
     
}


- (void)shopInfoChange {
    
    [self initData];
    
}

- (void)tl_placeholderOperation {

    __block NSInteger successCount = 0;
    NSInteger reqCount = 0;
    
    [TLProgressHUD showWithStatus:nil];
    reqCount ++;
    dispatch_group_enter(_group);
    [[ZHShop shop] getShopInfoSuccess:^(NSDictionary *shopDict) {
        dispatch_group_leave(_group);
        successCount ++;
        

    } failure:^(NSError *error) {
        dispatch_group_leave(_group);

        
    }];
    
    //获取抵扣券信息
//    dispatch_group_enter(_group);
//    TLNetworking *couponsHttp = [TLNetworking new];
//    couponsHttp.code = @"808268";
//    couponsHttp.parameters[@"storeCode"] = [ZHShop shop].code;
//    [couponsHttp postWithSuccess:^(id responseObject) {
//        
//        dispatch_group_leave(_group);
//        successCount ++;
//        //
//        self.hasSellCount = responseObject[@"data"][@"unUseCount"];
//        self.usedCount = responseObject[@"data"][@"usedCount"];
//        self.outOfDateCount = responseObject[@"data"][@"invalidCount"];
//        
//    } failure:^(NSError *error) {
//        dispatch_group_leave(_group);
//
//        
//    }];
    
    //收益及分红权
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *http = [TLNetworking new];
    http.code = @"808275";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_group);
        successCount ++;
        
        self.profitAndCountModel.totalStockCount = responseObject[@"data"][@"totalStockCount"];
        self.profitAndCountModel.mineProfitCount = responseObject[@"data"][@"stockCount"];
        
        
//        self.profitAndCountModel.totalStockCount =
//        
//        = [CDProfitAndCountModel tl_objectWithDictionary:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        dispatch_group_leave(_group);
    }];
    
    //查询资金池
    reqCount ++;
    dispatch_group_enter(_group);
    TLNetworking *poolHttp = [TLNetworking new];
    poolHttp.code = @"802502";
    poolHttp.parameters[@"token"] = [ZHUser user].token;
    poolHttp.parameters[@"accountNumber"] = @"A2017100000000000002";
    [poolHttp postWithSuccess:^(id responseObject) {
        dispatch_group_leave(_group);
        successCount ++;
        self.profitAndCountModel.profitPoolMoney = responseObject[@"data"][@"amount"];

    } failure:^(NSError *error) {
        dispatch_group_leave(_group);

    }];

    
    //
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
       
        [TLProgressHUD popActivity];
        
        if (reqCount == successCount) {
            
            [self removePlaceholderView];
            
            [self UI];
            [self addEvent];

            //
            [self data];
            
            [self initData];
 
        } else {
        
            [self addPlaceholderView];

        }
        
    });

}


//
- (void)initData {

    if ([ZHShop shop].isGongYi) {
        
        self.shopLeveUpView.topLeftLbl.text = @"店铺已升级";
        self.shopLeveUpView.topRightLbl.text = @"";
//        self.shopLeveUpView.bottomLbl.text = @"您已经是公益型商家";
        self.shopLeveUpView.bottomLbl.text = @"普通商家";
        
    } else {
    
        self.shopLeveUpView.topLeftLbl.text = @"店铺升级";
        self.shopLeveUpView.topRightLbl.text = @"免费在线升级";
        self.shopLeveUpView.bottomLbl.text = @"您还是普通商家，无法获得额外收益";
    }
    
    NSString *status = [ZHShop shop].status;
    
    

    if ([status isEqualToString:SHOP_STATUS_WILL_CHECK]) {
        
        self.shopFitUpView.bottomLbl.text = @"待审核";
        self.shopStatusSwitch.on = NO;

        
    } else if([status isEqualToString:SHOP_STATUS_WILL_DOWN] ) {
        
        self.shopStatusSwitch.on = NO;
        self.shopFitUpView.bottomLbl.text = @"待上架";
        
    } else if([status isEqualToString:SHOP_STATUS_OPEN]) {
        
        self.shopStatusSwitch.on = YES;
        self.shopFitUpView.bottomLbl.text = @"店铺营业中，重新编辑后需审核才可上架";

        
    } else if ([status isEqualToString:SHOP_STATUS_CLOSE]) {
    
        self.shopStatusSwitch.on = NO;
        self.shopFitUpView.bottomLbl.text = @"关店";
    
    } else if([status isEqualToString:SHOP_STATUS_DOWN]) {//开店
        
        self.shopFitUpView.bottomLbl.text = @"平台下架";
        self.shopStatusSwitch.on = NO;

        
    }  else if([status isEqualToString:SHOP_STATUS_CHECK_REFUSE]) {
        
        self.shopStatusSwitch.on = NO;

        if ([ZHShop shop].remark) {
            
            self.shopFitUpView.bottomLbl.text = [NSString stringWithFormat:@"审核不通过，原因：%@",[ZHShop shop].remark];

        } else {
        
            self.shopFitUpView.bottomLbl.text = @"审核不通过";

        }


    }
    


//    self.couponMgtView.bottomLeftLbl.text = [NSString stringWithFormat:@"已出售 %@张", self.hasSellCount];
//    self.couponMgtView.bottomMiddleLbl.text = [NSString stringWithFormat:@"已使用 %@张",self.usedCount];
//    self.couponMgtView.bottomrightLbl.text = [NSString stringWithFormat:@"过期未使用 %@张",self.outOfDateCount];
    //
    self.profitPoolMoneyView.topLbl.attributedText =  [self formatAmount:self.profitAndCountModel.profitPoolMoney];

    
//    [NSString stringWithFormat:@"￥%@",[self.profitAndCountModel.profitPoolMoney convertToRealMoney]];
    self.profitPoolMoneyView.bottomLbl.text = @"补贴额度";
    
    self.profitTotalCountView.topLbl.text = [NSString stringWithFormat:@"%@个",self.profitAndCountModel.totalStockCount];
    self.profitTotalCountView.bottomLbl.text = @"分红权总数";
    
    self.mineProfitMoneyView.topLbl.text = [NSString stringWithFormat:@"￥%@",self.profitAndCountModel.mineProfitMoney];
    self.mineProfitMoneyView.bottomLbl.text = @"您的分红权金额";
    
    self.mineProfitCountView.topLbl.text =  [NSString stringWithFormat:@"%@个",self.profitAndCountModel.mineProfitCount];
    self.mineProfitCountView.bottomLbl.text = @"您的分红权数量";
    
}

- (void)data {
    
    self.shopFitUpView.topLeftLbl.text = @"店铺装修";
    self.shopFitUpView.bottomLbl.text = @"店铺营业中无法修改";
    
    //
    self.shopLeveUpView.topLeftLbl.text = @"店铺升级";
    self.shopLeveUpView.topRightLbl.text = @"免费在线升级";
    self.shopLeveUpView.bottomLbl.text = @"您还是普通商家，无法获得额外收益";
    
    //
//    self.couponMgtView.topLeftLbl.text = @"抵扣券管理";
//    self.couponMgtView.bottomLeftLbl.text = @"已出售 --张";
//    self.couponMgtView.bottomMiddleLbl.text = @"已使用 --张";
//    self.couponMgtView.bottomrightLbl.text = @"过期未使用 --张";
//    
    
    //收益
    self.profitPoolMoneyView.topLbl.text = @"￥--";
    self.profitPoolMoneyView.bottomLbl.text = @"补贴额度";
    
    self.profitTotalCountView.topLbl.text = @"--个";
    self.profitTotalCountView.bottomLbl.text = @"分红权总数";
    
    self.mineProfitMoneyView.topLbl.text = @"￥--";
    self.mineProfitMoneyView.bottomLbl.text = @"您的分红权金额";
    
    self.mineProfitCountView.topLbl.text = @"--个";
    self.mineProfitCountView.bottomLbl.text = @"您的分红权数量";

}

#pragma mark-店铺装修
- (void)shopFitUpAction {

    CDShopInfoChangeVC *vc = [[CDShopInfoChangeVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark-抵扣券管理
- (void)couponMgtAction {

    ZHCouponsMgtVC *vc = [ZHCouponsMgtVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark-关店或者开店
- (void)openOrCloseAction:(UISwitch *)swi {

    if (!([[ZHShop shop].status isEqualToString:SHOP_STATUS_OPEN] || [[ZHShop shop].status isEqualToString:SHOP_STATUS_CLOSE])) {
        
        swi.on = NO;
        [TLAlert alertWithInfo:@"店铺通过审核后并且已经上架才能进行该操作"];
        return;
    }
    
    
    if (swi.on) {//开店
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808206";
        http.parameters[@"code"] = [ZHShop shop].code;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"开店成功"];
            [ZHShop shop].status = SHOP_STATUS_OPEN;
            
            self.shopFitUpView.bottomLbl.text = @"店铺营业中，重新编辑后需审核才可上架";
            
        } failure:^(NSError *error) {
            
            swi.on = !swi.on;
            
        }];
        
    } else {//关店
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808206";
        http.parameters[@"code"] = [ZHShop shop].code;
        http.parameters[@"token"] = [ZHUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"关店成功"];
            self.shopFitUpView.bottomLbl.text = @"店铺关闭";
            [ZHShop shop].status = SHOP_STATUS_CLOSE;
            
        } failure:^(NSError *error) {
            
            swi.on = !swi.on;
            
        }];
        
    }
    
}

#pragma mark- 店铺升级
- (void)shopLevelUp {

    if (![ZHShop shop].isGongYi) {
        
        ZHShopUpgradeVC *vc = [ZHShopUpgradeVC new];
        [vc setUpgradeSuccess:^{
            
            [[ZHShop shop] getShopInfoSuccess:nil failure:nil];
            [ZHShop shop].level = @"2";
             //
            self.shopLeveUpView.topLeftLbl.text = @"店铺已升级";
            self.shopLeveUpView.topRightLbl.text = @"";
//            self.shopLeveUpView.bottomLbl.text = @"您已经是公益型商家";
            self.shopLeveUpView.bottomLbl.text = @"普通商家";
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        http.code = @"808207";
//        http.parameters[@"token"] = [ZHUser user].token;
//        http.parameters[@"code"] = [ZHShop shop].code;
//        
//        [http postWithSuccess:^(id responseObject) {
//            
//            [TLAlert alertWithSucces:@"升级成功"];
//            [[ZHShop shop] getShopInfoSuccess:nil failure:nil];
//            [ZHShop shop].level = @"2";
//            //
//            self.shopLeveUpView.topLeftLbl.text = @"店铺已升级";
//            self.shopLeveUpView.topRightLbl.text = @"";
//            self.shopLeveUpView.bottomLbl.text = @"您已经是公益型商家";
//            
//        } failure:^(NSError *error) {
//            
//        }];
        
    }
    
}


- (NSMutableAttributedString *)formatAmount:(NSNumber *)amount {
    
    
    NSString *formatStr = nil;
    if ([amount longLongValue] <= 10000*1000) {
        //小于1万
        
        formatStr = [amount convertToRealMoney];
        
    } else {
        
        formatStr = [@([amount longLongValue]/10000) convertToRealMoney];
        formatStr = [formatStr stringByAppendingString:@"万"];
        
    }
    
    
    NSString *totalStr = [NSString stringWithFormat:@"￥%@",formatStr];
    NSRange dotRange = [totalStr rangeOfString:@"."];
    if (dotRange.length <=0 ) {
        return nil;
    }
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    
    [mutableAttr addAttribute:NSFontAttributeName value:FONT(18) range:NSMakeRange(0, 1)];
    [mutableAttr addAttribute:NSFontAttributeName value:FONT(18) range:NSMakeRange(dotRange.location, formatStr.length - dotRange.location + 1)];
    
    return mutableAttr;
    
}

- (void)addEvent {

    //
    [self.shopFitUpView addTarget:self action:@selector(shopFitUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shopStatusSwitch addTarget:self action:@selector(openOrCloseAction:) forControlEvents:UIControlEventValueChanged];
    
    
    //店铺升级
    [self.shopLeveUpView addTarget:self action:@selector(shopLevelUp) forControlEvents:UIControlEventTouchUpInside];
    
    //抵扣券
//    [self.couponMgtView addTarget:self action:@selector(couponMgtAction) forControlEvents:UIControlEventTouchUpInside];
    
    //下部我的收益
    [self.profitPoolMoneyView addTarget:self action:@selector(lookProfit:) forControlEvents:UIControlEventTouchUpInside];
    [self.mineProfitCountView addTarget:self action:@selector(lookProfit:) forControlEvents:UIControlEventTouchUpInside];
    [self.profitTotalCountView addTarget:self action:@selector(lookProfit:) forControlEvents:UIControlEventTouchUpInside];
    [self.mineProfitMoneyView addTarget:self action:@selector(lookProfit:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- 查看自己的分红权
- (void)lookProfit:(UIButton *)btn {

    //
    CDFenHongQuanVC *vc = [CDFenHongQuanVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
//    ZHMineEarningsVC *mineEarnings = [ZHMineEarningsVC new];
//    [self.navigationController pushViewController:mineEarnings animated:YES];

}

- (void)protocalInfoAction {

    ZHSJIntroduceVC *vc = [[ZHSJIntroduceVC alloc] init];
    vc.type = IntroduceInfoSignAContractInfo;
    [self.navigationController pushViewController:vc animated:YES];

}
//
- (void)UI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:0 target:self action:@selector(shopFitUpAction)];

    
    //
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    //
    self.shopFitUpView = [[CDShopMgtType1View alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [self.bgScrollView addSubview:self.shopFitUpView];
    //添加mask,优化点击
    UIView *maskView = [[UIView alloc] init];
    [self.shopFitUpView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.shopFitUpView);
        make.width.equalTo(@80);
    }];
    
    self.shopStatusSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.shopFitUpView addSubview:self.shopStatusSwitch];
    
    [self.shopStatusSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopFitUpView.mas_right).offset(-15);
        make.centerY.equalTo(self.shopFitUpView.mas_centerY);
        
    }];
    
  

    
    //
    self.shopLeveUpView = [[CDShopMgtType1View alloc] initWithFrame:CGRectMake(0, self.shopFitUpView.yy, SCREEN_WIDTH, 70)];
    [self.bgScrollView addSubview:self.shopLeveUpView];
    
    //
//    self.couponMgtView = [[CDShopMgtType2View alloc] initWithFrame:CGRectMake(0, self.shopLeveUpView.yy, SCREEN_WIDTH, 80)];
//    [self.bgScrollView addSubview:self.couponMgtView];
    
    //我的收益
    UILabel *syLbl = [UILabel labelWithFrame:CGRectMake(15, 140, SCREEN_WIDTH - 15, 45) textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(15)
                                   textColor:[UIColor themeColor]];
    [self.bgScrollView addSubview:syLbl];
    syLbl.text = @"我的收益";
    
    //1.1
    CDShopMgtTopBottomView *topLeftView = [[CDShopMgtTopBottomView alloc] initWithFrame:CGRectMake(0, syLbl.yy, SCREEN_WIDTH/2.0, 90)];
    [self.bgScrollView addSubview:topLeftView];
    self.profitPoolMoneyView = topLeftView;
    
    //1.2
    CDShopMgtTopBottomView *topRightView = [[CDShopMgtTopBottomView alloc] initWithFrame:CGRectMake(topLeftView.xx, topLeftView.y, topLeftView.width, topLeftView.height)];
    [self.bgScrollView addSubview:topRightView];
    self.profitTotalCountView = topRightView;
    
    //2.1
    CDShopMgtTopBottomView *bottomLeftView = [[CDShopMgtTopBottomView alloc] initWithFrame:CGRectMake(0, topLeftView.yy, topLeftView.width, topLeftView.height)];
    [self.bgScrollView addSubview:bottomLeftView];
    self.mineProfitCountView = bottomLeftView;
    
    //2.2
    CDShopMgtTopBottomView *bottomRightView = [[CDShopMgtTopBottomView alloc] initWithFrame:CGRectMake(bottomLeftView.xx, bottomLeftView.y, topLeftView.width, topLeftView.height)];
    [self.bgScrollView addSubview:bottomRightView];
    self.mineProfitMoneyView = bottomRightView;
    
    //使用说明和签约协议
    UIButton *protocalBtn = [[UIButton alloc] init];
    [self.bgScrollView addSubview:protocalBtn];
    protocalBtn.titleLabel.textColor = [UIColor themeColor];
    protocalBtn.titleLabel.font = FONT(12);
    
    [protocalBtn addTarget:self action:@selector(protocalInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [protocalBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [protocalBtn setTitle:@"商家使用说明及签约协议" forState:UIControlStateNormal];
    [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.top.equalTo(bottomLeftView.mas_bottom).offset(10);
        
    }];
    
    
    //toplLine
    UIColor *lineColor = [UIColor themeColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, topLeftView.y, SCREEN_WIDTH, LINE_HEIGHT)];
    topLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:topLine];

    
    //middleLIne
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, bottomLeftView.y, SCREEN_WIDTH, LINE_HEIGHT)];
    middleLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:middleLine];

    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bottomLeftView.yy - LINE_HEIGHT, SCREEN_WIDTH, LINE_HEIGHT)];
    bottomLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:bottomLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.bgScrollView.mas_left);
//        make.right.equalTo(self.bgScrollView.mas_right);
//        make.bottom.equalTo(bottomLeftView.mas_bottom);
//        make.height.mas_equalTo(LINE_HEIGHT);
//        
//    }];
    
    //竖线
    UIView *yLine = [[UIView alloc] init];
    yLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:yLine];
    [yLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topLeftView.mas_top);
        make.bottom.equalTo(bottomLeftView.mas_bottom);
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.width.mas_equalTo(LINE_HEIGHT);
        
    }];
    
    
 
}



@end
