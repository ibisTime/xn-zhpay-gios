//
//  AppConfig.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppConfig.h"



@implementation AppConfig

+ (instancetype)config {

    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });

    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {

    _runEnv = runEnv;
    switch (_runEnv) {
        case RunEnvRelease: {
        
           self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
           self.addr = @"http://139.224.200.54:5601"; //test
           self.shareBaseUrl = @"http://m.zhenghuijituan.com";

        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
            
            self.addr = @"http://106.15.49.68:5601";
            
//            self.addr = @"http://106.15.49.68:5601";
//            self.shareBaseUrl = @"http://118.178.124.16:5603";
            
        } break;
            
        case RunEnvDev: {

            
            self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
            self.addr = @"http://106.15.49.68:5501";
            self.shareBaseUrl = @"http://osszhqb.hichengdai.com/share";

        }break;
            
    

    }
    
}


- (NSString *)realNameAuthBackUrl {

     return  @"zhlps://certi.back";

}

- (NSString *)pushKey {

    return @"01ff3e500410e11b9edd4fbd";
    
}


- (NSString *)terminalType {

   return @"B";

}
- (NSString *)userKind {

    return @"f3";
    
}







@end
