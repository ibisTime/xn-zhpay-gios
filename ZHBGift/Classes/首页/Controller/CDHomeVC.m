//
//  CDHomeVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDHomeVC.h"
#import "CDHomeOperationCell.h"
#import "CDShopMgtVC.h"
#import "ZHGoodsListVC.h"
#import "ZHOrderVC.h"
#import "ZHBillVC.h"
#import "ZHCurrencyModel.h"
#import "ZHBankCardListVC.h"
#import "ZHAccountAboutVC.h"
#import "ZHWithdrawalVC.h"
#import "CDAccountApi.h"
#import "MJRefresh.h"
#import "CDShopInfoChangeVC.h"
#import "CDGoodsAndOrderCountModel.h"
#import "CDHomeAccountInfoModel.h"
#import "ZHMsgVC.h"
#import "CDGoodsMgtVC.h"
#import "CDConsumptionFlowVC.h"
#import "ZHSJIntroduceVC.h"
#import "CDFenHongQuanVC.h"
#import "TLMarqueeView.h"
#import "CDConsumptionModel.h"
#import "TLCollectMoneyHintVC.h"
#import "ZHRealNameAuthVC.h"
#import "ZHBillTypeChooseVC.h"
#import "TLHeader.h"
#import "UserHeader.h"
#import "UIHeader.h"
#import "ZHGiftHeader.h"




#define TOP_LEFT_MARGIN 41

@interface CDHomeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIView *scrollContentView;

//店铺相关
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UILabel *shopNameLbl;
@property (nonatomic, strong) UILabel *shopStatusLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *shopTypeLbl;

//账户相关
@property (nonatomic, strong) UIImageView *accountImageView;


/**
 分润余额
 */
//@property (nonatomic, strong) UILabel *balanceLbl;

@property (nonatomic, strong) UILabel *giftBalanceLbl;

@property (nonatomic, strong) UILabel *buTieBalanceLbl;

/**
 礼品券余额
 */
//@property (nonatomic, strong) UILabel *giftBalanceLbl;


@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) UILabel *totalTurnoverLbl;
//@property (nonatomic, strong) UILabel *hasWithdrawLbl;
//@property (nonatomic, strong) UILabel *totalProfitLbl;
//@property (nonatomic, strong) UILabel *profitCountLbl;

@property (nonatomic, strong) TLMarqueeView *sysMsgView;

//
@property (nonatomic, copy) NSArray <CDHomeOperationModel *>*opModels;

@property (nonatomic, strong) CDHomeOperationModel *shopFitUpOpModel;
@property (nonatomic, strong) CDHomeOperationModel *goodsOpModel;
@property (nonatomic, strong) CDHomeOperationModel *orderOpModel;
@property (nonatomic, strong) CDHomeOperationModel *accountOpModel;

@property (nonatomic, copy) NSArray <UIColor *>*color1s;
@property (nonatomic, copy) NSArray <UIColor *>*color2s;

@property (nonatomic, strong) UITableView *opTableView;

//请求数据
//@property (nonatomic, strong) ZHCurrencyModel *FRBModel;
//@property (nonatomic, strong) ZHCurrencyModel *GiftBModel;

@property (nonatomic, strong) CDGoodsAndOrderCountModel *goodsAndOrderCountModel;
@property (nonatomic, strong) CDHomeAccountInfoModel *accountInfModel;

@property (nonatomic, copy) NSString *sysMsgTitle;
@property (nonatomic, copy) NSString *sysMsgContent;
@property (nonatomic, copy) NSArray <ZHCurrencyModel *> *currencyRoom;


//帮助首次刷新判断，是否已经添加店铺
@property (nonatomic, assign) BOOL isFirstRefresh;

//是否弹出公告
@property (nonatomic, assign) BOOL isFirstDisplayMsg;
@property (nonatomic, assign) BOOL haveSysMsg;

@property (nonatomic, assign) BOOL firstLoadShopInfoSuccess;

@end


@implementation CDHomeVC {

   dispatch_group_t _topDataGroup;
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor shopThemeColor];
    
    //
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([ZHShop shop].isHasShop) {
        
        [self hiddenNavBar];

    } else  {
    
        [self showNavBar];
    }
    
    
}

- (void)shopInfoChange {

    [self data];

}


