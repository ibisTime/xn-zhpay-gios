//
//  ZHBankCardAddVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardAddVC.h"
#import "TLPickerTextField.h"
#import "ZHBank.h"
#import "ZHPwdRelatedVC.h"

@interface ZHBankCardAddVC ()

@property (nonatomic,strong) TLTextField *realNameTf;

@property (nonatomic,strong) TLPickerTextField *bankNameTf; //开户行
//@property (nonatomic,strong) TLTextField *subbranchTf; //支行

@property (nonatomic,strong) TLTextField *bankCardTf;
//@property (nonatomic,strong) TLTextField *mobileTf;
@property (nonatomic, strong) TLTextField *tradePwdTf;

//
@property (nonatomic,strong) UIScrollView *bgSV;
@property (nonatomic,strong) UIButton *operationBtn;

@property (nonatomic,strong) NSMutableArray <ZHBank *>*banks; //所有银行
@property (nonatomic,strong) NSMutableArray <NSString *>*bankNames; //所有银行


@end


@implementation ZHBankCardAddVC





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";

    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgScrollView];
    self.bgSV = bgScrollView;

    
    [self setUpUI];
    
    if (self.bankCard) {
        
        self.realNameTf.text = self.bankCard.realName;
//        self.realNameTf.enabled = NO;
        self.bankNameTf.text = self.bankCard.bankName;
//        self.subbranchTf.text = self.bankCard.subbranch;
        self.bankCardTf.text = self.bankCard.bankcardNumber;
//        self.mobileTf.text = self.bankCard.bindMobile;
        [self.operationBtn setTitle:@"修改" forState:UIControlStateNormal];
        self.title = @"修改银行卡";
    }
    
    //查询能绑定的银行卡
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"802116";
//    http.parameters[@"token"] = [ZHUser user].token;
//    //11 易宝 12 宝付 13 富友 01 线下
//    http.parameters[@"channelType"] = @"11";
//    [http postWithSuccess:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    //获取银行卡渠道
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802116";
    http.parameters[@"channelType"] = @"40";
    http.parameters[@"status"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.banks = [ZHBank tl_objectArrayWithDictionaryArray:arr];
        
        self.bankNames = [NSMutableArray arrayWithCapacity:self.banks.count];
        [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.bankNames addObject:obj.bankName];
            
        }];
        
        self.bankNameTf.tagNames = self.bankNames;

    } failure:^(NSError *error) {
        
    }];

}

- (void)bindCard {

    if (![self.realNameTf.text valid]) {
        [TLAlert alertWithMsg:@"请输入姓名"];
        return;
    }
    
    
    if (![self.bankNameTf.text valid]) {
        [TLAlert alertWithMsg:@"请选择银行卡"];
        return;
    }
    
//    if (![self.subbranchTf.text valid]) {
//        [TLAlert alertWithMsg:@"请填写开户支行"];
//        return;
//    }
    
    if (![self.bankCardTf.text valid]) {
        [TLAlert alertWithMsg:@"请填写银行卡号"];
        return;
    }
    
//    if (![self.mobileTf.text valid]) {
//        [TLAlert alertWithMsg:@"请填写与银行卡绑定的手机号"];
//        return;
//    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.bankCard) {//修改
        
        if (![self.tradePwdTf.text valid]) {
            [TLAlert alertWithMsg:@"请输入支付密码"];
            return;
        }
        //
        http.code = @"802013";
        http.parameters[@"code"] = self.bankCard.code;
        http.parameters[@"status"] = @"1";
        http.parameters[@"tradePwd"] = self.tradePwdTf.text;
        
    } else {//绑定
    
       http.code = @"802010";
    
    }

    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"realName"] = self.realNameTf.text;
    
    NSString *bankName = self.bankNameTf.text;
  __block  ZHBank *bank = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.bankName isEqualToString:bankName]) {
            bank = obj;
            *stop = YES;
        }
    }];
    
    __block  NSString *bankCode = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankName isEqualToString: self.bankNameTf.text ]) {
            bankCode = obj.bankCode;
        }
    }];
   
    
    if (!bankCode) {
        [TLAlert alertWithHUDText:@"暂时无法添加"];
        return;
    }
    
    
    http.parameters[@"bankName"] = self.bankNameTf.text;
    http.parameters[@"bankCode"] = bankCode;

