//
//  CDBillDetailCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDBillDetailCell.h"

@interface CDBillDetailCell()



@end

@implementation CDBillDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        self.leftLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor2]];
        [self.contentView addSubview:self.leftLbl];
        
        //
        self.rightLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(15)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.rightLbl];
        
        [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.leftLbl.mas_right);
            
        }];
        
    }
    
    return self;
}

@end
