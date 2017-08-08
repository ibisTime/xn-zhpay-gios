//
//  ZHHomeVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHFalseHomeVC.h"
#import "CDGoodsMgtVC.h"

#import "MJRefresh.h"
#import "ZHCategoryManager.h"
#import "ZHShop.h"
#import "UIButton+WebCache.h"
#import "ZHFuncView.h"
#import "ZHMsgVC.h"
#import "ZHBillVC.h"
#import "ZHWithdrawalVC.h"
#import "ZHCurrencyModel.h"
#import "ZHBillTypeChooseVC.h"
#import "ZHOrderVC.h"
#import "CDGoodsMgtVC.h"
#import "CDAccountApi.h"
#import "ZHAccountAboutVC.h"
#import "CDShopMgtVC.h"

//
@interface ZHFalseHomeVC ()

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UIButton *photoBtn;
@property (nonatomic,strong) UILabel *capitalLbl;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) ZHFuncView *kefuFuncView;

@property (nonatomic,strong) ZHCurrencyModel *accountInfo;

@property (nonatomic, strong) ZHCurrencyModel *FRBModel;
@end

@implementation ZHFalseHomeVC
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
 
    
    
    //
    self.bgScrollView  =  [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshState)];
    
    [self setUpUI];
    
    self.nameLbl.text = @"商户";
    self.capitalLbl.text = @"--.--";
//
//  
//    //增加通知
    [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[ZHUser user].userExt.photo convertImageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像占位图"]];
    
//    //获取未读信息
//    //异步更新---店铺信息
//    [self updateShopInfo];
//    
//    //获取账户信息
//    [self getAccountInfo];
//    
//    //更新用户数据
//    [[ZHUser user] updateUserInfo];
    
    
    //第一步,获取店铺信息
    [self firstStepGetShopInfo];
    
}


- (void)setData {

    
    self.nameLbl.text = [ZHShop shop].name;
    self.capitalLbl.text = [self.FRBModel.amount convertToRealMoney];

}



- (void)firstStepGetShopInfo {
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [TLProgressHUD showWithStatus:nil];
        
        //

        dispatch_group_t _topDataGroup = dispatch_group_create();
        
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
        
        
        //
        requestCount ++;
        dispatch_group_enter(_topDataGroup);
        [CDAccountApi getFRBWSuccess:^(ZHCurrencyModel *FRBCurrency,ZHCurrencyModel *GiftBCurrency) {
            topDataSuccessCount ++;
            dispatch_group_leave(_topDataGroup);
            
            self.FRBModel = FRBCurrency;
            
            
        } failure:^(NSError *err) {
            
            dispatch_group_leave(_topDataGroup);
            
        }];
        
        
     
        
    
        
        //
        dispatch_group_notify(_topDataGroup, dispatch_get_main_queue(), ^{
            
            [TLProgressHUD dismiss];
            //
            if (requestCount == topDataSuccessCount) {
                
                
                [self removePlaceholderView];
                [self setData];
                
            } else {
                
                //失败
                [self addPlaceholderView];
                
            }
            
            
        });
        

    
}




- (void)updateShopInfo {
    
//    [ZHShop getShopInfoWithToken:[ZHUser user].token userId:[ZHUser user].userId showInfoView:nil success:^(NSDictionary *shopDict) {
//        
//        if (shopDict) {
//            
//            [[ZHShop shop] changShopInfoWithDict:shopDict];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kShopInfoChange object:nil];
//            
//            if ([[ZHShop shop].level isEqualToString:@"2"]) {
//                
//                self.nameLbl.text = [NSString stringWithFormat:@"%@(公益)",[ZHShop shop].name];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}

#pragma mark- 获取账户信息
- (void)getAccountInfo {
    
    //查询账户信息
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        NSMutableArray <ZHCurrencyModel *>*arr = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        [arr enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kFRB]) {
                
                self.accountInfo = obj;
                self.capitalLbl.text = [self.accountInfo.amount convertToRealMoney];
            }
            
        }];
        
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithHUDText:@"获取用户信息失败"];
        
    }];
    
    
}

#pragma mark- 店铺信息变更
- (void)shopInfoChange {
    
    self.nameLbl.text = [ZHShop shop].name ? [ZHShop shop].name : @"商户";
    
}

