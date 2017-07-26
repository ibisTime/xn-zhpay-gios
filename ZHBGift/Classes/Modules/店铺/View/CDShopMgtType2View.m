//
//  CDShopMgtType2View.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopMgtType2View.h"

@implementation CDShopMgtType2View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self UI];
    }
    return self;
}

- (void)UI {
    
    self.backgroundColor = [UIColor whiteColor];
    //
    self.topLeftLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(15)
                                    textColor:[UIColor themeColor]];
    
    [self addSubview:self.topLeftLbl];
    
    //
    self.bottomLeftLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self addSubview:self.bottomLeftLbl];
    
    //
    self.bottomMiddleLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(12)
                                   textColor:[UIColor textColor]];
    [self addSubview:self.bottomMiddleLbl];
    
    //
    self.bottomrightLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(12)
                                         textColor:[UIColor textColor]];
    [self addSubview:self.bottomrightLbl];
    
    
    
    //
    [self.topLeftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        
    }];
    
    [self.bottomLeftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.topLeftLbl.mas_left);
        make.top.equalTo(self.topLeftLbl.mas_bottom).offset(20);
        
    }];
    
    [self.bottomMiddleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomLeftLbl.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    [self.bottomrightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.bottomLeftLbl.mas_top);
        
    }];
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(LINE_HEIGHT);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //
    
}@end
