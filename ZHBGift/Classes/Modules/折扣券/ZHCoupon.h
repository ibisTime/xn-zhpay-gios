//
//  ZHCoupon.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHCoupon : TLBaseModel

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSNumber *key1; //满足金额
@property (nonatomic,strong) NSNumber *key2; //减免 或者 返现金额
@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *currency; //币种

//商家状态
//NEW("0", "待上架"), ONLINE("1", "已上架"),
//OFFLINE("2", "已下架"), INVAILD("91", "期满作废");

//用户端的状态
// UNUSED("0", "未使用"), USED("1", "已使用"), INVAILD("2", "已过期");

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *storeCode; //店铺编号
@property (nonatomic,copy) NSString *systemCode; //系统编号

@property (nonatomic,copy) NSString *validateStart; //开始时间
@property (nonatomic,copy) NSString *validateEnd; //结束时间


//我的抵扣券--查出列表
@property (nonatomic,copy) NSString *ticketCode;
@property (nonatomic,strong) NSNumber *ticketKey1;
@property (nonatomic,strong) NSNumber *ticketKey2;

//@property (nonatomic,strong) NSString *ticketCode;
//@property (nonatomic,strong) NSString *ticketCode;

- (NSString *)discountInfoDescription;

// 我的抵扣券
//code = UT201701061232276735;
//createDatetime = "Jan 6, 2017 12:32:27 PM";
//status = 0;
//systemCode = "CD-CZH000001";
//ticketCode = ZKQ201701052055232041;
//ticketKey1 = 100000;
//ticketKey2 = 10000;
//ticketName = "Iosios--2-2";
//ticketType = 1;
//userId = U2017010321173181049;

@end

