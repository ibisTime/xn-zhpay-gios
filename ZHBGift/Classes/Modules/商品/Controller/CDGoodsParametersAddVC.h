//
//  CDGoodsParametersAddVC.h
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
@class CDGoodsParameterModel;

typedef NS_ENUM(NSInteger,GoodsParameterOperationType) {

    //new
    NewGoodsParameterOperationTypeAdd = 0,
    NewGoodsParameterOperationTypeDelete = 1,
    NewGoodsParameterOperationTypeChange = 2,

    //old
    OldGoodsParameterOperationTypeAdd = 10,
    OldGoodsParameterOperationTypeDelete = 11,
    OldGoodsParameterOperationTypeChange = 12
    
};

@protocol GoodsParametersOperationDelegate <NSObject>

- (void)finishOperationWithType:(GoodsParameterOperationType)type model:(CDGoodsParameterModel *)model playgroundVC:(UIViewController *)vc;

@end

@interface CDGoodsParametersAddVC : TLBaseVC


/**
 修改老商品，代号传入
 */
@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, assign) BOOL isOpNewGoods;


@property (nonatomic, weak) id<GoodsParametersOperationDelegate> delegate;


@property (nonatomic, strong) CDGoodsParameterModel *parameterModel;

//@property (nonatomic, copy) void(^addSuccess)(CDGoodsParameterModel *);
//@property (nonatomic, copy) void(^changeSuccess)(CDGoodsParameterModel *);


@end
