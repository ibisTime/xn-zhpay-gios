//
//  TLNetworking.h
//  WeRide
//
//  Created by  tianlei on 2016/11/28.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface TLNetworking : NSObject

@property (nonatomic,strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic,strong)  NSMutableDictionary *parameters;

@property (nonatomic,copy) NSString *code; //接口编号
@property (nonatomic,strong) UIView *showView; //hud展示superView
@property (nonatomic,assign) BOOL isShowMsg; //是否展示警告信息

@property (nonatomic,assign) BOOL isAutoDeliverCompanyCode; //是否自动传入companyCode

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *kind;



- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:( void (^)(id responseObject))success
                   abnormality:(void (^)(NSString *msg))abnormality
                       failure: (void (^)(NSError *error))failure;


+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSString *msg,id data))success
                  abnormality:(void (^)())abnormality
                      failure:(void (^)(NSError *error))failure;

@end
