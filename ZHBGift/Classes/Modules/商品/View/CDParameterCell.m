//
//  CDParameterCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDParameterCell.h"

@interface CDParameterCell()

@property (nonatomic, strong) UIView *bgView;


@end

@implementation CDParameterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#f2bec4"].CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(12)
                                        textColor:[UIColor textColor]];
        [self.bgView addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 2;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 0, 15));
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.top.equalTo(self.bgView.mas_top).offset(10);
            make.right.equalTo(self.bgView.mas_right).offset(-10);
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-10);

        }];
        
        
    }
    
    return self;

}


@end
