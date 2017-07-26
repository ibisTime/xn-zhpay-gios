//
//  ZHShop.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/19.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHShopTypeModel.h"

#define SHOP_STATUS_WILL_CHECK @"0"
#define SHOP_STATUS_CHECK_REFUSE @"91"

#define SHOP_STATUS_OPEN @"2"
#define SHOP_STATUS_CLOSE @"3"

#define SHOP_STATUS_WILL_DOWN @"1"
#define SHOP_STATUS_DOWN @"4"

//TOCHECK("0", "待审核"),
//UNPASS("91", "审核不通过"),

//PASS("1", "审核通过待上架"),
//ON_OPEN( "2", "已上架，开店"),
//ON_CLOSE("3", "已上架，关店"),

//OFF("4", "已下架");


@interface ZHShop : TLBaseModel
+ (instancetype)shop;

//从本地读取店铺信息，有返回yes,并初始化用户信息 否则返回NO
- (BOOL)getInfo;


//已经申请过店铺的为Yes，
@property (nonatomic,assign) BOOL haveShopInfo;

@property (nonatomic, copy) NSString *level;

@property (nonatomic,copy) NSString *contractNo;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *advPic; //封面图
@property (nonatomic,copy) NSString *type; //地址

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *address;//详细地址

@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;

@property (nonatomic,copy) NSString *bookMobile; //电话
@property (nonatomic, copy) NSString *smsMobile;

@property (nonatomic,copy) NSString *slogan;//广告语
@property (nonatomic,copy) NSString *legalPersonName;
@property (nonatomic,copy) NSString *userReferee; //推荐人

@property (nonatomic,strong) NSNumber *rate1;//使用抵扣券分成比例
@property (nonatomic,strong) NSNumber *rate2;

@property (nonatomic,copy) NSString *pic; //图片拼接字符串
@property (nonatomic,copy) NSString *descriptionShop;//店铺详述
@property (nonatomic,copy) NSString *owner;//拥有者
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,copy) NSString *refereeMobile; //推荐人手机号码


@property (nonatomic, assign, readonly) BOOL isGongYi;
@property (nonatomic, assign, readonly) BOOL isHasShop;


- (void)changShopInfoWithDict:(NSDictionary *)dict;


- (NSArray <NSString *>*)detailPics;
- (NSString *)getCoverImgUrl;
- (NSString *)getStatusName;

- (void)loginOut;

@property (nonatomic, copy)  NSArray <ZHShopTypeModel *>* shopTypes;

/**
 获取店铺信息，并进行初始化
 */
- (void)getShopInfoSuccess:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure;

/**
 获取店铺类型
 */
- (void)getShopTypeSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;


//销毁单利
+ (void)deleteInstance;

//+ (void)getShopInfoWithToken:(NSString *)token userId:(NSString *)userId  showInfoView:(UIView *)view success:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure;



@end

FOUNDATION_EXTERN  NSString *const kShopInfoChange;

