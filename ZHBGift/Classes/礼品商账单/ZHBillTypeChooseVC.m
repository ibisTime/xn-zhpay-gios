//
//  ZHNewMineWalletVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/3/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBillTypeChooseVC.h"
#import "ZHWalletView.h"
#import "ZHCurrencyModel.h"
#import "ZHBillVC.h"
#import "MJRefresh.h"
#import "TLHeader.h"
#import "ZHUser.h"
#import <Masonry/Masonry.h>

@interface ZHBillTypeChooseVC ()

@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic, strong) UILabel *frozenLbl;


@property (nonatomic,strong) NSMutableArray <ZHWalletView *>*walletViews;

@property (nonatomic,strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom; //币种
@property (nonatomic,strong) NSMutableDictionary <NSString *,ZHCurrencyModel *>*currencyDict;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation ZHBillTypeChooseVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isFirst) {
        
        self.isFirst = NO;
        [self.bgScrollView.mj_header beginRefreshing];
    }
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    self.isFirst = YES;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"点击重新加载"];
    [self refreshWalletInfo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"zh_acount_change" object:nil];
    
}

- (void)refresh {
    
    [self.bgScrollView.mj_header beginRefreshing];
    
    
}




- (void)setUpUI {
    
    if (self.bgScrollView) {
        return;
    }
    //背景
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 + 10)];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    
    
    
    //钱包
    NSArray *typeNames =  @[@"分润",@"礼品券",@"补贴"];
    NSArray *typeCode =  @[kFRB,kGiftB,@"BTB"];
    
    
    self.walletViews = [[NSMutableArray alloc] initWithCapacity:typeNames.count];
    //
    CGFloat y =  10;
    CGFloat w = (SCREEN_WIDTH - 1)/2.0;
    CGFloat h = 60;
    CGFloat x = w + 1;
    UIView *lastView;
    __weak typeof(self) weakself = self;
    for (NSInteger i = 0; i < typeNames.count; i ++) {
        
        CGRect frame = CGRectMake((i%2)*x, (h + 1)*(i/2) + y + 10, w, h);
        ZHWalletView *walletView = [[ZHWalletView alloc] initWithFrame:frame];walletView.backgroundColor = [UIColor whiteColor];
        [bgScrollView addSubview:walletView];
        
        walletView.typeLbl.text = typeNames[i];
        walletView.code = typeCode[i];
        walletView.action = ^(NSString *code){
            
            [weakself goWalletDetailWithCode:code];
            
        };
        [self.walletViews addObject:walletView];
        lastView = walletView;
        
        walletView.moneyLbl.text = @"0.00";
        
        
    }
    
    
    self.balanceLbl.text = @"0.00";
    
    
    bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshWalletInfo)];
    
}

- (void)tl_placeholderOperation {
    
    [self refreshWalletInfo];
    
}

- (void)refreshWalletInfo {
    
    
    //下部，钱包
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802503";
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        //ui操作
        [self removePlaceholderView];
        [self setUpUI];
        [self.bgScrollView.mj_header endRefreshing];
        
        //[weakSelf.mineTableView endRefreshHeader];
        
        //数据操作
        self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        //把币种分开
        self.currencyDict = [[NSMutableDictionary alloc] initWithCapacity:self.currencyRoom.count];
        [self.currencyRoom  enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            self.currencyDict[obj.currency] = obj;
            
        }];
        
        //刷新界面信息
        //        [self refreshWalletInfo];
        
        
        [self.walletViews enumerateObjectsUsingBlock:^(ZHWalletView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSNumber *amount = self.currencyDict[obj.code].amount;
            obj.moneyLbl.text = [amount convertToRealMoney];
            
            
            
            
        }];
        
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        
    }];
    
    
    
}




#pragma mark- 前往钱包
- (void)goWalletDetailWithCode:(NSString *)code {
    
    
    ZHBillVC *vc = [[ZHBillVC alloc] init];
    vc.accountNumber = self.currencyDict[code].accountNumber;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIImageView *)headerView {
    //
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    bgV.image = [UIImage imageNamed:@"我的钱包背景"];
    bgV.userInteractionEnabled = YES;
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookAllBill)];
    
    bgV.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *topLbl = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [FONT(12) lineHeight])
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(12)
                                    textColor:[UIColor whiteColor]];
    topLbl.text = @"补贴（元）";
    [bgV addSubview:topLbl];
    
    //
    self.balanceLbl = [UILabel labelWithFrame:CGRectMake(0, 0 + 12, SCREEN_WIDTH, [FONT(30) lineHeight])
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(30)
                                    textColor:[UIColor whiteColor]];
    //    self.balanceLbl.y = lbl.yy + 12;
    [bgV addSubview:self.balanceLbl];
    
    
    //    //底部提示
    //    UILabel *bootomHintlbl = [UILabel labelWithFrame:CGRectMake(0, self.balanceLbl.yy + 6, SCREEN_WIDTH, [FONT(11) lineHeight])
    //                                        textAligment:NSTextAlignmentCenter
    //                                     backgroundColor:[UIColor clearColor]
    //                                                font:FONT(11)
    //                                           textColor:[UIColor colorWithHexString:@"#99ffff"]];
    //    bootomHintlbl.text = @"(分润+贡献值)";
    //    [bgV addSubview:bootomHintlbl];
    
    self.frozenLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentCenter
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(12)
                                   textColor:[UIColor whiteColor]];
    //    self.balanceLbl.y = lbl.yy + 12;
    [bgV addSubview:self.frozenLbl];
    
    [topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgV.mas_top).offset(20);
        make.centerX.equalTo(bgV);
    }];
    
    [self.balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLbl.mas_bottom).offset(15);
        make.centerX.equalTo(bgV);
        
    }];
    
    [self.frozenLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.balanceLbl);
        make.top.equalTo(self.balanceLbl.mas_bottom).offset(15);
    }];
    
    return bgV;
    
}

@end


