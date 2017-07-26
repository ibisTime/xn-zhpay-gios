//
//  ZHOrderModel.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
//#import "ZHOrderDetailModel.h"
#import "ZHGoodsModel.h"

#define ORDER_STATUS_WILL_SEND @"2"
#define ORDER_STATUS_HAS_SEND @"3"
#define ORDER_STATUS_HAS_RECEIVER @"4"


@interface ZHOrderModel : TLBaseModel

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *receiver; //收货人
@property (nonatomic,copy) NSString *reMobile; //电话
@property (nonatomic,copy) NSString *reAddress; //地址
@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,copy) NSString *applyNote; //商家嘱托


//物品数组
//@property (nonatomic,copy) NSArray <ZHOrderDetailModel *> *productOrderList;

@property (nonatomic, strong) ZHGoodsModel *product;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, copy) NSString *productSpecsName;

//1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态
@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间

@property (nonatomic,copy) NSString *logisticsCode; //发货
@property (nonatomic,copy) NSString *logisticsCompany; //快递公司
@property (nonatomic, copy) NSString *updateDatetime;


- (CGFloat)deliverAddressHeight;
//下单数量
//买家嘱托
@end





