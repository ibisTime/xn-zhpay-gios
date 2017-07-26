//
//  ZHGoodsModel.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsModel.h"

@implementation ZHGoodsModel

//+ (NSDictionary *)tl_replacedKeyFromPropertyName
//{
//    
//    return @{  @"description" : @"descriptionPro" };
//    
//}

//TO_APPROVE("0", "待审核"), APPROVE_YES("1", "审批通过待上架"), APPROVE_NO("91",
//                                                                //        "审批不通过"), PUBLISH_YES("3", "已上架"), PUBLISH_NO("4", "已下架");

- (NSString *)getStatusName {

    NSDictionary *dict = @{
                           @"0" : @"审核中",
                           @"1" : @"待上架",
                           
                           @"91" : @"不通过",
                           @"3" : @"已上架",
                           @"4" : @"已下架"
                           };

    // 0 已提交 1.审批通过 2.审批不通过 3.已上架 4.已下架
    
    return dict[self.status];
    
}
- (void)setPic:(NSString *)pic {

    
    _pic = [pic copy];
    self.pics = [pic componentsSeparatedByString:@"||"];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.descriptionPro = value;
    }

}
@end
