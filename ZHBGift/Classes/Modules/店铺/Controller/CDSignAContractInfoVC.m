//
//  CDSignAContractInfoVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDSignAContractInfoVC.h"

@interface CDSignAContractInfoVC ()

@end

@implementation CDSignAContractInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签约信息";
    
    UILabel *lbl = [UILabel labelWithFrame: CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(15)
                                 textColor:[UIColor themeColor]];
    [self.view addSubview:lbl];
    lbl.numberOfLines = 0;
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    self.view.backgroundColor = [UIColor whiteColor];
    lbl.text = @"使用抵扣券分成比例: 1%\n不使用抵扣券分成比例 10%";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
