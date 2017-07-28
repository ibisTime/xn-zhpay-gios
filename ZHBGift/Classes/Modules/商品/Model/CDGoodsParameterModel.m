//
//  CDGoodsParameterModel.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsParameterModel.h"

@implementation CDGoodsParameterModel

+ (NSString *)randomCode {

    return [NSString stringWithFormat:@"%f%u",[[NSDate date] timeIntervalSince1970],arc4random()%1000
];
    
}
- (NSString *)getDetailText {

//    return [NSString stringWithFormat:@"%@ 人民币/%@  购物币/%@ 钱包币/%@\n重量：%@kg  库存：%@  发货地:%@",self.name,[self.price1 convertToRealMoney],[self.price2 convertToRealMoney],[self.price3 convertToRealMoney],self.weight,self.quantity,self.province];
    
   return [NSString stringWithFormat:@"%@ 礼品券/%@ \n重量：%@kg  库存：%@  发货地:%@",self.name,[self.price1 convertToRealMoney],self.weight,self.quantity,self.province];

}

- (NSDictionary *)toDictionry {

    NSDictionary *dict = @{
                           
                           @"code" : self.code ? : @"",
                           @"name" : self.name ? : @"",
                           @"price1" : self.price1 ? : @"",
                           @"price2" :  @"0",
                           @"price3" :  @"0",
                           @"quantity" : self.quantity ? : @"",
                           @"province" : self.province ? : @"",
                           @"weight" : self.weight ? : @"",
                           @"orderNo" : @"1"
                           };
    
    return dict;

}

@end