#pragma mark- 用户信息变更的通知,处理
- (void)userInfoChange {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_INFO;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [[ZHUser user] saveUserInfo:responseObject[@"data"]];
        [[ZHUser user] setUserInfoWithDict:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
    }];
    
    if ([ZHUser user].userExt.photo) {
        
        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[ZHUser user].userExt.photo convertThumbnailImageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像占位图"]];
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

#pragma mark-- 刷新
- (void)refreshState {
    
    //1.用户信息
    //2.店铺信息
    //3.账户信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.bgScrollView.mj_header endRefreshing];
        
    });
    
    [self getAccountInfo]; //获取账户信息
    [self userInfoChange]; //用户信息变更
    [self updateShopInfo]; //异步更新用户信息
    
}



#pragma mark-- 设置
- (void)set {
    
    ZHAccountAboutVC *vc = [[ZHAccountAboutVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor accountSettingThemeColor]];
    
}

#pragma mark-- 取现
- (void)withdrawalBtn {
    
    [TLProgressHUD showWithStatus:nil];
    [CDAccountApi getFRBWSuccess:^(ZHCurrencyModel *FRBCurrency,ZHCurrencyModel *GiftBCurrency) {
        
        [TLProgressHUD dismiss];
        
        ZHWithdrawalVC *vc = [[ZHWithdrawalVC alloc] init];
        vc.accountNum = FRBCurrency.accountNumber;
        vc.balance = FRBCurrency.amount;
        vc.navigationController.navigationBar.barTintColor = [UIColor billThemeColor];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *err) {
        
        [TLProgressHUD dismiss];
        
    }];
    
}

