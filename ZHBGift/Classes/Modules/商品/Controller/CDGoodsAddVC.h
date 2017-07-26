//
//  CDGoodsAddVC.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
@class ZHGoodsModel;

@interface CDGoodsAddVC : TLBaseVC

@property (nonatomic, strong) ZHGoodsModel *goods;
@property (nonatomic,copy)  void(^addSuccess)();

@end
