//
//  CDHomeOperationCell.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDHomeOperationModel.h"

#define TOP_UI_HEIGHT  240


@interface CDHomeOperationCell : UITableViewCell

@property (nonatomic, strong) CDHomeOperationModel *opModel;

@property (nonatomic, strong) UIColor *bgColor1; //整体北京侧

@property (nonatomic, strong) UIColor *bgColor2; //带圆弧的背景色



@end
