//
//  CDHomeOperationCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDHomeOperationCell.h"

@interface CDHomeOperationCell()

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UILabel *funNameLbl;

@property (nonatomic, strong) UILabel *operationLbl;

//
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *middleBtn;
@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation CDHomeOperationCell

- (CAShapeLayer *)bgLayer {

    if (!_bgLayer) {
        
        _bgLayer  = [CAShapeLayer layer];
    }
    return _bgLayer;
}

- (void)setOpModel:(CDHomeOperationModel *)opModel {

    _opModel = opModel;
    
    self.funNameLbl.text = _opModel.funcName;
    self.operationLbl.text = _opModel.operationName;

    [self.leftBtn setTitle:_opModel.leftText forState:UIControlStateNormal];
    [self.middleBtn setTitle:_opModel.middleText forState:UIControlStateNormal];
    [self.rightBtn setTitle:_opModel.rightText forState:UIControlStateNormal];

    if (_opModel.bottomActionEnables && _opModel.bottomActionEnables.count >= 3) {
        self.leftBtn.enabled = [_opModel.bottomActionEnables[0] boolValue];
        self.middleBtn.enabled = [_opModel.bottomActionEnables[1] boolValue];
        self.rightBtn.enabled = [_opModel.bottomActionEnables[2] boolValue];
    }
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView.layer addSublayer:self.bgLayer];
        CGFloat r = 15.0;
        self.bgLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH,ceil( (SCREEN_HEIGHT - TOP_UI_HEIGHT)/5.0));
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgLayer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(r, r)];
        self.bgLayer.path = path.CGPath;

        //s
        self.funNameLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(18)
                                        textColor:HOME_TEXT_COLOR_2];
        [self.contentView addSubview:self.funNameLbl];
        
        //
        self.operationLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(18)
                                        textColor:HOME_TEXT_COLOR_2];
        [self.contentView addSubview:self.operationLbl];
        
        
        //
        self.leftBtn = [self btnWithFrame:CGRectZero];
        [self.contentView addSubview:self.leftBtn];
        
        //
        self.rightBtn = [self btnWithFrame:CGRectZero];
        [self.contentView addSubview:self.rightBtn];

        self.middleBtn = [self btnWithFrame:CGRectZero];
        [self.contentView addSubview:self.middleBtn];
        
        //
        [self.funNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(18);
        }];
        
        [self.operationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.funNameLbl.mas_top);
        }];
        
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.funNameLbl.mas_bottom).offset(6);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            
        }];
        
        //
        [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.leftBtn.mas_top);
            make.centerX.equalTo(self.contentView.mas_centerX);
            
        }];
        
        //
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.leftBtn.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        
    }
    
    return self;
}


- (void)action:(UIButton *)btn {

    if ([btn isEqual:self.leftBtn]) {
        
        if (self.opModel.leftAction) {
            self.opModel.leftAction();
        }
        
    } else if ([btn isEqual:self.middleBtn]) {
    
        if (self.opModel.middleAction) {
            self.opModel.middleAction();
        }
        
    } else if ([btn isEqual:self.rightBtn]) {
    
        if (self.opModel.rightAction) {
            self.opModel.rightAction();
        }
        
    }
}

- (UIButton *)btnWithFrame:(CGRect)frame  {

    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = FONT(12);
    [btn setTitleColor:HOME_TEXT_COLOR_2 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
    

}

- (void)setBgColor2:(UIColor *)bgColor2 {
    
    _bgColor2 = bgColor2;
    
    self.bgLayer.fillColor = _bgColor2.CGColor;
}

- (void)setBgColor1:(UIColor *)bgColor1 {

    _bgColor1 = bgColor1;
    
    self.backgroundColor = _bgColor1;
    self.contentView.backgroundColor = _bgColor1;

}

@end
