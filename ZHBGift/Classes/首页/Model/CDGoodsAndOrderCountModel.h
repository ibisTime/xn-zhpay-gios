//
//  CDGoodsAndOrderCountModel.h
//  ZHBGift
//
//  Created by  tianlei on 2017/6/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CDGoodsAndOrderCountModel : TLBaseModel

@property (nonatomic, strong) NSNumber *productCount;

/**
 上架产品数
 */
@property (nonatomic, strong) NSNumber *putOnProductCount;

/**
 下架产品数
 */
@property (nonatomic, strong) NSNumber *putOffProductCount;

/**
 订单数
 */
@property (nonatomic, strong) NSNumber *orderCount;

/**
 待发货
 */
@property (nonatomic, strong) NSNumber *toSendOrderCount;

/**
 待收货
 */
@property (nonatomic, strong) NSNumber *toReceiveOrderCount;


@end