//- (void)updateApp {
//
//
//    return;
//    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID] parameters:nil success:^(NSString *msg, id data) {
//
//        //线上版本
//        NSString *versionStr = data[@"results"][0][@"version"];
//        //版本号不同就要更新
//        if (![versionStr isEqualToString:OLD_VERSION] && ![versionStr isEqualToString:[NSString appCurrentBundleVersion]]) {
//
//            //此版本是否用户拒绝跟新
//            NSString *updateValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"update_app_key"];
//            if(updateValue && [updateValue isEqualToString:versionStr]) {
//
//                return ;
//            }
//
//            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"应用更新"
//                                                                               message:[NSString stringWithFormat:@"最新版本为：%@",versionStr]
// preferredStyle:UIAlertControllerStyleAlert];
//
//            //
//            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                NSString *appName = APP_NAME;
//                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@/id%@?mt=8",appName,APP_ID];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//
//            }];
//
//            //
//            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//
//            //
//            UIAlertAction *noHintUpdateAction = [UIAlertAction actionWithTitle:@"不在提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:@"update_app_key"];
//
//            }];
//
//            //
//            [alertCtrl addAction:updateAction];
//            [alertCtrl addAction:cancleAction];
//            [alertCtrl addAction:noHintUpdateAction];
//
//            //
//            [self presentViewController:alertCtrl animated:YES completion:nil];
//
//        }
//
//    } abnormality:nil failure:nil];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstRefresh = YES;
    self.isFirstDisplayMsg = YES;
    self.firstLoadShopInfoSuccess = NO;
    self.haveSysMsg = NO;
    
    self.accountInfModel = [CDHomeAccountInfoModel new];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = HOME_BLACK_BACKGROUND_COLOR;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopInfoChange) name:kShopInfoChange object:nil];
    
    //
    self.tl_placeholderView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    _topDataGroup = dispatch_group_create();
    
    //先要掉的接口
    //1.获取店铺
    //2.获取账户
    //3.获取分红权
    //4.获取系统消息
    //4.获取商品
    //5.获取订单
    //6.获取账单
    UIColor *color1 = [UIColor shopThemeColor];
    UIColor *color2 = [UIColor goodsThemeColor];
    UIColor *color3 = [UIColor orderThemeColor];
    UIColor *color4 = [UIColor billThemeColor];
    UIColor *color5 = [UIColor accountSettingThemeColor];
    
    NSArray <UIColor *> *color1s = @[[UIColor blackColor],color1,color2,color3,color4];
    NSArray <UIColor *> *color2s = @[color1,color2,color3,color4,color5];
    self.color1s = color1s;
    self.color2s = color2s;

    [self configModels];
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [TLProgressHUD showWithStatus:nil];
    
    //判断有无店铺——Important
    [self firstStepGetShopInfo];

 
    
}//-----------//

