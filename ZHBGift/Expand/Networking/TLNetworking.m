//
//  TLNetworking.m
//  WeRide
//
//  Created by  tianlei on 2016/11/28.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLNetworking.h"
#import "AppConfig.h"
#import "TLError.h"

//121.43.101.148:5703/cd-qlqq-front
@implementation TLNetworking


+ (AFHTTPSessionManager *)HTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 60.0;
    NSSet *set = manager.responseSerializer.acceptableContentTypes;
    
    set = [set setByAddingObject:@"text/plain"];
    set = [set setByAddingObject:@"text/html"];
    set = [set setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
   manager.responseSerializer.acceptableContentTypes = [set setByAddingObject:@"text/plain"];
    
    return manager;
}

+ (NSString *)serveUrl {
    
    return [[AppConfig config].addr stringByAppendingString:@"/forward-service/api"];
    
}

+ (NSString *)systemCode {
    
    return @"CD-CZH000001";
    
}


+ (NSString *)kindType {
    
    return @"f3";
    
}

- (instancetype)init{

    if(self = [super init]){
    
       _manager = [[self class] HTTPSessionManager];
        _isShowMsg = YES;
        self.isAutoDeliverCompanyCode = YES;
        self.parameters = [NSMutableDictionary dictionary];
        
    }
    return self;

}


- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //如果想要设置其它 请求头信息 直接设置 HTTPSessionManager 的 requestSerializer 就可以了，不用直接设置 NSURLRequest
    
    if(self.showView){
    
        [TLProgressHUD showWithStatus:nil];
    }
    
    if(self.code && self.code.length > 0){
    
        if (!(self.url && self.url.length > 0)) {
            
            self.url = [[self class] serveUrl];
        }
        
        self.parameters[@"systemCode"] = [[self class] systemCode];
        
        if (self.isAutoDeliverCompanyCode) {
            
            self.parameters[@"companyCode"] = [[self class] systemCode];

        }

        
        if (!self.kind || self.kind.length <= 0 ) {
            
            self.parameters[@"kind"] = [[self class] kindType];

        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
        self.parameters = [NSMutableDictionary dictionaryWithCapacity:2];
        self.parameters[@"code"] = self.code;
        self.parameters[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    if (!self.url || !self.url.length) {
        NSLog(@"url 不存在啊");
        if (self.showView) {
            
            [TLProgressHUD dismiss];
        }
        return nil;
    }
    
  return [self.manager POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
//      NSLog(@"%@",responseObject);
      if(self.showView){
          
          [TLProgressHUD dismiss];
      }
      
    
      
      if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
          
          if(success){
              success(responseObject);
          }
          
      } else { //异常也是失败
          
          if(failure){

              failure(nil);
          }
          
          //
          if ([responseObject[@"errorCode"] isEqual:@"4"]) {
              //token错误  4
              
              [TLAlert alertWithTitile:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
                  [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
              }];
              return;
          }
          
          if (self.isShowMsg) {
             
              //
              [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
              
          }
      
      }
    
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if(self.showView){
           [TLProgressHUD dismiss];
       }
       
       if(failure){
           failure(error);
       }
       
       if (self.isShowMsg) {
           
           [TLAlert alertWithInfo:@"网络异常"];
           
       }
       
   }];

}

- (void)hundleSuccess:(id)responseObj {

    if([responseObj[@"success"] isEqual:@1]){
    
        
    }
}



+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id responseObject))success
                      abnormality:(void (^)(NSString *msg))abnormality
                          failure:(void (^)(NSError * _Nullable  error))failure;
{
    //先检查网络
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            failure(error);
        }
        
    }];
    
}


//#pragma mark - GET
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSString *msg,id data))success
                     abnormality:(void (^)())abnormality
                         failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    return [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(nil,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


@end
