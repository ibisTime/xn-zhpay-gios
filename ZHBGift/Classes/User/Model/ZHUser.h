 //
//  ZHUser.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "ZHUserExt.h"

@class ZHUserExt;

@interface ZHUser : TLBaseModel

+ (instancetype)user;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *token;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic,strong) NSString *status;


@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *totalFansNum;
@property (nonatomic, copy) NSString *totalFollowNum;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, strong) ZHUserExt *userExt;
@property (nonatomic,copy) NSString *tradepwdFlag;

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, copy) NSString *tempBizNo;


//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;

- (void)loginOut;

- (void)updateUserInfo;
//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;

- (void)setUserInfoWithDict:(NSDictionary *)dict;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;

