//
//  CDSendTfView.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDSendTfView.h"

@implementation CDSendTfView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        
        //
        
        self.tf = [[UITextField alloc] init];
        self.tf.textColor = [UIColor textColor];
        [self addSubview:self.tf];
        self.tf.font = FONT(13);
        self.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(3, 5, 3, 5));
            
        }];
    }
    return self;
}

@end
