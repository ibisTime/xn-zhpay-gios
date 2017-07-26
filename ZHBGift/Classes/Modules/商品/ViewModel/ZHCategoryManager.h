//
//  ZHCategoryManager.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCategoryModel.h"

@interface ZHCategoryManager : NSObject

+ (instancetype)manager;

//key 为大类 code value 小类数组
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSMutableArray *> *categoryDict;
@property (nonatomic, strong) NSMutableArray <ZHCategoryModel *>*bigCategorys;//大类数组

@property (nonatomic,strong) NSMutableArray <ZHCategoryModel *>*categorys;

- (void)getCategorySuccess:(void(^)())success failure:(void(^)())failure;
- (NSString *)getNameByCategoryCode:(NSString *)code;

@end