- (void)firstStepGetShopInfo {

    [TLProgressHUD showWithStatus:nil];
    [[ZHShop shop] getShopInfoSuccess:^(NSDictionary *shopDict) {
        
        [TLProgressHUD dismiss];
        [self removePlaceholderView];
        self.firstLoadShopInfoSuccess = YES;
        
        if (shopDict) {
            
            [self hiddenNavBar];
            [self tl_placeholderOperation];
            
         
        } else {
          
            //添加退出登录相关操作
            [self showNavBar];
            
            //实名认证后才能添加店铺
            [self setPlaceholderViewTitle:@"您还未添加店铺" operationTitle:@"前往添加"];
            [self addPlaceholderView];
            
            if (![ZHUser user].realName || [ZHUser user].realName.length <= 0) {
                
                ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                [vc setAuthSuccess:^{
                    
                    [self goAddShop];

                }];
                
            } else {
                
#warning mark-- 尚无店铺直接跳添加店铺界面
                [self goAddShop];
                
            }

            
        }
        
    } failure:^(NSError *error) {
        

        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];

}


- (void)hiddenNavBar {

    self.view.backgroundColor = HOME_BLACK_BACKGROUND_COLOR;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


- (void)showNavBar {

    //
    self.view.backgroundColor = [UIColor backgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginOut)];
    
    //
}

- (void)loginOut {

    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
}

- (void)goAddShop {

    CDShopInfoChangeVC *vc = [[CDShopInfoChangeVC alloc] init];
    [vc setSuccess:^{
        
        [self removePlaceholderView];
        [self tl_placeholderOperation];
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)tl_placeholderOperation {

    if (!self.firstLoadShopInfoSuccess || ![ZHShop shop].isHasShop) {
        
        [self firstStepGetShopInfo];
        return;
        
    }
//    if (!self.isFirstRefresh && ![ZHShop shop].isHasShop) {
//        
//        UIScrollView *sv = (UIScrollView *)self.view;
//        [sv.mj_header endRefreshing];
//        [self goAddShop];
//        return;
//    }
    
    BOOL isShowMsg = YES;
    
    //确保以下请求一定会有店铺信息
    if (self.isFirstRefresh) {
        
      [TLProgressHUD showWithStatus:nil];
    
    }
    
    //获取用户信息
    TLNetworking *userInfoHttp = [TLNetworking new];
    userInfoHttp.code = USER_INFO;
    userInfoHttp.parameters[@"userId"] = [ZHUser user].userId;
    userInfoHttp.parameters[@"token"] = [ZHUser user].token;
    [userInfoHttp postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        [[ZHUser user] saveUserInfo:userInfo];
        [[ZHUser user] setUserInfoWithDict:userInfo];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    NSInteger requestCount = 0;
    __block NSInteger topDataSuccessCount = 0;
    
    //店铺信息
    requestCount ++;
    dispatch_group_enter(_topDataGroup);
    [[ZHShop shop] getShopInfoSuccess:^(NSDictionary *shopDict) {
        
        topDataSuccessCount ++;
        dispatch_group_leave(_topDataGroup);
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_topDataGroup);
        
    }];
    
    //获得系统消息
    requestCount ++;
    dispatch_group_enter(_topDataGroup);
    TLNetworking *sysMsgHttp = [TLNetworking new];
    sysMsgHttp.isShowMsg = isShowMsg;
    sysMsgHttp.code = @"804040";
    sysMsgHttp.parameters[@"token"] = [ZHUser user].token;
    sysMsgHttp.parameters[@"channelType"] = @"4";
    
    sysMsgHttp.parameters[@"pushType"] = @"41";
    sysMsgHttp.parameters[@"toKind"] = @"f3";
    //    1 立即发 2 定时发
    sysMsgHttp.parameters[@"smsType"] = @"1";
    sysMsgHttp.parameters[@"status"] = @"1";
    
    sysMsgHttp.parameters[@"fromSystemCode"] = @"CD-CZH000001";
    sysMsgHttp.parameters[@"limit"] = @"1";
    sysMsgHttp.parameters[@"start"] = @"1";
    [sysMsgHttp postWithSuccess:^(id responseObject) {
        NSArray *msgArr = responseObject[@"data"][@"list"];
        
        topDataSuccessCount ++;
        dispatch_group_leave(_topDataGroup);
        
        if (msgArr.count) {
            
          self.sysMsgTitle = responseObject[@"data"][@"list"][0][@"smsTitle"];
          self.sysMsgContent = responseObject[@"data"][@"list"][0][@"smsContent"];
//
            self.haveSysMsg = YES;
        } else {
        
             self.sysMsgTitle = @"暂无公告";
            self.haveSysMsg = NO;

            
        }
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_topDataGroup);

    }];

    
    
    //
    //查询账户信息
    requestCount ++;
    dispatch_group_enter(_topDataGroup);
    TLNetworking *currencyRoomHttp = [TLNetworking new];
    currencyRoomHttp.code = @"802503";
    currencyRoomHttp.isShowMsg = YES;
    currencyRoomHttp.parameters[@"token"] = [ZHUser user].token;
    currencyRoomHttp.parameters[@"userId"] = [ZHUser user].userId;
    [currencyRoomHttp postWithSuccess:^(id responseObject) {
        topDataSuccessCount ++;
        dispatch_group_leave(_topDataGroup);
        
        //
        self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_topDataGroup);
        
        
    }];
    
    
    //查询商品 和 订单
    requestCount ++;
    dispatch_group_enter(_topDataGroup);
    TLNetworking *goodsAndOrderHttp = [TLNetworking new];
    goodsAndOrderHttp.code = @"808276";
    goodsAndOrderHttp.parameters[@"userId"] = [ZHUser user].userId;
    goodsAndOrderHttp.isShowMsg = isShowMsg;
    [goodsAndOrderHttp postWithSuccess:^(id responseObject) {
        topDataSuccessCount ++;
        dispatch_group_leave(_topDataGroup);
        
      self.goodsAndOrderCountModel = [CDGoodsAndOrderCountModel tl_objectWithDictionary:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        dispatch_group_leave(_topDataGroup);
        
        
    }];
    
    //查询累计营业额
    requestCount ++;
    dispatch_group_enter(_topDataGroup);
    TLNetworking *http = [TLNetworking new];
    http.code = @"808275";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.isShowMsg = isShowMsg;
    [http postWithSuccess:^(id responseObject) {
        topDataSuccessCount ++;
        dispatch_group_leave(_topDataGroup);
        
        self.accountInfModel.totalTurnover = responseObject[@"data"][@"totalProfit"];
        self.accountInfModel.totalProfit = responseObject[@"data"][@"totalStockProfit"];
        self.accountInfModel.mineProfitCount = responseObject[@"data"][@"stockCount"];

    } failure:^(NSError *error) {
        dispatch_group_leave(_topDataGroup);

    }];
    

    //
    dispatch_group_notify(_topDataGroup, dispatch_get_main_queue(), ^{
        
        if (self.bgScrollView) {
            
            [self.bgScrollView.mj_header endRefreshing];

        }
        
        if (self.isFirstRefresh) {
            
            [TLProgressHUD dismiss];
            
        }

        //
        if (requestCount == topDataSuccessCount) {
            
                [self removePlaceholderView];

                self.isFirstRefresh = NO;
                
                [self setUpUI];
            
                //数据赋值
                [self data];
                
                //
            
            if (self.isFirstDisplayMsg && self.haveSysMsg) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                    UIAlertController *sysAlertCtrl = [UIAlertController alertControllerWithTitle:@"公告" message:self.sysMsgContent preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        self.isFirstDisplayMsg = NO;
                    }];
                    
                    [sysAlertCtrl addAction:cancleAction];
                    [self presentViewController:sysAlertCtrl animated:YES completion:nil];


                
                });
              
                
            }
            

         
        } else {
            
            [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
            //失败
            [self addPlaceholderView];

        }
        
        //今日收入，机内提现
        TLNetworking *todayMoneyChangeHttp = [TLNetworking new];
        //        todayMoneyChangeHttp.isShowMsg = NO;
        todayMoneyChangeHttp.code = @"802901";
        todayMoneyChangeHttp.parameters[@"userId"] = [ZHUser user].userId;
        
        [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kFRB]) {
                
                todayMoneyChangeHttp.parameters[@"accountNumber"] = obj.accountNumber;
                
            }
        }];
        
        //
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        todayMoneyChangeHttp.parameters[@"dateStart"] = dateStr;
        todayMoneyChangeHttp.parameters[@"dateEnd"] = dateStr;
        [todayMoneyChangeHttp postWithSuccess:^(id responseObject) {
            
            self.accountInfModel.todaylTurnover =  responseObject[@"data"][@"incomeAmount"];
            self.accountInfModel.todayWithdrawMoney = responseObject[@"data"][@"withdrawAmount"];
            
            self.accountOpModel.leftText = [NSString stringWithFormat:@"今日收入 %@",[self.accountInfModel.todaylTurnover convertToRealMoney]];
            self.accountOpModel.middleText = [NSString stringWithFormat:@"今日提现 %@",[self.accountInfModel.todayWithdrawMoney convertToRealMoney]];
            
            [self.opTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
        
       [self goRealNameAuth];
            
        

    });
    
  
}


