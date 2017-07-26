//
//  ZHUser.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUser.h"
#import "ZHUserExt.h"

#define USER_ID_KEY @"user_id_key_zh"
#define TOKEN_ID_KEY @"token_id_key_zh"
#define USER_INFO_DICT_KEY @"user_info_dict_key_zh"

NSString *const kUserLoginNotification = @"kUserLoginNotification_zh";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification_zh";
NSString *const kUserInfoChange = @"kUserInfoChange_zh";

@implementation ZHUser

+ (instancetype)user {

    static ZHUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[ZHUser alloc] init];
    });
    
    return user;

}

- (void)setUserId:(NSString *)userId {

    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setToken:(NSString *)token {

    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
        
        self.userId = userId;
        self.token = token;
        [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];
        
        return YES;
    } else {
    
    
        return NO;
    }

    
    
    
}

- (void)loginOut {

    self.userId = nil;
    self.token = nil;
    self.mobile = nil;
    self.userExt = nil;
    self.tradepwdFlag = nil;
    self.realName = nil;
    self.idNo = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_out_notification" object:nil];

}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)updateUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

- (ZHUserExt *)userExt {

    if (!_userExt) {
        _userExt = [[ZHUserExt alloc] init];
        
    }
    return _userExt;

}
- (void)setUserInfoWithDict:(NSDictionary *)dict {

    self.mobile = dict[@"mobile"];
    self.tradepwdFlag = dict[@"tradepwdFlag"];
    self.realName = dict[@"realName"];
    self.idNo = dict[@"idNo"];

    
    NSDictionary *userExt = dict[@"userExt"];
    if (userExt) {
        if (userExt[@"photo"]) {
            self.userExt.photo = userExt[@"photo"];
        }
    }
    
    if (dict[@"userExt"][@"test"]) {
        
    }
    
}


@end
