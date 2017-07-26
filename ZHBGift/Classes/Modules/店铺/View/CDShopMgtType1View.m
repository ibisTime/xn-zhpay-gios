//
//  CDShopMgtType1View.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopMgtType1View.h"

@implementation CDShopMgtType1View

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
    self.topRightLbl = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentLeft
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(12)
                                             textColor:[UIColor textColor]];
    [self addSubview:self.topRightLbl];
    
    //
    self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self addSubview:self.bottomLbl];
    self.bottomLbl.numberOfLines = 0;
    
    //
    [self.topLeftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        
    }];

    [self.topRightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.topLeftLbl.mas_right).offset(15);
        make.bottom.equalTo(self.topLeftLbl.mas_bottom);
        
    }];
    
    [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.topLeftLbl.mas_left);
        make.top.equalTo(self.topLeftLbl.mas_bottom).offset(6);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-60);

        
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
    
}

@end
