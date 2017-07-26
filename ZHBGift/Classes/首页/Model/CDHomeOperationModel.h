//
//  CDHomeOperationModel.h
//  ZHBGift
//
//  Created by  tianlei on 2017/5/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDHomeOperationModel : NSObject

@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, copy) NSString *operationName;

@property (nonatomic, copy) NSString *leftText;
@property (nonatomic, copy) NSString *middleText;
@property (nonatomic, copy) NSString *rightText;

@property (nonatomic, copy) void(^mainAction)();

@property (nonatomic, copy) void(^leftAction)();
@property (nonatomic, copy) void(^middleAction)();
@property (nonatomic, copy) void(^rightAction)();

@property (nonatomic, copy) NSArray<NSNumber *> *bottomActionEnables;

@end

