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
#import "AppDelegate+JPush.h"
#import "IQKeyboardManager.h"
#import "ZHUserRegistVC.h"
#import "ZHUserForgetPwdVC.h"
#import "UMMobClick/MobClick.h"
#import "AppConfig.h"
#import "CDHomeVC.h"
#import "ZHBillVC.h"
#import "CDShopMgtVC.h"
#import "CDGoodsParameterModel.h"
#import <AVFoundation/AVFoundation.h>
#import "CDVoicePlayer.h"


@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //全局设置UI
    [self uiInit];
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    //键盘处理
    [self keyboardHandle];
    
    //极光推送
    [self jpushInitWithLaunchOption:launchOptions];
    
    //友盟错误统计
    //友盟异常捕获
    UMConfigInstance.appKey = @"586b9d9475ca3501fa000591";
//    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    if([[ZHUser user] isLogin]){
        //开发更换根控制器
        self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[CDHomeVC alloc] init]];
        
    } else {
        
      self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];
    
    }

    //登入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //用户登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    [self pushInitWithOption:launchOptions];


//    [CDVoicePlayer player].canPlay  = YES;
//    if ([AppConfig config].runEnv == RunEnvDev) {
//        
//            NSError *error = NULL;
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setCategory:AVAudioSessionCategoryPlayback error:&error];
//            if(error) {
//                // Do some error handling
//            }
//            [session setActive:YES error:&error];
//            if (error) {
//                // Do some error handling
//            }
//            //让app支持接受远程控制事件
//            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        
//    }


    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    return YES;
    
}

#pragma mark- 极光推送初始化
- (void)pushInitWithOption:(NSDictionary *)launchOptions {

    //push
    [self jpushInitWithLaunchOption:launchOptions];

    
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
    
    //注册推送别名
    [JPUSHService setAlias:[ZHUser user].userId callbackSelector:nil object:nil];
    
//     self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHHomeVC alloc] init]];
    //开发更换根控制器
    self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[CDHomeVC alloc] init]];
}

- (void)userLoginOut {

    //取消推送别名
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];


    [[ZHUser user] loginOut];
    
    //退出
    [[ZHShop shop] loginOut];
    //销毁

    self.window.rootViewController = [[ZHNavigationController alloc] initWithRootViewController:[[ZHUserLoginVC alloc] init]];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

}



#pragma mark- 推送相关
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [self jpushRegisterDeviceToken:deviceToken];
    
    if ([ZHUser user].userId) {
        
        [JPUSHService setAlias:[ZHUser user].userId callbackSelector:nil object:nil];

    }

    
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
 
    
    
    [self jpushDidReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    

  
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [self jpushDidReceiveLocalNotification:notification];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
}

@end
