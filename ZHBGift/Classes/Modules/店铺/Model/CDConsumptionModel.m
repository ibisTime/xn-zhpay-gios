//
//  CDConsumptionModel.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDConsumptionModel.h"

@implementation CDConsumptionModel

- (NSString *)getPayTypeName {

    NSDictionary *dict = @{
                           @"1" : @"余额",
                           @"3" : @"支付宝",
                           @"2" : @"微信"

                           };

    //
    return dict[self.payType];
    
}


- (NSString *)userName {

    return self.user[@"nickname"];
}

- (NSString *)userMobile {

    return self.user[@"mobile"];

}

- (NSString *)playMsg {


 NSDictionary *dict =   @{
                          @"0" : @"零" ,
      @"1" : @"妖",
      @"2" : @"二",
      @"3" : @"三",
      @"4" : @"四",
      @"5" : @"五",
      @"6" : @"六",
      @"7" : @"七",
      @"8" : @"八",
      @"9" : @"九"
      
      };
    
    
   
    NSString *lastMobile = [self.userMobile copy];
    //
    if (self.userMobile.length > 4 ) {
        
     lastMobile = [lastMobile substringFromIndex:lastMobile.length - 4];
        
        
    }
    
    NSString *str = @"";
    for (NSInteger i = 0; i < lastMobile.length; i ++) {
        
        NSString *charater = [lastMobile substringWithRange:NSMakeRange(i, 1)];
        if (dict[charater]) {
            
            str = [str stringByAppendingString:dict[charater]];

        }
        
    }
    
    return [NSString stringWithFormat:@"收到手机尾号为%@支付的%@礼品券",str,[self.storeAmount convertToRealMoney]];
    


}


@end