/**
 返回结果，需要实名 YES
 */
- (BOOL)goRealNameAuth {

    if (![ZHUser user].realName || [ZHUser user].realName.length <= 0) {
    
        ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return YES;
    }
 
    return NO;
}


#pragma mark- 查询付款信息
- (void)voicePlay {

    TLCollectMoneyHintVC *vc = [[TLCollectMoneyHintVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    return;
    
}


- (void)configModels {

    //店铺管理
    __weak typeof(self) weakself = self;
    CDHomeOperationModel *shopOpModel = [CDHomeOperationModel new];
    shopOpModel.funcName = @"店铺管理";
    shopOpModel.operationName = @"编辑";
    shopOpModel.leftText = @"营业中";
    shopOpModel.middleText = @"语音播报";
    shopOpModel.rightText = @"礼品商";
    
    [shopOpModel setMainAction:^{
        
        CDShopMgtVC *vc = [CDShopMgtVC new];
        [weakself.navigationController pushViewController:vc animated:YES];
        vc.navigationController.navigationBar.barTintColor = [UIColor shopThemeColor];
        
    }];
    
  
    [shopOpModel setMiddleAction:^{
//        
//        [weakself.navigationController pushViewController:[CDConsumptionFlowVC new] animated:YES];
//        weakself.navigationController.navigationBar.barTintColor = [UIColor shopThemeColor];
        TLCollectMoneyHintVC *vc = [[TLCollectMoneyHintVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];

    }];
    
    
    //商品管理
    CDHomeOperationModel *goodsOpModel = [CDHomeOperationModel new];
    goodsOpModel.funcName = @"店铺商品管理";
    goodsOpModel.operationName = @"添加";
    goodsOpModel.leftText = @"所有商品 --";
    goodsOpModel.middleText = @"在售商品 --";
    goodsOpModel.rightText = @"下架商品 --";
    goodsOpModel.bottomActionEnables = @[@(NO),@(NO),@(NO)];
    [goodsOpModel setMainAction:^{
        
#warning dev-warning
        if (![ZHUser user].realName || [ZHUser user].realName.length <= 0) {

             [self goRealNameAuth];
             return ;
        }
        
        
        //
        CDGoodsMgtVC *vc = [CDGoodsMgtVC new];
        [weakself.navigationController pushViewController:vc animated:YES];

        vc.navigationController.navigationBar.barTintColor = [UIColor goodsThemeColor];
        
    }];
    
    
    //商品订单管理
    CDHomeOperationModel *orderOpModel = [CDHomeOperationModel new];
    orderOpModel.funcName = @"商品订单管理";
    orderOpModel.operationName = @"处理";
    orderOpModel.leftText = @"所有订单 --";
    orderOpModel.middleText = @"待发货 --";
    orderOpModel.rightText = @"待收货 --";
    [orderOpModel setMainAction:^{
        
        ZHOrderVC *vc = [[ZHOrderVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
//        vc.navigationController.navigationBar.barTintColor = [UIColor orderThemeColor];

    }];
    
    //账单查询
    CDHomeOperationModel *accountOpModel = [CDHomeOperationModel new];
    accountOpModel.funcName = @"账单查询";
    accountOpModel.operationName = @"查看";
    accountOpModel.leftText = @"今日收入 --";
    accountOpModel.middleText = @"今日提现 --";
    accountOpModel.rightText = @"处理中";
    [accountOpModel setMainAction:^{
        
        ZHBillTypeChooseVC *vc = [[ZHBillTypeChooseVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
  
    }];
    
    //账户设置
    CDHomeOperationModel *settingOpModel = [CDHomeOperationModel new];
    settingOpModel.funcName = @"账户设置";
    settingOpModel.operationName = @"操作";
    settingOpModel.leftText = @"账户安全";
    settingOpModel.middleText = @"提现银行卡";
    settingOpModel.rightText = @"切换账号";
    [settingOpModel setMainAction:^{
        
        ZHAccountAboutVC *vc = [[ZHAccountAboutVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
        [weakself.navigationController.navigationBar setBarTintColor:[UIColor accountSettingThemeColor]];
        
    }];
    
    [settingOpModel setMiddleAction:^{
        
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
        //
        [weakself.navigationController.navigationBar setBarTintColor:[UIColor accountSettingThemeColor]];
    }];
    
    [settingOpModel setRightAction:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
        //
    }];
    
    self.shopFitUpOpModel = shopOpModel;
    self.goodsOpModel = goodsOpModel;
    self.orderOpModel = orderOpModel;
    self.accountOpModel = accountOpModel;

    self.opModels = @[shopOpModel,goodsOpModel,orderOpModel,accountOpModel,settingOpModel];
    


}


- (void)data {

    //
    self.shopNameLbl.text = [ZHShop shop].name;
    self.shopStatusLbl.text = [[ZHShop shop] getStatusName];
    self.phoneLbl.text = [NSString stringWithFormat:@"账号：%@",[ZHUser user].mobile];
    
    self.shopTypeLbl.text = [ZHShop shop].isGongYi ? @"类型：礼品商" : @"类型：礼品商";

    //
    [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.currency isEqualToString:@"BTB"]) {
            
            self.buTieBalanceLbl.attributedText = [self formatAmount:obj.amount unit:@""];
            
        } else if ([obj.currency isEqualToString:@"LPQ"]) {
            
            self.giftBalanceLbl.attributedText = [self formatAmount:obj.amount unit:@""];

        }
        
    }];
    
    
    //
    self.totalTurnoverLbl.text = [NSString stringWithFormat:@"累计营业额 %@",[self.accountInfModel.totalTurnover convertToRealMoney]];
//    self.hasWithdrawLbl.text = [NSString stringWithFormat:@"已提现 %@",[self.FRBModel.outAmount convertToRealMoney]];
//    self.totalProfitLbl.text = [NSString stringWithFormat:@"累计分红收益 %@",[self.accountInfModel.totalProfit convertToRealMoney]];
//    self.profitCountLbl.text = [NSString stringWithFormat:@"分红权 %@个",self.accountInfModel.mineProfitCount];

    //
    self.sysMsgView.msg = [NSString stringWithFormat:@"公告：%@",self.sysMsgTitle];
    //
    
    //底部UI
    self.shopFitUpOpModel.leftText =  [[ZHShop shop] getStatusName];
    
    self.goodsOpModel.leftText = [NSString stringWithFormat:@"所有商品 %@",self.goodsAndOrderCountModel.productCount];
    self.goodsOpModel.middleText = [NSString stringWithFormat:@"在售商品 %@",self.goodsAndOrderCountModel.putOnProductCount];
    self.goodsOpModel.rightText =  [NSString stringWithFormat:@"下架商品 %@",self.goodsAndOrderCountModel.putOffProductCount];
    
    //
    self.orderOpModel.leftText = [NSString stringWithFormat:@"所有订单 %@",self.goodsAndOrderCountModel.orderCount];
    self.orderOpModel.middleText = [NSString stringWithFormat:@"待发货 %@",self.goodsAndOrderCountModel.toSendOrderCount];
    self.orderOpModel.rightText =  [NSString stringWithFormat:@"待收货 %@",self.goodsAndOrderCountModel.toReceiveOrderCount];
    //
    
    if (self.accountInfModel.todaylTurnover) {
        
        self.accountOpModel.leftText = [NSString stringWithFormat:@"今日收入 %@",[self.accountInfModel.todaylTurnover convertToRealMoney]];
        self.accountOpModel.middleText = [NSString stringWithFormat:@"今日提现 %@",[self.accountInfModel.todayWithdrawMoney convertToRealMoney]];
        
    } else {
    
        self.accountOpModel.leftText = [NSString stringWithFormat:@"今日收入 %@",@"--"];
        self.accountOpModel.middleText = [NSString stringWithFormat:@"今日提现 %@",@"--"];
    
    }

    
    [self.opTableView reloadData];
    
}

#pragma mark- 提现
- (void)withdraw {

    [TLProgressHUD showWithStatus:nil];
    [CDAccountApi getFRBWSuccess:^(ZHCurrencyModel *FRBCurrency,ZHCurrencyModel *GiftBCurrency) {
        
        [TLProgressHUD dismiss];
        
        ZHWithdrawalVC *vc = [[ZHWithdrawalVC alloc] init];
        vc.accountNum = FRBCurrency.accountNumber;
        vc.navigationController.navigationBar.barTintColor = [UIColor billThemeColor];

        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *err) {
        
        [TLProgressHUD dismiss];

    }];
 
}

#pragma mark-查看分红权
- (void)lookProfit {

    CDFenHongQuanVC *vc = [CDFenHongQuanVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- 消息
- (void)lookSysMsg {

    ZHMsgVC *msgVC = [[ZHMsgVC  alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.opModels[indexPath.row].mainAction) {
        self.opModels[indexPath.row].mainAction();
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return self.opModels.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CDHomeOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[CDHomeOperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    cell.bgColor1 = self.color1s[indexPath.row];
    cell.bgColor2 = self.color2s[indexPath.row];
    cell.opModel = self.opModels[indexPath.row];
    return cell;
}

- (NSMutableAttributedString *)formatAmount:(NSNumber *)amount unit:(NSString *)unit {

    
    NSString *formatStr = nil;
    if ([amount longLongValue] <= 10000*1000) {
        //小于1万
        
        formatStr = [amount convertToRealMoney];
        
    } else {
    
        formatStr = [@([amount longLongValue]/10000) convertToRealMoney];
        formatStr = [formatStr stringByAppendingString:@"万"];
        
    }
    
    
    NSString *totalStr = [NSString stringWithFormat:@"%@ %@",unit,formatStr];
    NSRange dotRange = [totalStr rangeOfString:@"."];
    if (dotRange.length <=0 ) {
        return nil;
    }
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:totalStr];
//
//    [mutableAttr addAttribute:NSFontAttributeName value:self.balanceLbl.font range:NSMakeRange(0, 1)];
//    [mutableAttr addAttribute:NSFontAttributeName value:self.balanceLbl.font range:NSMakeRange(dotRange.location, formatStr.length - dotRange.location + 1)];
    
    return mutableAttr;

}


- (void)bootomUI {

    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_UI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_UI_HEIGHT) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.scrollEnabled = NO;
    self.opTableView = tableV;
    tableV.rowHeight = (SCREEN_HEIGHT - TOP_UI_HEIGHT)/5.0;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollContentView addSubview:tableV];


    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.scrollContentView.mas_top).offset(TOP_UI_HEIGHT);
        make.width.equalTo(self.scrollContentView.mas_width);
        make.left.equalTo(self.scrollContentView.mas_left);
        make.height.mas_equalTo(SCREEN_HEIGHT - TOP_UI_HEIGHT);
        make.bottom.equalTo(self.scrollContentView.mas_bottom);
        
    }];
}

- (void)sysMsgUI {
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HOME_TEXT_COLOR_1;
    [self.scrollContentView addSubview:line];
    //

    
    self.sysMsgView =[[TLMarqueeView alloc] initWithFrame:CGRectMake(TOP_LEFT_MARGIN, 210, SCREEN_WIDTH - TOP_LEFT_MARGIN, 20)];
    self.sysMsgView.font = FONT(15);
    self.sysMsgView.textColor = HOME_TEXT_COLOR_1;
    [self.scrollContentView addSubview:self.sysMsgView];
    self.sysMsgView.msg = @"公告：系统公告";
    [self.sysMsgView begin];

//    TOP_UI_HEIGHT
//--//
    UIImageView *sysMsgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.scrollContentView addSubview:sysMsgImageView];
    sysMsgImageView.image = [UIImage imageNamed:@"home_sys_msg"];
    
    
    [sysMsgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(15);
        make.centerY.equalTo(self.sysMsgView.mas_centerY);
    }];
    
    //
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
        make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
        make.bottom.equalTo(self.sysMsgView.mas_top).offset(-10);
        make.height.mas_equalTo(1);
        
    }];
    
    //
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:maskBtn];
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH - TOP_LEFT_MARGIN);
        make.top.equalTo(self.sysMsgView.mas_top);
        make.bottom.equalTo(self.sysMsgView.mas_bottom);

        
    }];
    //
    [maskBtn addTarget:self action:@selector(lookSysMsg) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark-补贴提现
- (void)buTieWithdrawAction {
    
    
    ZHWithdrawalVC *vc = [[ZHWithdrawalVC alloc] init];
    [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.currency isEqualToString:@"BTB"]) {
            vc.accountNum = obj.accountNumber;
            *stop = YES;
        }
        
    }];
    vc.navigationController.navigationBar.barTintColor = [UIColor billThemeColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)accountUI {

    self.accountImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.scrollContentView addSubview:self.accountImageView];
    self.accountImageView.image = [UIImage imageNamed:@"home_time"];
    
    UIColor *textColr = HOME_TEXT_COLOR_2;
    
    //货款
    UILabel *daiKuanLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(20)
                                        textColor:textColr];
    [self.scrollContentView addSubview:daiKuanLbl];
    daiKuanLbl.text = @"礼品券";
    
    //余额 18 38 18
    self.giftBalanceLbl = [UILabel labelWithFrame:CGRectZero
                                        textAligment:NSTextAlignmentLeft
                                     backgroundColor:[UIColor clearColor]
                                                font:FONT(25)
                                           textColor:textColr];
    [self.scrollContentView addSubview:self.giftBalanceLbl];
    self.giftBalanceLbl.text  = @"--";
    
    //提现按钮
