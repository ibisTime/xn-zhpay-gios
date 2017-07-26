//
//  CDShopMgtTopBottomView.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopMgtTopBottomView.h"

@implementation CDShopMgtTopBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentCenter
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(27)
                                             textColor:[UIColor themeColor]];
        [self addSubview:self.topLbl];
        
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor whiteColor]
                                                 font:FONT(12)
                                            textColor:[UIColor textColor]];
        [self addSubview:self.bottomLbl];
        
        
        
        //
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(15);
            
        }];
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.topLbl.mas_bottom).offset(14);
            make.centerX.equalTo(self.mas_centerX);
            
        }];
        
        
    }
    return self;
}

@end
