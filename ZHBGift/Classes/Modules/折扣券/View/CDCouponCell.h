//
//  CDCouponCell.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCoupon.h"

@interface CDCouponCell : UITableViewCell

@property (nonatomic,strong) ZHCoupon *coupon;

+ (CGFloat)rowHeight;

@end
