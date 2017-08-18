//
//  TLUpdateVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/8/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUpdateVC.h"
#import "TLNetworking.h"
#import "ZHGiftHeader.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"
#import "CDHomeVC.h"
#import "ZHNavigationController.h"
#import "ZHFalseHomeVC.h"
#import "ZHUser.h"
#import "ZHUserLoginVC.h"


@interface TLUpdateVC ()

@end

@implementation TLUpdateVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self updateApp];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgIV];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    bgIV.image = [UIImage imageNamed:@"lanchImg"];
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground {

    [self updateApp];

}




- (void)updateApp {
    
    [TLProgressHUD showWithStatus:nil];
    //获取版本
    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID] parameters:nil success:^(NSString *msg, id data) {
        
        [TLProgressHUD dismiss];
        [self removePlaceholderView];
        
        
        //线上版本
        NSString *versionStr = data[@"results"][0][@"version"];
        
        //本地版本号和线上不同
        //线上版本号 和 内置的老版本号不同
        //满足以上两点， 是正常用户更新
          NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        (![versionStr isEqualToString:currentBundleVersion] && [versionStr isEqualToString:OLD_VERSION] ) 
        if ( [versionStr isEqualToString:OLD_VERSION] ) {
            
            //在审核
            [AppConfig config].homeVCClass = [ZHFalseHomeVC class];
            [self setRootVC];
            
            return ;
        }
        
        ////////////////////////////////
        //审核通过
        [AppConfig config].homeVCClass = [CDHomeVC class];

        TLNetworking *http = [TLNetworking new];
        http.code = @"807718";
        http.showView = self.view;
        http.parameters[@"type"] = @"ios_g";
        [http postWithSuccess:^(id responseObject) {
            
            [self removePlaceholderView];
            NSString *version = responseObject[@"data"][@"version"];
            NSString *downloadUrl = responseObject[@"data"][@"downloadUrl"];
            NSString *note = responseObject[@"data"][@"note"];
            NSString *forceUpdate = responseObject[@"data"][@"forceUpdate"];
            NSString *checking = responseObject[@"data"][@"checked"]; // 在审核
            
            if ([checking isEqualToString:@"1"]) {
                //审核中
                [self setRootVC];
                return ;
            }
            
            NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([version isEqualToString:currentBundleVersion]) {
                [self setRootVC];
                return;
            }
            
            //1.在审核,忽略更新
            //2.不是审核阶段，比较本地版本号 是否 与服务器版本号相同，不同进行更新。相同跳过
            NSString *title = @"应用更新";
            NSString *msg = [NSString stringWithFormat:@"最新版本为：%@\n%@",version,note];
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                               message:msg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            
            //
            if ([forceUpdate isEqual:@"1"]) {
                
                //强制更新
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *urlStr = downloadUrl;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    
                }];
                [alertCtrl addAction:updateAction];
                
                
            } else {
                
                //
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *urlStr = downloadUrl;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    [self setRootVC];
                    
                }];
                
                //
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self setRootVC];
                }];
                
                [alertCtrl addAction:cancleAction];
                [alertCtrl addAction:updateAction];
                
            }
            
            //
            [self presentViewController:alertCtrl animated:YES completion:nil];
            //        data =  {
            //            downloadUrl = 1;
            //            forceUpdate = 1;
            //            note = "\U672c\U6b21\U4fee\U6539\U5185\U5bb9";
            //            version = "1.0.0";
            //            };
        } failure:^(NSError *error) {
            
            [self addPlaceholderView];
            
        }];

        
        
            
        
    } abnormality:nil failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];
    
    
    
  

}



- (void)tl_placeholderOperation {

    [self updateApp];

}


- (void)setRootVC {
    
    if([[ZHUser user] isLogin]){
        
        //开发更换根控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[[AppConfig config].homeVCClass alloc] init]];
        
    } else {
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
