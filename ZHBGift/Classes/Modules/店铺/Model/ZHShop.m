//
//  ZHShop.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/19.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShop.h"

#define ZH_SHOP_INFO_KEY @"ZH_SHOP_INFO_KEY"

static ZHShop *shop;

NSString *const kShopInfoChange = @"zh_shop_info_change";

@interface ZHShop()

@end

@implementation ZHShop
{

    NSString *_test;
}


+ (instancetype)shop {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shop = [[ZHShop alloc] init];
        shop.haveShopInfo = NO;
//        shop.isReg = NO;
    });
    
    return shop;

}

- (BOOL)isHasShop {


    return [ZHShop shop].code &&  [ZHShop shop].code.length;
}

- (BOOL)isGongYi {

   return [self.level isEqualToString:@"2"];
    
}




- (BOOL)getInfo {

  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:ZH_SHOP_INFO_KEY];
    
    if (dict) {
        
        [self changShopInfoWithDict:dict];
        return YES;
        
    } else {
        
        return NO;
    }
}

- (void)changShopInfoWithDict:(NSDictionary *)dict {

    self.haveShopInfo = YES;
    
    //
    [self setValuesForKeysWithDictionary:dict];
    //存储信息
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ZH_SHOP_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.descriptionShop = value;
    }

}



- (NSString *)getCoverImgUrl {

    return [self.advPic convertImageUrl];

}


- (NSArray<NSString *> *)detailPics {

    return [self.pic componentsSeparatedByString:@"||"];
}

- (NSString *)getStatusName {

//    TOCHECK("0", "待审核"),
//    UNPASS("91", "审核不通过"),
//    PASS("1", "审核通过待上架"),
//    ON_OPEN( "2", "已上架，开店"),
//    ON_CLOSE("3", "已上架，关店"),
//    OFF("4", "已下架");
    
  NSDictionary *dict =  @{
      @"0" : @"待审核",
      @"91" : @"审核不通过",
      @"2" : @"店铺营业中",
      @"3" : @"关店",

      @"1" : @"待上架",
      @"4" : @"平台下架"

      };

    return dict[self.status];
}


- (void)setStatus:(NSString *)status {

    _status = [status copy];

}



- (void)loginOut {

    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([ZHShop class], &count);
    // 遍历
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        objc_property_t property = properties[i];
        // 获取属性的名称
        const char *cName = property_getName(property);
        
//        NSLog(@"%c---%c",cName,property_getAttributes(property));
        
        // 转换为Objective
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        //基础数据类型，不能置为nil
        if ([name isEqualToString:@"isReg"] || [name isEqualToString:@"haveShopInfo"]) {
            
            continue;
        }
        
        [[ZHShop shop] setValue:nil forKeyPath:name];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ZH_SHOP_INFO_KEY];

//    self.isReg = NO;
    self.haveShopInfo = NO;

//    self.code = nil;
//    self.name = nil;
//    self.advPic = nil;
//    self.province = nil;
//    self.city = nil;
//    self.status = nil;
//    self.area = nil;
//    self.address = nil;
//    self.contractNo = nil;
//    //
//    self.level = nil;
//    self.contractNo = nil;
//    self.code = nil;
//    self.advPic = nil; //封面图
//    self.type = nil; //地址
//    self.name = nil;
//    self.province = nil;
//    self.city = nil;
//    self.area = nil;
//    self.address = nil;//详细地址
//    
//    self.longitude = nil;
//    self.latitude = nil;
//    
//    self.bookMobile = nil; //电话
//    self.smsMobile = nil;
//    
//    self.slogan = nil;//广告语
//    self.legalPersonName = nil;
//    self.userReferee = nil; //推荐人
//    self.rate1 = nil;//使用抵扣券分成比例
//    self.rate2 = nil;
//    
//    self.pic = nil; //图片拼接字符串
//    self.descriptionShop = nil;//店铺详述
//    self.owner = nil;//拥有者
//    self.status = nil;
//    self.remark = nil;
//    self.refereeMobile = nil; //推荐人手机号码
    
    //--//

}

- (void)getShopTypeSuccess:(void(^)())success failure:(void(^)(NSError *error))failure {


    //现货区店铺类型
    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"2";
    
    [http postWithSuccess:^(id responseObject) {
        
        
        [ZHShop shop].shopTypes = [ZHShopTypeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];


}


- (void)getShopInfoSuccess:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808219";
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
//    http.isShowMsg = NO;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[0][@"store"]];
        
        if (dict.allKeys.count > 0) {
//            dict[@"totalIncome"] = array[0][@"totalIncome"];
            
            //
            [[ZHShop shop] changShopInfoWithDict:dict];

            if (success) {
                success(dict);
            }
            
        } else {
            
            if (success) {
                success(nil);
            }
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];


}


+ (void)getShopInfoWithToken:(NSString *)token userId:(NSString *)userId showInfoView:(UIView *)view success:(void(^)(NSDictionary *shopDict))success failure:(void(^)(NSError *error))failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808219";
    http.isShowMsg = YES;
    if (view) {
        
        http.showView = view;
        
    }
    
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *array = responseObject[@"data"];
        if (array.count > 0) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[0][@"store"]];
            dict[@"totalIncome"] = array[0][@"totalIncome"];
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            if (success) {
                success(nil);
            }
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


+ (BOOL )getShopFromLocalDB {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:ZH_SHOP_INFO_KEY];
    
    if (dict) {
        
        [[ZHShop shop] changShopInfoWithDict:dict];
        return YES;
        
    }
    
    return NO;
    
}


@end
