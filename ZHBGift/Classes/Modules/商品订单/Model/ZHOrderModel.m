//
//  ZHOrderModel.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderModel.h"
//#import "ZHOrderDetailModel.h"

@implementation ZHOrderModel


//+ (NSDictionary *)mj_objectClassInArray {
//
//    return @{ @"productOrderList" : [ZHOrderDetailModel class]};
//
//}

- (CGFloat)deliverAddressHeight {

 return  [self.reAddress calculateStringSize:CGSizeMake(SCREEN_WIDTH - 115, MAXFLOAT) font:FONT(15)].height + 45 - [FONT(15) lineHeight];

}

//- (NSString *)deliveryDatetime {
//    
//    _deliveryDatetime = nil;
//    
//    if (_deliveryDatetime) {
//        return _deliveryDatetime;
//    }
//    
//    return _deliveryDatetime;
//}

- (NSString *)productSpecsName {

    if (_productSpecsName) {
        
       return _productSpecsName;
        
    }
    
    return @"无";
    
}


@end


