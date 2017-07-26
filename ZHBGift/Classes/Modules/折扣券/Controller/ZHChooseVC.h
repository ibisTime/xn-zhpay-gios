//
//  ZHChooseVC.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHChooseVC : TLBaseVC

@property (nonatomic,copy) void(^selectedType)(NSString *typeName,NSInteger type);

@end
