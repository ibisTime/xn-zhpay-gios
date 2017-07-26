//
//  CDConsumptionFlowCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDConsumptionFlowCell.h"

@implementation CDConsumptionFlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.userLbl];
        
        //
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.moneyLbl];
        
        //
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.timeLbl];
        
        
        
        [self.userLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userLbl.mas_left);
            make.top.equalTo(self.userLbl.mas_bottom).offset(5);
            
        }];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userLbl.mas_left);
            make.top.equalTo(self.moneyLbl.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bo
//        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
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
