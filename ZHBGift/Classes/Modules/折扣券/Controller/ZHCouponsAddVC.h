//
//  ZHCouponsAddVC.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHCoupon.h"

@interface ZHCouponsAddVC : TLBaseVC
@property (nonatomic,strong) ZHCoupon *coupon;
@property (nonatomic,copy) void(^addSuccess)();

@end
