//
//  CDSetPwdVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDSetPwdVC.h"

@interface CDSetPwdVC()

@property (nonatomic, strong) UIView *topBgView;

@property (nonatomic, strong) UILabel *hintLbl1;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *hintLbl2;

@property (nonatomic, copy) TLTextField *pwdTf;

@end

@implementation CDSetPwdVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setUpUI];
   
}


- (void)setUpUI {

    self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [self.view addSubview:self.topBgView];
    self.topBgView.backgroundColor = [UIColor whiteColor];
    
    //
    self.hintLbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(14)
                                  textColor:[UIColor textColor2]];
    [self.topBgView addSubview:self.hintLbl1];
    
    //
    self.phoneLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(15)
                                  textColor:[UIColor textColor]];
    [self.topBgView addSubview:self.phoneLbl];
    
    //
    self.hintLbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(14)
                                  textColor:[UIColor textColor2]];
    [self.topBgView addSubview:self.hintLbl2];
    
    //
    [self.hintLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.phoneLbl.mas_top).offset(-15);
        make.centerX.equalTo(self.topBgView.mas_centerX);
        
    }];
    
    //
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.hintLbl1.mas_centerX);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
    //
    [self.hintLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.phoneLbl.mas_bottom).offset(15);
        make.centerX.equalTo(self.hintLbl1.mas_centerX);
    }];

    //
//    UIView *tfBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBgView.mas_bottom, SCREEN_WIDTH, 45)];
//    
//    self.pwdTf = [TLTextField alloc] initWithFrame:CGRectMake(0, 0, self.topBgView.mas_bottom + 10, 45)

}

@end
