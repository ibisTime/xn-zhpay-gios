//
//  CDOrderCategoryVC.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, CDOrderType) {
    CDOrderTypeWillSend,
    CDOrderTypeHasSend,
    CDOrderTypeFinshed
};

@interface CDOrderCategoryVC : TLBaseVC

@property (nonatomic, assign) CDOrderType type;

@end
