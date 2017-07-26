//
//  ZHGoodsCell.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/13.
//  Copyright © 2016年  tianlei. All rights reserved.
//  订单 和 商品共用的 --- cell

#import <UIKit/UIKit.h>

@interface ZHGoodsCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (nonatomic,strong) id model;

@end
