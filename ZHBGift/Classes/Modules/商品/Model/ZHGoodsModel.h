//
//  ZHGoodsModel.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

#define GOODS_STATUS_XIA_JIA @"4"
#define GOODS_STATUS_SHANG_JIA @"3"

@interface ZHGoodsModel : TLBaseModel

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic,copy) NSString *slogan;

@property (nonatomic,copy) NSString *category; //小类
@property (nonatomic,copy) NSString *type; //大类

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *descriptionPro;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *quantity;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic, strong) NSNumber *price1;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;

- (NSString *)getStatusName;

@property (nonatomic,copy) NSString *status;

//由pic1 转化成的数组
@property (nonatomic,copy) NSArray *pics;
@property (nonatomic,copy) NSString *updateDatetime;


@end
