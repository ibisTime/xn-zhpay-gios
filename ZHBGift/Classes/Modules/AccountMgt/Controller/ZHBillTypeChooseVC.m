//
//  ZHBillTypeChooseVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/7/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHBillTypeChooseVC.h"
#import "ZHCurrencyModel.h"
#import "ZHWalletView.h"
#import "CDAccountApi.h"
#import "ZHBillVC.h"

@interface ZHBillTypeChooseVC ()

@end

@implementation ZHBillTypeChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账单查询";
    
    //
    [TLProgressHUD showWithStatus:nil];
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [CDAccountApi getFRBWSuccess:^(ZHCurrencyModel *FRBCurrency, ZHCurrencyModel *GiftBCurrency) {
        
        [TLProgressHUD dismiss];

        [self removePlaceholderView];
        
        //钱包
        NSArray *typeNames =  @[@"分润",@"礼品券"];
        NSArray *typeCode =  @[kFRB,kGiftB];
        CGFloat y = 2;
        CGFloat w = (SCREEN_WIDTH - 1)/2.0;
        CGFloat h = 60;
        CGFloat x = w + 1;
        UIView *lastView;
        __weak typeof(self) weakself = self;
        for (NSInteger i = 0; i < typeNames.count; i ++) {
            
            CGRect frame = CGRectMake((i%2)*x, (h + 1)*(i/2) + y + 10, w, h);
            ZHWalletView *walletView = [[ZHWalletView alloc] initWithFrame:frame];walletView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:walletView];
            
            walletView.typeLbl.text = typeNames[i];
            walletView.code = typeCode[i];
            walletView.action = ^(NSString *code){
                
                ZHBillVC *vc = [[ZHBillVC alloc] init];
                
                if ([code isEqualToString:kFRB]) {
                    
                    vc.accountNumber = FRBCurrency.accountNumber;

                } else {
                
                    vc.accountNumber = GiftBCurrency.accountNumber;

                }
                [weakself.navigationController pushViewController:vc animated:YES];
                
                
            };
            //        [self.walletViews addObject:walletView];
            lastView = walletView;
            if (i == 0) {
                
                walletView.moneyLbl.text = [FRBCurrency.amount convertToRealMoney];

            } else {
            
                walletView.moneyLbl.text = [GiftBCurrency.amount convertToRealMoney];

            }
            
        }
        
    } failure:^(NSError *err) {
        
        [TLProgressHUD dismiss];
        [self removePlaceholderView];
        
    }];
    
    
  
    
    
//  self.walletViews = [[NSMutableArray alloc] initWithCapacity:typeNames.count];
    

    
}



@end
