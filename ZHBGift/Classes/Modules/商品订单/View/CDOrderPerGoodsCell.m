//
//  CDOrderPerGoodsCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/7/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDOrderPerGoodsCell.h"

@implementation CDOrderPerGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contetnLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.contetnLbl];
        self.contetnLbl.numberOfLines = 0;
        //
        
        //
        self.numLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.numLbl];
        
        //
        
        [self.contetnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);

            
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.lessThanOrEqualTo(self.numLbl.mas_left);
        }];
        
        [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);

            
            make.right.equalTo(self.contentView.mas_right).offset(-15);
//            make.left.greaterThanOrEqualTo(self.contetnLbl.mas_right);
            make.width.equalTo(@80);
            
        }];
        
    }
    
    return self;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
