//
//  ZHShopTypeChooseVC.h
//  ZHBGift
//
//  Created by  tianlei on 2016/12/19.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHShopTypeChooseVC : TLBaseVC

@property (nonatomic,copy) void(^selectedType)(NSString *typeName,NSString *code);

@end
