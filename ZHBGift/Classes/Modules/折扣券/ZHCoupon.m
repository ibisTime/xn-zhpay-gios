//
//  ZHCoupon.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCoupon.h"

@implementation ZHCoupon

//+ (NSDictionary *)tl_replacedKeyFromPropertyName {
//
//    return @{ @"description" : @"desc" };
//
//}

- (NSString *)discountInfoDescription {

    if (self.key1) {
        
      return  [NSString stringWithFormat:@"满 %@\n减 %@",[self.key1 convertToRealMoney],[self.key2 convertToRealMoney]];
        
    } else {
    
          return  [NSString stringWithFormat:@"满 %@\n减 %@",[self.ticketKey1 convertToRealMoney],[self.ticketKey2 convertToRealMoney]];
    
    }

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }

}

@end
