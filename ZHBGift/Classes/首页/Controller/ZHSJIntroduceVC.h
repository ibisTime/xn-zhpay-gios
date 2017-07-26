//
//  ZHSJIntroduceVC.h
//  ZHBGift
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, IntroduceInfo) {
    
    IntroduceInfoNew = 0,
    IntroduceInfoSignAContractInfo, //签约信息
    
};

@interface ZHSJIntroduceVC : TLBaseVC

@property (nonatomic, assign) IntroduceInfo type;


@end
