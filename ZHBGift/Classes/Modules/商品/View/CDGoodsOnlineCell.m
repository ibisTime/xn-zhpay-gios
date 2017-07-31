//
//  CDGoodsOnlineCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsOnlineCell.h"
#import "ZHGoodsModel.h"

@interface CDGoodsOnlineCell()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation CDGoodsOnlineCell

- (void)setGoodsModel:(ZHGoodsModel *)goodsModel {

    _goodsModel = goodsModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[_goodsModel.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = _goodsModel.name;;
    
    self.editBtn.userInteractionEnabled = NO;
    self.previewBtn.userInteractionEnabled = self.editBtn.userInteractionEnabled;
    
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
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
        [placeholderV addSubview:self.nameLbl];
        self.nameLbl.numberOfLines = 2;
        
        //
        self.editBtn = [self btnWithTitle:@"编辑"];
        [self.contentView addSubview:self.editBtn];
        [self.editBtn setBackgroundColor:[UIColor colorWithHexString:@"#41df96"] forState:UIControlStateNormal];
        
        //
        self.previewBtn = [self btnWithTitle:@"预览"];
        [self.contentView addSubview:self.previewBtn];
        [self.previewBtn setBackgroundColor:[UIColor goodsThemeColor] forState:UIControlStateNormal];
        
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(40);
        }];
        
        [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.editBtn.mas_left);
            make.width.equalTo(self.editBtn.mas_width);
            make.height.equalTo(self.editBtn.mas_height);
        }];
        
        
        [placeholderV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.previewBtn.mas_left);
            
            make.height.equalTo(self.editBtn.mas_height);
            
        }];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(placeholderV.mas_left).offset(5);
            make.right.equalTo(placeholderV.mas_right).offset(-5);
            make.top.equalTo(placeholderV.mas_top).offset(5);

        }];
        
    }
    //
    return self;

}


- (UIButton *)btnWithTitle:(NSString *)title {

    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = FONT(12);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    
    return btn;
}
@end
