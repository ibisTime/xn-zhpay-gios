//
//  AppDelegate.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.

#import "AppDelegate.h"
#import "ZHNavigationController.h"
#import "ZHUserLoginVC.h"
#import <CoreLocation/CoreLocation.h>
#import "IQKeyboardManager.h"
#import "ZHUserRegistVC.h"
#import "ZHUserForgetPwdVC.h"
#import "AppConfig.h"
#import "CDHomeVC.h"
#import "UIHeader.h"
#import "UserHeader.h"
#import "TLNetworking.h"
#import "AppCopyConfig.h"
#import "CDShopMgtVC.h"
#import "CDGoodsParameterModel.h"
#import <AVFoundation/AVFoundation.h>
#import "CDVoicePlayer.h"
#import "ZHFalseHomeVC.h"
#import "TLUpdateVC.h"
#import "RespHandler.h"
#import <NBHTTP/NBNetwork.h>


@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) RespHandler *respHandler;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   
    //全局设置UI
    [self uiInit];
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
    
    [AppCopyConfig config].runEnv = [AppConfig config].runEnv;
    
    [AppCopyConfig config].addr = [AppConfig config].addr;
    [AppCopyConfig config].qiniuDomain = [AppConfig config].qiniuDomain;
    [AppCopyConfig config].shareBaseUrl = [AppConfig config].shareBaseUrl;
    [AppCopyConfig config].userKind = [AppConfig config].userKind;
    [AppCopyConfig config].terminalType = [AppConfig config].terminalType;
    [AppCopyConfig config].pushKey = [AppConfig config].pushKey;
    [AppCopyConfig config].qiNiuKey = [AppConfig config].qiNiuKey;
    [AppCopyConfig config].realNameAuthBackUrl = [AppConfig config].realNameAuthBackUrl;
    
    //
    //新式Networking
    self.respHandler = [[RespHandler alloc] init];
    [NBNetworkConfig config].respDelegate = self.respHandler;
    [NBNetworkConfig config].baseUrl = [NSString stringWithFormat:@"%@%@",[AppConfig config].addr,@"/forward-service/api"];
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    //键盘处理
    [self keyboardHandle];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TLUpdateVC alloc] init];


    //登入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //用户登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    
//  [self pushInitWithOption:launchOptions];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    return YES;
    
}

#pragma mark- 极光推送初始化
- (void)pushInitWithOption:(NSDictionary *)launchOptions {

    //push
//    [self jpushInitWithLaunchOption:launchOptions];

    
}

- (void)uiInit {

//
    [UINavigationBar appearance].barTintColor = [UIColor shopThemeColor];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                           }];
}

- (void)keyboardHandle {

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //    [manager.disabledToolbarClasses addObject:[ChatViewController class]];
    [manager.disabledToolbarClasses addObject:[ZHUserLoginVC class]];
    [manager.disabledToolbarClasses addObject:[ZHUserRegistVC class]];
    [manager.disabledToolbarClasses addObject:[ZHUserForgetPwdVC class]];

}

- (void)userLogin {
    
    
//     self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHHomeVC alloc] init]];
    //开发更换根控制器
    self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[[AppConfig config].homeVCClass alloc] init]];
    
}

- (void)userLoginOut {



    [[ZHUser user] loginOut];
    
    //退出
    [[ZHShop shop] loginOut];
    //销毁

    self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

}




- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    if ([url.host isEqualToString:@"certi.back"]) {
        
        NSString *str =  [url query];
        NSArray <NSString *>*arr =  [str componentsSeparatedByString:@"&"];
        
        __block NSString *bizNoStr;
        __block NSDictionary *dict;
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj hasPrefix:@"biz_content="]) {
                
                bizNoStr = [obj substringWithRange:NSMakeRange(12, obj.length - 12)];
                
                dict = [NSJSONSerialization JSONObjectWithData:[bizNoStr.stringByRemovingPercentEncoding dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
            }
            
        }];
        
        
        //--//
        if (!dict[@"failed_reason"]) {
            
            //通知我们的服务器认证成功
            TLNetworking *http = [TLNetworking new];
            http.showView = [UIApplication sharedApplication].keyWindow;
            http.code = @"805192";
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"bizNo"] = [ZHUser user].tempBizNo;
            [http postWithSuccess:^(id responseObject) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"realNameSuccess" object:nil];
                
            } failure:^(NSError *error) {
                
                
            }];
            
        } else {
            
            //            if (dict[@"failed_reason"]) {
            //
            //                [TLAlert alertWithHUDText:dict[@"failed_reason"]];
            //
            //            }
            
        }
        
        
        return YES;
    }
    
    return NO;

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([AppConfig config].runEnv == RunEnvDev) {
        
        //
//        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"收钱了"];
//        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//        [synth speakUtterance:utterance];
        
        
    }
 
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    

  
}






@end
