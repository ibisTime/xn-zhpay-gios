//
//  CDAccountApi.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDAccountApi.h"

@interface CDAccountApi ()

@end

@implementation CDAccountApi

+ (void)getFRBWSuccess:(void(^)(ZHCurrencyModel *FRBCurrency,ZHCurrencyModel *GiftBCurrency))success failure:(void(^)(NSError *err))failure {

    //查询账户信息
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.isShowMsg = YES;
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"userId"] = [ZHUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        NSMutableArray <ZHCurrencyModel *>*arr = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
      __block  ZHCurrencyModel * FRBCurrencyTemp ;
      __block  ZHCurrencyModel * GiftBCurrencyTemp ;

        
        [arr enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kFRB]) {
                
                FRBCurrencyTemp = obj;
          
            } else if ([obj.currency isEqualToString:kGiftB]) {
            
                GiftBCurrencyTemp = obj;
                
                
            }
            
        }];
        
        
        if (FRBCurrencyTemp && GiftBCurrencyTemp) {
            success(FRBCurrencyTemp,GiftBCurrencyTemp);
        } else {
        
            failure(nil);
        
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