//    self.withdrawBtn = [[UIButton alloc] init];
//    [self.scrollContentView addSubview:self.withdrawBtn];
//    [self.withdrawBtn addTarget:self action:@selector(huoKuanWithdrawAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
//    [self.withdrawBtn setTitleColor:HOME_TEXT_COLOR_1 forState:UIControlStateNormal];
//    self.withdrawBtn.titleLabel.font = FONT(15);
    
    
    [daiKuanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
        make.bottom.equalTo(self.giftBalanceLbl.mas_bottom);
        
    }];
    
    [self.giftBalanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.phoneLbl.mas_bottom).offset(20);
        make.left.equalTo(daiKuanLbl.mas_right).offset(10);
    }];
    
    [self.accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(15);
        make.centerY.equalTo(self.giftBalanceLbl.mas_centerY);
    }];
    
//    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.huoKuanBalanceLbl.mas_right).offset(30);
//        make.centerY.equalTo(self.huoKuanBalanceLbl.mas_centerY);
//    }];
    
    
    //第二层 ******************************* ********************************//
    //    //货款  以 huoKuanBalanceLbl 作为基准
    UILabel *buTieLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(20)
                                      textColor:textColr];
    [self.scrollContentView addSubview:buTieLbl];
    buTieLbl.text = @"补贴";
    
    //余额 18 38 18
    self.buTieBalanceLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:self.giftBalanceLbl.font
                                         textColor:textColr];
    [self.scrollContentView addSubview:self.buTieBalanceLbl];
    self.buTieBalanceLbl.text  = @"--";
    
    //提现按钮
    UIButton *buTieWithdrawBtn = [[UIButton alloc] init];
    [self.scrollContentView addSubview:buTieWithdrawBtn];
    [buTieWithdrawBtn addTarget:self action:@selector(buTieWithdrawAction) forControlEvents:UIControlEventTouchUpInside];
    [buTieWithdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [buTieWithdrawBtn setTitleColor:HOME_TEXT_COLOR_1 forState:UIControlStateNormal];
    buTieWithdrawBtn.titleLabel.font = FONT(15);
    
    //
    [self.buTieBalanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.giftBalanceLbl.mas_bottom).offset(5);
        make.left.equalTo(buTieLbl.mas_right).offset(10);
    }];
    
    //
    [buTieLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
        make.bottom.equalTo(self.buTieBalanceLbl.mas_bottom);
        
    }];
    
    [buTieWithdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.buTieBalanceLbl.mas_right).offset(30);
        make.centerY.equalTo(self.buTieBalanceLbl.mas_centerY);
        
    }];
    //礼品券 ******************************* 分红权查看 ********************************//
