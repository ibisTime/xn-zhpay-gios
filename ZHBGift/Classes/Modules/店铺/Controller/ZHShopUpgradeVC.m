//
//  ZHShopUpgradeVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/4/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopUpgradeVC.h"
#import <WebKit/WebKit.h>
@interface ZHShopUpgradeVC ()

@end

@implementation ZHShopUpgradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺升级";
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 80)];
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor whiteColor];
    
    //
    UIButton *upgradeBtn = [UIButton zhBtnWithFrame:CGRectMake(20, webView.yy + 20, SCREEN_WIDTH - 40, 45) title:@"确认升级"];
    [self.view addSubview:upgradeBtn];
    [upgradeBtn addTarget:self action:@selector(upgrade) forControlEvents:UIControlEventTouchUpInside];
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    http.parameters[@"ckey"] = @"store_up_statement";
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSString *styleStr = @"<style type=\"text/css\"> *{ font-size:30px;}</style>";
        NSString *htmlStr = responseObject[@"data"][@"note"];
        [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",htmlStr,styleStr] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)upgrade {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808207";
    
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"code"] = [ZHShop shop].code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"升级成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        //
        if (self.upgradeSuccess) {
            self.upgradeSuccess();
        }
        
    } failure:^(NSError *error) {
        
        
    }];


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