//    http.parameters[@"subbranch"] = self.subbranchTf.text;//支行
    http.parameters[@"bankcardNumber"] = self.bankCardTf.text; //卡号
//    http.parameters[@"bindMobile"] = self.mobileTf.text; //绑定的手机号
    http.parameters[@"currency"] = @"CNY"; //币种
    http.parameters[@"type"] = @"B"; //b端用户


//  C=C端用户 B=B端用户 1=保证金账户；2=进钱账户；3=出钱账户；4=走账户
    [http postWithSuccess:^(id responseObject) {
        
        if (self.bankCard) {
            
            [TLAlert alertWithHUDText:@"修改成功"];

        } else {
            [TLAlert alertWithHUDText:@"绑定成功"];

        }
        
        [self.navigationController popViewControllerAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ZHBankCard *card = [[ZHBankCard alloc] init];
            card.bankName = self.bankNameTf.text;
//            card.bankCode = responseObject[@"data"];
            card.bankcardNumber = self.bankCardTf.text;
//            card.subbranch = self.subbranchTf.text;
            if (self.addSuccess) {
                self.addSuccess(card);
            }
        });
        
    } failure:^(NSError *error) {
        
        
    }];


}

- (void)setUpUI {

    CGFloat leftW = 90;
    CGFloat margin = 0.5;
    
    //户名
    TLTextField *nameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"户名" titleWidth:leftW placeholder:@"请输入银行卡所属人姓名"];
    [self.bgSV addSubview:nameTf];
    self.realNameTf = nameTf;
    
    //开户行
    TLPickerTextField *bankPick = [[TLPickerTextField alloc] initWithframe:CGRectMake(0, nameTf.yy + margin, SCREEN_WIDTH, nameTf.height) leftTitle:@"开户行" titleWidth:leftW placeholder:@"请选择开户行"];
//    bankPick.tagNames = @[@"农业",@"深证",@"哪里"];
    [self.bgSV addSubview:bankPick];
    self.bankNameTf = bankPick;
    
//    //开户支行
//    TLTextField *subbranchTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankPick.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"开户支行" titleWidth:leftW placeholder:@"请输入开户支行"];
//    [self.bgSV addSubview:subbranchTf];
//    self.subbranchTf = subbranchTf;
    
    //卡号
    TLTextField *bankCardTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankPick.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"银行卡号  " titleWidth:leftW placeholder:@"请输入银行卡号"];
    [self.bgSV addSubview:bankCardTf];
    bankCardTf.keyboardType = UIKeyboardTypeNumberPad;
    self.bankCardTf = bankCardTf;
    
    //手机号
//    TLTextField *mobileTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankCardTf.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"手机号" titleWidth:leftW placeholder:@"请输入银行卡预留手机号"];
//    [self.bgSV addSubview:mobileTf];
//    mobileTf.keyboardType = UIKeyboardTypeNumberPad;
//    self.mobileTf = mobileTf;
    
    self.tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankCardTf.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"支付密码" titleWidth:leftW placeholder:@"请输入支付密码"];
    [self.bgSV addSubview:self.tradePwdTf];
    self.tradePwdTf.secureTextEntry = YES;
    
    if (!self.bankCard) {
        self.tradePwdTf.height = 0.01;
        self.tradePwdTf.hidden = YES;
    }
    
    //
    UIButton *addBtn = [UIButton zhBtnWithFrame:CGRectMake(15, self.tradePwdTf.yy + 30, SCREEN_WIDTH - 30, 45) title:@"添加"];
    [self.bgSV addSubview:addBtn];
    [addBtn setBackgroundColor:[UIColor accountSettingThemeColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(bindCard) forControlEvents:UIControlEventTouchUpInside];
    self.operationBtn = addBtn;

    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, addBtn.yy + 10, SCREEN_WIDTH - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
    [self.view addSubview:setPwdBtn];
    [setPwdBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[ZHUser user].tradepwdFlag isEqualToString:@"1"]) {
        setPwdBtn.hidden = YES;
    }
    
}

- (void)setTrade:(UIButton *)btn {
    
    ZHPwdRelatedVC *tradeVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
    tradeVC.success = ^() {
        
        btn.hidden = YES;
        
    };
    [self.navigationController pushViewController:tradeVC animated:YES];
    
    
}

@end