#pragma mark-- 查看账单
- (void)lookBill {
    
    ZHBillTypeChooseVC *vc = [[ZHBillTypeChooseVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark-- 底部四个功能
- (void)funcAction:(NSInteger)index {
    
    switch (index) {
        case 0: {
            
            ZHOrderVC *vc = [[ZHOrderVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
         
        }  break;
        //
        case 1: {
            
            ZHMsgVC *msgVC = [[ZHMsgVC alloc] init];
            [self.navigationController pushViewController:msgVC animated:YES];
            
        }
            break;
        case 2:{
            
            CDShopMgtVC *vc = [CDShopMgtVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
           
         
        }
            break;
            
            
            //---//----//
        case 3: { //商城管理
            
            CDGoodsMgtVC *vc = [CDGoodsMgtVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }
            
            
            break;
            
    }
    
}


#pragma mark- 查看公益消费
- (void)lookProfit {
    
    
    
}



- (void)introduce {
    

    
}

- (void)setUpUI {
    
    //头部
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*576/750.0)];
    headerImageView.backgroundColor = [UIColor orangeColor];
    headerImageView.userInteractionEnabled = YES;
    headerImageView.image = [UIImage imageNamed:@"首页背景"];
    
    [self.bgScrollView addSubview:headerImageView];
    
    //名字
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, 30*SCREEN_SCALE, SCREEN_WIDTH, 25)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont systemFontOfSize:20*SCREEN_SCALE]
                                     textColor:[UIColor whiteColor]];
    [headerImageView addSubview:nameLbl];
    nameLbl.height = [[UIFont systemFontOfSize:20*SCREEN_SCALE] lineHeight];
    self.nameLbl = nameLbl;
    
    //头像
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, nameLbl.yy + 12*SCREEN_SCALE, 60*SCREEN_SCALE, 60*SCREEN_SCALE)];
    photoBtn.centerX = SCREEN_WIDTH/2.0;
    photoBtn.layer.cornerRadius = photoBtn.height / 2.0;
    photoBtn.layer.borderWidth = 2;
    photoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    photoBtn.clipsToBounds = YES;
    [headerImageView addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(set) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn = photoBtn;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"头像占位图"] forState:UIControlStateNormal];
    
    //入门
    UIButton *introduceBtn = [[UIButton alloc] init];
    [headerImageView addSubview:introduceBtn];
    introduceBtn.hidden = YES;
    [introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    introduceBtn.titleLabel.font = FONT(15);
    [introduceBtn setTitle:@"新手入门" forState:UIControlStateNormal];
    [introduceBtn addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
    [introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_left).offset(15);
        make.centerY.equalTo(self.nameLbl);
    }];
    
    //公益消费
    UIButton *profitBtn = [[UIButton alloc] init];
    [headerImageView addSubview:profitBtn];
    profitBtn.hidden  = YES;
    [profitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    profitBtn.titleLabel.font = FONT(15);
    [profitBtn setTitle:@"公益消费" forState:UIControlStateNormal];
    [profitBtn addTarget:self action:@selector(lookProfit) forControlEvents:UIControlEventTouchUpInside];
    [profitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerImageView.mas_right).offset(-15);
        make.centerY.equalTo(self.nameLbl);
    }];
    
    //资金说明
    UILabel *capitalExplainLbl = [UILabel labelWithFrame:CGRectMake(0, photoBtn.yy + 12*SCREEN_SCALE, SCREEN_WIDTH, 20)
                                            textAligment:NSTextAlignmentCenter
                                         backgroundColor:[UIColor clearColor]
                                                    font:[UIFont systemFontOfSize:13*SCREEN_SCALE]
                                               textColor:[UIColor whiteColor]];
    [headerImageView addSubview:capitalExplainLbl];
    capitalExplainLbl.height = [[UIFont systemFontOfSize:13*SCREEN_SCALE] lineHeight];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"总资产"];
    attach.bounds = CGRectMake(0, -2.5, 12*SCREEN_SCALE, 12*SCREEN_SCALE);
    NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
    [newAttrStr appendAttributedString: [[NSAttributedString alloc] initWithString:@" 当前总资产 (元)" attributes:@{
                                                                                                              NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:13*SCREEN_SCALE]
                                                                                                              
                                                                                                              }]];
    capitalExplainLbl.attributedText = newAttrStr;
    
    //具体资金数目
    UILabel *capitalLbl =  [UILabel labelWithFrame:CGRectMake(0, capitalExplainLbl.yy + 7*SCREEN_SCALE, SCREEN_WIDTH, 40)
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont systemFontOfSize:35*SCREEN_SCALE]
                                         textColor:[UIColor whiteColor]];
    [headerImageView addSubview:capitalLbl];
    capitalLbl.height = [[UIFont systemFontOfSize:35*SCREEN_SCALE] lineHeight];
    self.capitalLbl = capitalLbl;
    
    CGFloat billTopMargin = (headerImageView.height - self.capitalLbl.yy - 40*SCREEN_SCALE)/2;
    //账单按钮
    UIButton *billBtn = [UIButton borderBtnWithFrame:CGRectMake(30, capitalLbl.yy + billTopMargin, 130*SCREEN_SCALE, 40*SCREEN_SCALE)
                                               title:@"账单"
                                         borderColor:[UIColor whiteColor]];
    [headerImageView addSubview:billBtn];
    [billBtn addTarget:self action:@selector(lookBill) forControlEvents:UIControlEventTouchUpInside];
    billBtn.xx_size = SCREEN_WIDTH/2.0 - 20;
    billBtn.titleLabel.font = [UIFont secondFont];
    
    //    CGFloat y = SCREEN_SCALE;
    //提现按钮
    UIButton *withdrawalBtn = [UIButton borderBtnWithFrame:CGRectMake(SCREEN_WIDTH/2.0 + 20, billBtn.y, billBtn.width, billBtn.height)
                                                     title:@"提现"
                                               borderColor:[UIColor whiteColor]];
    [headerImageView addSubview:withdrawalBtn];
    [withdrawalBtn addTarget:self action:@selector(withdrawalBtn) forControlEvents:UIControlEventTouchUpInside];
    withdrawalBtn.titleLabel.font = [UIFont secondFont];
    
    //尾部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - headerImageView.height)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:footerView];
    
    //
    NSArray *funcImages = @[@"智能客服",@"系统公告",@"店铺管理",@"商城管理"];
    NSArray *funcNames = @[@"订单管理",@"系统公告",@"店铺管理",@"商城管理"];
    
    CGFloat funcW = 80;
    CGFloat funcH = funcW + 5 + 25;
    
    CGFloat leftMargin = (SCREEN_WIDTH - 2*funcW)/4.0;
    //    CGFloat topMargin = (SCREEN_HEIGHT - headerImageView.height - 2*funcH)/3;
    CGFloat topMargin = 37*SCREEN_SCALE;
    
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < funcImages.count; i ++) {
        
        CGFloat x = leftMargin + (funcW + 2*leftMargin)*(i%2);
        CGFloat y = topMargin + (topMargin + funcH)*(i/2);
        
        ZHFuncView *funcView = [[ZHFuncView alloc] initWithFrame:CGRectMake(x, y, funcW, funcH) funcName:funcNames[i] funcImage:funcImages[i]];
        funcView.index = i;
        funcView.selected = ^(NSInteger index){
            
            [weakSelf funcAction:index];
        };
        
        if (0 == i) {
            self.kefuFuncView = funcView;
        }
        
        [footerView addSubview:funcView];
        
    }
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
