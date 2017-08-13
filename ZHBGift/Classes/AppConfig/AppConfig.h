//
//  AppConfig.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RunEnv) {
    RunEnvRelease = 0,
    RunEnvDev = 1,
    RunEnvTest = 2
};


@interface AppConfig : NSObject


+ (instancetype)config;

@property (nonatomic,assign) RunEnv runEnv;

//环信
//@property (nonatomic, copy) NSString *chatKey;
//@property (nonatomic,copy) NSString *aliPayKey;


//url请求地址
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, copy) NSString *qiniuDomain;
@property (nonatomic,strong) NSString *shareBaseUrl;

@property (nonatomic,copy, readonly) NSString *userKind; //
@property (nonatomic,copy, readonly) NSString *terminalType; //


@property (nonatomic, copy, readonly) NSString *pushKey;
@property (nonatomic, copy, readonly) NSString *qiNiuKey;

@property (nonatomic, strong) NSString *realNameAuthBackUrl;

@property  Class homeVCClass;



@end
