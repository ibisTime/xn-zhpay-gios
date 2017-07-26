//
//  ZHCategoryManager.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCategoryManager.h"

#define ZH_SHOP_CATEGORY_KEY @"ZH_SHOP_CATEGORY_KEY"

@implementation ZHCategoryManager

+ (instancetype)manager {
    static ZHCategoryManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHCategoryManager alloc] init];
    });
    
    return manager;

}


- (void)getCategorySuccess:(void(^)())success failure:(void(^)())failure {
    
    //无数据 获取并存储
    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *categorys = responseObject[@"data"];
        
        //
        self.categorys = [ZHCategoryModel tl_objectArrayWithDictionaryArray:categorys];
        
        //初始化
        self.categoryDict = [NSMutableDictionary dictionary];
        self.bigCategorys = [NSMutableArray array];
        
        [self.categorys enumerateObjectsUsingBlock:^(ZHCategoryModel   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj.parentCode isEqualToString:@"0"] ) {
                
                self.categoryDict[obj.code] = [NSMutableArray array];
                [self.bigCategorys addObject:obj];
                
            }
        }];
        
        //分小类,根据大类code
        NSArray <NSString *> *keys = self.categoryDict.allKeys;
        [self.categorys enumerateObjectsUsingBlock:^(ZHCategoryModel   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            for (NSInteger i = 0; i < keys.count; i ++) {
                
                if ([obj.parentCode isEqualToString:keys[i]]) {
                    
                    [self.categoryDict[obj.parentCode] addObject:obj];
                    continue;
                }
                
            }
            
        }];
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];


}


- (NSString *)getNameByCategoryCode:(NSString *)code {

    if (!self.categorys || self.categorys.count <= 0) {
        return code;
    }
    
    __block NSString *name = code;
    [self.categorys enumerateObjectsUsingBlock:^(ZHCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.code isEqualToString:code]) {
            name = obj.name;
            *stop = YES;
        }
        
    }];
    
    return name;

}


@end
