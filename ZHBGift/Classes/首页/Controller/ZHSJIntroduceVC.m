//
//  ZHSJIntroduceVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/4/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHSJIntroduceVC.h"
#import <WebKit/WebKit.h>

@interface ZHSJIntroduceVC ()

@end

@implementation ZHSJIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    
    
    NSString *ckey = nil;
    
    switch (self.type) {
        case IntroduceInfoNew:
        
        ckey =  @"new_start";
        self.title = @"新手入门";

        break;
        
        case IntroduceInfoSignAContractInfo:
        
        ckey =  @"store_sign_statement";
        self.title = @"签约信息";
        break;
        
    }
    //
    
    //
    http.parameters[@"ckey"] = ckey;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSString *styleStr = @"<style type=\"text/css\"> *{ font-size:35px;}</style>";
        NSString *htmlStr = responseObject[@"data"][@"note"];
        [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",htmlStr,styleStr] baseURL:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    //
    
}



@end
