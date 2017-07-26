//
//  CDBillCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDBillCell.h"
#import "ZHBillModel.h"

@interface CDBillCell()

@property (nonatomic, strong) UILabel *dateTopLbl;
@property (nonatomic, strong) UILabel *dateBottomLbl;

@property (nonatomic, strong) UIImageView *typeImageView;

@property (nonatomic, strong) UILabel *moneyChangeLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end

@implementation CDBillCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //ui
        [self setUpUI];
        

    }
    
    return self;
}


- (void)setBillModel:(ZHBillModel *)billModel {

    _billModel = billModel;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:_billModel.createDatetime];
    
    formatter.dateFormat = @"dd日";
    formatter.locale = [NSLocale currentLocale];
    
    //得到日期1
    NSString *dateStr1 = [formatter stringFromDate:date01];
    
    //得到日期2
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr2 = [formatter stringFromDate:date01];

    
    
    
    self.dateTopLbl.text = dateStr1;
    self.dateBottomLbl.text = dateStr2;
    
    //
    if ([_billModel.transAmount longLongValue] > 0) {
        //收
        self.typeImageView.image = [UIImage imageNamed:@"bill_收"];
        self.moneyChangeLbl.textColor = [UIColor billThemeColor];
        self.moneyChangeLbl.text = [NSString stringWithFormat:@"+%@",[_billModel.transAmount convertToRealMoney]];

    } else {
        //支出
        self.typeImageView.image = [UIImage imageNamed:@"bill_支"];
        self.moneyChangeLbl.textColor = [UIColor colorWithRed:107/255.0 green:196/255.0 blue:250/255.0 alpha:1];
        self.moneyChangeLbl.text = [_billModel.transAmount convertToRealMoney];

    }
    
    self.detailLbl.text = _billModel.bizNote;
    
    
}

- (void)setUpUI {

    self.dateTopLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(16)
                                    textColor:[UIColor textColor]];
    [self.contentView addSubview:self.dateTopLbl];
    
    //
    self.dateBottomLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(12)
                                    textColor:[UIColor textColor2]];
    [self.contentView addSubview:self.dateBottomLbl];
    
    //
    self.typeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.typeImageView];
    
    //钱数目变化
    self.moneyChangeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(18)
                                    textColor:[UIColor billThemeColor]];
    [self.contentView addSubview:self.moneyChangeLbl];
    
    //
    self.detailLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(12)
                                       textColor:[UIColor textColor]];
    [self.contentView addSubview:self.detailLbl];
    
    //
    [self.dateTopLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    [self.dateBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateTopLbl.mas_left);
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
    }];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(70);
    }];
    
    //
    [self.moneyChangeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.typeImageView.mas_right).offset(26);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.right.lessThanOrEqualTo(self.contentView.mas_right);
        
        
    }];
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.moneyChangeLbl.mas_left);
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
        make.right.lessThanOrEqualTo(self.contentView.mas_right);

    }];
    
    //
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
