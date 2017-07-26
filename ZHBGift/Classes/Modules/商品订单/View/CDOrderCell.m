//
//  CDOrderCell.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDOrderCell.h"

@interface CDOrderCell()

@property (nonatomic, strong) UILabel *orderNumLbl;

//收货人
@property (nonatomic, strong) UILabel *receivePeopleLbl;
@property (nonatomic, strong) UILabel *receivePeopleMobileLbl;

@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *buyTimeLbl;

@property (nonatomic, strong) UILabel *expressInfoLbl;
@property (nonatomic, strong) UILabel *deliveryTimeLbl;

//收货时间
@property (nonatomic, strong) UILabel *receiverTimeLbl;


@end


@implementation CDOrderCell


-(void)setOrderModel:(ZHOrderModel *)orderModel {

    _orderModel = orderModel;
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单号：%@",_orderModel.code];
    self.receivePeopleLbl.text = [NSString stringWithFormat:@"收件人：%@",_orderModel.receiver];
    //
    self.receivePeopleMobileLbl.text = [NSString stringWithFormat:@"联系电话：%@",_orderModel.reMobile];
    
    //
    self.addressLbl.text = [NSString stringWithFormat:@"收件地址：%@",_orderModel.reAddress];
    
    //
    self.buyTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[_orderModel.applyDatetime convertToDetailDate]];
    
    //已经发货的订单
    if (_orderModel.logisticsCode) {
        
        
        self.expressInfoLbl.text = [NSString stringWithFormat:@"%@：%@",_orderModel.logisticsCompany,_orderModel.logisticsCode];
        self.deliveryTimeLbl.text = [NSString stringWithFormat:@"发货时间：%@", _orderModel.deliveryDatetime ? [_orderModel.deliveryDatetime convertToDetailDate] : @"--"];
        
        //已经确认收货
        if ([_orderModel.status isEqualToString:ORDER_STATUS_HAS_RECEIVER]) {
            
            self.receiverTimeLbl.text = [NSString stringWithFormat:@"收货时间：%@",[_orderModel.updateDatetime convertToDetailDate]];
            
        }
        
    }
    
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.orderNumLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.orderNumLbl];
        //
        self.receivePeopleLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.receivePeopleLbl];
        
        //
        self.orderNumLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.orderNumLbl];
        
        //
        self.receivePeopleMobileLbl = [UILabel labelWithFrame:CGRectZero
                                                 textAligment:NSTextAlignmentRight
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(13)
                                         textColor:[UIColor textColor]];
        [self.contentView addSubview:self.receivePeopleMobileLbl];
        
        
        self.addressLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                              backgroundColor:[UIColor whiteColor]
                                                         font:FONT(13)
                                                    textColor:[UIColor textColor]];
        [self.contentView addSubview:self.addressLbl];
        
        //
        self.buyTimeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.buyTimeLbl];
        
        //快递 ，发货时间
        self.expressInfoLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentRight
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor orderThemeColor]];
        [self.contentView addSubview:self.expressInfoLbl];
        
        //
        self.deliveryTimeLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight
                                      backgroundColor:[UIColor whiteColor]
                                                 font:FONT(13)
                                            textColor:[UIColor orderThemeColor]];
        [self.contentView addSubview:self.deliveryTimeLbl];
        
        //用户已确认收货
        UILabel *userConfirmReveive = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentRight
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(13)
                                             textColor:[UIColor orderThemeColor]];
        [self.contentView addSubview:userConfirmReveive];
        userConfirmReveive.text = @"用户已确认收货";
        
        //收货时间
        self.receiverTimeLbl = [UILabel labelWithFrame:CGRectZero
                                          textAligment:NSTextAlignmentRight
                                       backgroundColor:[UIColor whiteColor]
                                                  font:FONT(13)
                                             textColor:[UIColor orderThemeColor]];
        [self.contentView addSubview:self.receiverTimeLbl];
        
        
        //------约束--------//
        [self.orderNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        [self.receivePeopleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumLbl.mas_left);
            make.top.equalTo(self.orderNumLbl.mas_bottom).offset(9);
        }];
        
        //电话
        [self.receivePeopleMobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.receivePeopleLbl.mas_top);
            
        }];
    
        
        //地址
        [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumLbl.mas_left);
            make.top.equalTo(self.receivePeopleLbl.mas_bottom).offset(9);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.buyTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumLbl.mas_left);
            make.top.equalTo(self.addressLbl.mas_bottom).offset(9);
        }];
        
        [self.expressInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumLbl.mas_left);
            make.top.equalTo(self.buyTimeLbl.mas_bottom).offset(15);
        }];
        
        [self.deliveryTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.expressInfoLbl.mas_right);
            make.top.equalTo(self.expressInfoLbl.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
//            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        
        [userConfirmReveive mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.orderNumLbl.mas_left);
            make.top.equalTo(self.expressInfoLbl.mas_bottom).offset(7);
            
        }];
        
        
        [self.receiverTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(userConfirmReveive.mas_right);
            make.top.equalTo(userConfirmReveive.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
            //            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        //
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.bottom.equalTo(self.expressInfoLbl.mas_bottom);
//            
//        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;
    
}

@end
