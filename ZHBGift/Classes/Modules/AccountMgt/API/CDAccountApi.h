//
//  CDAccountApi.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHCurrencyModel.h"

@interface CDAccountApi : NSObject

+ (void)getFRBWSuccess:(void(^)(ZHCurrencyModel *FRBCurrency))success failure:(void(^)(NSError *err))failure;

@end