//        self.giftBalanceLbl = [UILabel labelWithFrame:CGRectZero
//                                     textAligment:NSTextAlignmentLeft
//                                  backgroundColor:[UIColor clearColor]
//                                             font:FONT(18)
//                                        textColor:textColr];
//        [self.scrollContentView addSubview:self.giftBalanceLbl];
//
//    [self.giftBalanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(daiKuanLbl.mas_left);
//        make.top.equalTo(self.buTieBalanceLbl.mas_bottom).offset(5);
//
//    }];
    
    //第四层 ******************************* 分红权查看 ********************************//
    UIButton *fenHongQuanLookBtn = [[UIButton alloc] init];
    [self.scrollContentView addSubview:fenHongQuanLookBtn];
    [fenHongQuanLookBtn addTarget:self action:@selector(lookProfit) forControlEvents:UIControlEventTouchUpInside];
    [fenHongQuanLookBtn setTitle:@"分红权查看" forState:UIControlStateNormal];
    [fenHongQuanLookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fenHongQuanLookBtn.titleLabel.font = FONT(15);
    [fenHongQuanLookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(daiKuanLbl.mas_left);
        make.top.equalTo(self.buTieBalanceLbl.mas_bottom).offset(5);
        
    }];
    
//    self.accountImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.scrollContentView addSubview:self.accountImageView];
//    self.accountImageView.image = [UIImage imageNamed:@"home_time"];
//
//    UIColor *textColr = HOME_TEXT_COLOR_2;
//    //余额 18 38 18
//    self.balanceLbl = [UILabel labelWithFrame:CGRectZero
//                                  textAligment:NSTextAlignmentLeft
//                               backgroundColor:[UIColor clearColor]
//                                          font:FONT(20)
//                                     textColor:textColr];
//    [self.scrollContentView addSubview:self.balanceLbl];
//
//    self.giftBalanceLbl = [UILabel labelWithFrame:CGRectZero
//                                 textAligment:NSTextAlignmentLeft
//                              backgroundColor:[UIColor clearColor]
//                                         font:FONT(18)
//                                    textColor:textColr];
//    [self.scrollContentView addSubview:self.giftBalanceLbl];
//
//    //提现按钮
//    self.withdrawBtn = [[UIButton alloc] init];
//    [self.scrollContentView addSubview:self.withdrawBtn];
//    [self.withdrawBtn addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];
//    [self.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
//    [self.withdrawBtn setTitleColor:HOME_TEXT_COLOR_1 forState:UIControlStateNormal];
//    self.withdrawBtn.titleLabel.font = FONT(15);
//
//    //语音播报
////    UIButton *voicePlayBtn = [[UIButton alloc] init];
////    [self.scrollContentView addSubview:voicePlayBtn];
////    [voicePlayBtn addTarget:self action:@selector(voicePlay) forControlEvents:UIControlEventTouchUpInside];
////    [voicePlayBtn setTitle:@"语音播报" forState:UIControlStateNormal];
////    [voicePlayBtn setTitleColor:HOME_TEXT_COLOR_1 forState:UIControlStateNormal];
////    voicePlayBtn.titleLabel.font = FONT(15);
//
//
//    //营业额
//    self.totalTurnoverLbl = [UILabel labelWithFrame:CGRectZero
//                               textAligment:NSTextAlignmentCenter
//                            backgroundColor:[UIColor clearColor]
//                                       font:FONT(12)
//                                  textColor:textColr];
//    [self.scrollContentView addSubview:self.totalTurnoverLbl];
//
//    //已提现
//    self.hasWithdrawLbl = [UILabel labelWithFrame:CGRectZero
//                                  textAligment:NSTextAlignmentCenter
//                               backgroundColor:[UIColor clearColor]
//                                          font:FONT(12)
//                                     textColor:textColr];
//    [self.scrollContentView addSubview:self.hasWithdrawLbl];
//
//    //累计分红收益
//    self.totalProfitLbl = [UILabel labelWithFrame:CGRectZero
//                                     textAligment:NSTextAlignmentCenter
//                                  backgroundColor:[UIColor clearColor]
//                                             font:FONT(12)
//                                        textColor:textColr];
//    [self.scrollContentView addSubview:self.totalProfitLbl];
//
//    //分红权个数
//    self.profitCountLbl = [UILabel labelWithFrame:CGRectZero
//                                     textAligment:NSTextAlignmentCenter
//                                  backgroundColor:[UIColor clearColor]
//                                             font:FONT(12)
//                                        textColor:textColr];
//    [self.scrollContentView addSubview:self.profitCountLbl];
//
//
//    UIButton *maskBtn = [[UIButton alloc] init];
//    [self.scrollContentView addSubview:maskBtn];
//
//    [maskBtn addTarget:self action:@selector(lookProfit) forControlEvents:UIControlEventTouchUpInside];
//    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.totalTurnoverLbl);
//        make.bottom.equalTo(self.totalProfitLbl);
//        make.width.mas_equalTo(SCREEN_WIDTH - 100);
//    }];
//
//
//    [self.balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.phoneLbl.mas_bottom).offset(15);
//        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
//    }];
//
//    [self.giftBalanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.balanceLbl.mas_bottom).offset(5);
//        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
//
//    }];
//
//
//
//    [self.accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.scrollContentView.mas_left).offset(15);
//        make.centerY.equalTo(self.balanceLbl.mas_centerY);
//    }];
//
//    //提现
//    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.scrollContentView.mas_right).offset(-20);
//        make.top.equalTo(self.phoneLbl.mas_bottom).offset(15);
//        make.width.greaterThanOrEqualTo(@50);
//    }];
//
////    [voicePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////
////        make.right.equalTo(self.scrollContentView.mas_right).offset(-10);
////        make.top.equalTo(self.withdrawBtn.mas_top);
////        make.left.greaterThanOrEqualTo(self.withdrawBtn.mas_right);
////
////    }];
//
//    //累计营业额
//    [self.totalTurnoverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.balanceLbl.mas_left);
//        make.top.equalTo(self.giftBalanceLbl.mas_bottom).offset(10);
//    }];
//
//    [self.hasWithdrawLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.totalTurnoverLbl.mas_right).offset(30);
//        make.centerY.equalTo(self.totalTurnoverLbl.mas_centerY);
//
//    }];
//
//    [self.totalProfitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.balanceLbl.mas_left);
//        make.top.equalTo(self.totalTurnoverLbl.mas_bottom).offset(12);
//    }];
//
//
//    [self.profitCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.totalProfitLbl.mas_right).offset(30);
//        make.centerY.equalTo(self.totalProfitLbl.mas_centerY);
//    }];
//
//    //底线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = HOME_TEXT_COLOR_1;
//    [self.scrollContentView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.scrollContentView).mas_offset(TOP_LEFT_MARGIN);
//        make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
//
//        make.top.equalTo(self.totalProfitLbl.mas_bottom).offset(10);
//        make.height.mas_equalTo(0.5);
//    }];
//

}

