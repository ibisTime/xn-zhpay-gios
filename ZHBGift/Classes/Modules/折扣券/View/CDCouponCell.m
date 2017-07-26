//
//  CDCouponCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDCouponCell.h"

@interface CDCouponCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *soldOutImageView;
@property (nonatomic, strong) UILabel *topLbl;
@property (nonatomic, strong) UILabel *bottomLbl;

@end



@implementation CDCouponCell

+ (CGFloat)rowHeight {

    return 100;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 90)];
        [self addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        //
       UILabel *nameLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(16)
                                    textColor:[UIColor whiteColor]];
        [self.backgroundImageView addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
            make.centerY.equalTo(self.backgroundImageView.mas_centerY);
        }];
        nameLbl.text = @"抵扣券";
        
        //
        self.soldOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 60, 60)];
        self.soldOutImageView.xx_size = self.backgroundImageView.width - 10;
        [self.backgroundImageView addSubview:self.soldOutImageView];
        
        //--// 满价格
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(16)
                                       textColor:[UIColor themeColor]];
        [self.backgroundImageView addSubview:self.topLbl];
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.backgroundImageView.mas_left).offset(120);
            make.bottom.equalTo(self.backgroundImageView.mas_centerY);
        }];
        
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(13)
                                       textColor:[UIColor colorWithHexString:@"#999999"]];
        [self.backgroundImageView addSubview:self.bottomLbl];
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.backgroundImageView.mas_centerY).offset(2);

            make.left.equalTo(self.topLbl.mas_left);
        }];
        
        
    }
    return self;
    
}

- (void)setCoupon:(ZHCoupon *)coupon {
    
    _coupon = coupon;
    
    NSString *price1Str;
    NSString *price2Str;

    price1Str = [_coupon.key1 convertToSimpleRealMoney];
    price2Str = [_coupon.key2 convertToSimpleRealMoney];
    

    //
    NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满 %@",price1Str]];
    [attr1Str addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
                              } range:NSMakeRange(2, price1Str.length)];
    //--//
    NSMutableAttributedString *attr2Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"减 %@",price2Str]];
    [attr2Str addAttributes:@{
                              NSForegroundColorAttributeName : [UIColor zh_themeColor]
                              } range:NSMakeRange(2, price2Str.length)];
    
    self.topLbl.text = [NSString stringWithFormat:@"消费满%@元抵%@元",price1Str,price2Str];
    //日期
    if (_coupon.validateEnd) {
   
        self.bottomLbl.text = [NSString  stringWithFormat:@"有效期至 %@",[_coupon.validateEnd convertDate]];
        
    }
    if ([coupon.status isEqualToString:@"0"]) { //待上架
        
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券_bg_red"];
        
    } else if([coupon.status isEqualToString:@"1"]){ //已上架
        
        self.soldOutImageView.image = [UIImage new];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券_bg_red"];
        self.topLbl.textColor = [UIColor themeColor];
        self.bottomLbl.textColor = [UIColor colorWithHexString:@"#999999"];
        
    } else if([coupon.status isEqualToString:@"2"]) { //下架
        
        self.soldOutImageView.image = [UIImage imageNamed:@"已下架"];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券_bg_gray"];
        self.topLbl.textColor = [UIColor colorWithHexString:@"#cccccc"];
        self.bottomLbl.textColor = [UIColor colorWithHexString:@"#cccccc"];
        
    } else if([coupon.status isEqualToString:@"91"]) { //期满作废
        
        self.soldOutImageView.image = [UIImage imageNamed:@"已过期"];
        self.backgroundImageView.image = [UIImage imageNamed:@"抵扣券_bg_gray"];
        
        self.topLbl.textColor = [UIColor colorWithHexString:@"#cccccc"];
        self.bottomLbl.textColor = [UIColor colorWithHexString:@"#cccccc"];

        
    }
    
}


@end
