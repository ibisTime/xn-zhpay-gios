//
//  CDGoodsAddCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsAddCell.h"

@implementation CDGoodsAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_add"]];
        [self.contentView addSubview:addImgView];
        
        
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor textColor2]];
        [self.contentView addSubview:hintLbl];
        hintLbl.text = @"添加商品";
        
        
        [addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-25);
            
        }];
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(addImgView.mas_centerX);
            make.top.equalTo(addImgView.mas_bottom).offset(15);
        }];
        
    }
    return self;
}
@end