- (void)introduce {

    ZHSJIntroduceVC *vc = [[ZHSJIntroduceVC alloc] init];
    vc.type = IntroduceInfoNew;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)setUpUI {

    //已经存在 UI
    if (!self.shopNameLbl) {
        
        __weak typeof(self) weakSelf = self;
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.bgScrollView.backgroundColor = HOME_BLACK_BACKGROUND_COLOR;
        self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:self.bgScrollView];
        
        //
        self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf tl_placeholderOperation];
            
        }];
        
        //
        self.scrollContentView = [[UIView alloc] init];
        [self.bgScrollView addSubview:self.scrollContentView];
        
        //
        [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.equalTo(self.bgScrollView);
            make.width.equalTo(self.bgScrollView.mas_width);

        }];
        
        
        //1.第一部分 公司 账户 和系统公告
        [self topUI];
        
        //2.第二部分
        [self accountUI];
        
        //3.系统公告
        [self sysMsgUI];
        
        //4.底部
        [self bootomUI];
        
    }



}



//--//
- (void)topUI {

   
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.scrollContentView addSubview:self.imageView1];
    self.imageView1.image = [UIImage imageNamed:@"home_setting"];
    
    //店铺名称
    self.shopNameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(18)
                                     textColor:HOME_TEXT_COLOR_1];
    [self.scrollContentView addSubview:self.shopNameLbl];
    
    //
    UIButton *introduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 80, 30)];
    [self.scrollContentView addSubview:introduceBtn];
    introduceBtn.x = SCREEN_WIDTH - 80;
    introduceBtn.titleLabel.font = FONT(12);
    [introduceBtn setTitle:@"新手入门" forState:UIControlStateNormal];
    [introduceBtn setTitleColor:HOME_TEXT_COLOR_1 forState:UIControlStateNormal];
    [introduceBtn addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
    
    
    //店铺状态
    self.shopStatusLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(12)
                                       textColor:HOME_TEXT_COLOR_1];
    [self.scrollContentView addSubview:self.shopStatusLbl];
    
    //店铺账号
    self.phoneLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(12)
                                  textColor:HOME_TEXT_COLOR_1];
    [self.scrollContentView addSubview:self.phoneLbl];
    
    //累计营业额
    //营业额
    self.totalTurnoverLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(12)
                                          textColor:[UIColor whiteColor]];
    [self.scrollContentView addSubview:self.totalTurnoverLbl];
    
    //类型名称
    //    self.shopTypeLbl = [UILabel labelWithFrame:CGRectZero
    //                                  textAligment:NSTextAlignmentCenter
    //                               backgroundColor:[UIColor clearColor]
    //                                          font:FONT(12)
    //                                     textColor:HOME_TEXT_COLOR_1];
    //    [self.scrollContentView addSubview:self.shopTypeLbl];
    
    //累计营业额
    [self.totalTurnoverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.phoneLbl.mas_centerY);
        make.left.equalTo(self.phoneLbl.mas_right).offset(20);
        
    }];
    
    [self.shopNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.scrollContentView.mas_top).offset(25);
        make.left.equalTo(self.scrollContentView.mas_left).offset(TOP_LEFT_MARGIN);
    }];
    
    
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView.mas_left).offset(15);
        make.centerY.equalTo(self.shopNameLbl.mas_centerY);
    }];
    
    [self.shopStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.shopNameLbl.mas_right).offset(25);
        make.centerY.equalTo(self.shopNameLbl.mas_centerY);
    }];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.shopNameLbl.mas_left);
        make.top.equalTo(self.shopNameLbl.mas_bottom).offset(12);
        
    }];
    
    //    [self.shopTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.phoneLbl.mas_centerY);
    //        make.left.equalTo(self.phoneLbl.mas_right).offset(20);
    //    }];
    
    //底线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HOME_TEXT_COLOR_1;
    
    //
    [self.scrollContentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollContentView).mas_offset(TOP_LEFT_MARGIN);
        make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
        make.top.equalTo(self.phoneLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
        
    }];

}



@end
