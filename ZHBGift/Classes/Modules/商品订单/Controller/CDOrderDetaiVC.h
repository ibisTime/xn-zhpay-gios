//
//  CDOrderDetaiVC.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@class ZHOrderModel;

@interface CDOrderDetaiVC : TLBaseVC

@property (nonatomic, strong) ZHOrderModel *orderModel;
@property (nonatomic,copy) void(^deliverSuccess)();

@end
