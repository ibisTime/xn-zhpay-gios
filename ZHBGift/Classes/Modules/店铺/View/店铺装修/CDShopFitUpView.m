//
//  CDShopFitUpView.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopFitUpView.h"

@implementation CDShopFitUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //
        self.topImageView = [[UIImageView alloc] init];
        [self addSubview:self.topImageView];
        
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(12)
                                       textColor:[UIColor textColor]];
        [self addSubview:self.bottomLbl];
        self.bottomLbl.numberOfLines = 0;

        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_top).offset(30);
            make.centerX.equalTo(self.mas_centerX);
            
        }];
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_bottom).offset(-25);
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_left).offset(-5);


        }];
        
        
        //
        self.tmpImageView = [[UIImageView alloc] init];
        [self addSubview:self.tmpImageView];
        self.tmpImageView.clipsToBounds = YES;
        self.tmpImageView.hidden = YES;
        self.tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.tmpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
            
        }];
    
    }
    return self;
}

@end
