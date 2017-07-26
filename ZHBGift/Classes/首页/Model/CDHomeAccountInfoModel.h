//
//  CDHomeAccountInfoModel.h
//  ZHBGift
//
//  Created by  tianlei on 2017/6/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CDHomeAccountInfoModel : TLBaseModel

//数据来自很多地方

/**
 累计营业额
 */
@property (nonatomic, strong) NSNumber *totalTurnover;

/**
 累计分红收益
 */
@property (nonatomic, strong) NSNumber *totalProfit;

/**
 我的分红权个数
 */
@property (nonatomic, strong) NSNumber *mineProfitCount;

/**
 今日收入
 */
@property (nonatomic, strong) NSNumber *todaylTurnover;

/**
 今日提现
 */
@property (nonatomic, strong) NSNumber *todayWithdrawMoney;

@end
