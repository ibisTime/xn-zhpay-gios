//
//  CDGoodsOfflineCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsOfflineCell.h"
#import "ZHGoodsModel.h"

@interface CDGoodsOfflineCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLbl;

@end

@implementation CDGoodsOfflineCell


- (void)setGoodsModel:(ZHGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
    
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[_goodsModel.advPic convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = @"编辑重新上架";
    
    //
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //
        self.coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.coverImageView];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.image = [UIImage imageNamed:@"goods_placeholder"];
        self.coverImageView.clipsToBounds = YES;
        
        //
        UIView *placeholderV = [[UIView alloc] init];
        placeholderV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.contentView addSubview:placeholderV];
        
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor goodsThemeColor]];
        [placeholderV addSubview:self.nameLbl];
        self.nameLbl.numberOfLines = 2;
        
  
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
 
        [placeholderV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(40);
            
        }];
        
        //
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(placeholderV.mas_left).offset(5);
            make.right.equalTo(placeholderV.mas_right).offset(-5);
            make.top.equalTo(placeholderV.mas_top);
            make.bottom.equalTo(placeholderV.mas_bottom);
        }];
        
    }
    //
    return self;
    
}


@end
