//
//  CDConsumptionModel.h
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CDConsumptionModel : TLBaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *payDatetime;

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSNumber *price;

//
@property (nonatomic, strong) NSNumber *storeAmount;

//
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *userMobile;

@property (nonatomic, strong) NSDictionary *user;

- (NSString *)getPayTypeName;


- (NSString *)playMsg;

//payDatetime = "Jun 7, 2017 10:03:41 AM";
//payType = 1;
//price = 10000;

@end
