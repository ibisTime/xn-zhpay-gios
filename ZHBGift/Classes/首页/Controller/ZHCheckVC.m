//
//  ZHCheckVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/8/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHCheckVC.h"
#import "ZHNavigationController.h"
#import "CDHomeVC.h"
#import "ZHUserLoginVC.h"
#import "AppConfig.h"
#import "ZHFalseHomeVC.h"

@interface ZHCheckVC ()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation ZHCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.window = [UIApplication sharedApplication].keyWindow;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
    
}

- (void)tl_placeholderOperation {
    
    
    [TLProgressHUD showWithStatus:nil];
    
    //获取版本
    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID] parameters:nil success:^(NSString *msg, id data) {
        
        [TLProgressHUD dismiss];
        [self removePlaceholderView];
        
        NSNumber *resultCount = data[@"resultCount"];
        
        NSInteger count = [resultCount integerValue];
       
        //
        if (count <= 0) {
            
            [self checking];
            
            //第一次审核
            return ;
        }
        
        [AppConfig config].homeVCClass = [CDHomeVC class];
        //线上版本
        NSString *versionStr = data[@"results"][0][@"version"];
//        NSString *versionStr = @"4.0.0";

        
        
        //本地版本号和线上不同
        //线上版本号 和 内置的老版本号不同
        //满足以上两点， 是正常用户更新
        if (![versionStr isEqualToString:[NSString appCurrentBundleVersion]] && [versionStr isEqualToString:OLD_VERSION] ) {
        
            //在审核
            [self checking];
            
        } else {
     
            //通过
            self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHFalseHomeVC alloc] init]];
            
            if([[ZHUser user] isLogin]){
                //开发更换根控制器
                self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[CDHomeVC alloc] init]];
                
            } else {
                
                self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];
                
            }
            
        }
        
    } abnormality:nil failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];
    
}


- (void)checking {
    
    [AppConfig config].homeVCClass = [ZHFalseHomeVC class];
    
    if([[ZHUser user] isLogin]){
        
        //开发更换根控制器
        self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[[AppConfig config].homeVCClass alloc] init]];
        
    } else {
        
        self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
