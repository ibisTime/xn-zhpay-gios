//
//  TLCollectMoneyHintVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/3/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCollectMoneyHintVC.h"
#import "ZHBillVC.h"
//@import AVFoundation;
#import "NSTimer+tlNoCycle.h"
#import "ZHCurrencyModel.h"
#import <AVFoundation/AVFoundation.h>
#import "CDVoicePlayer.h"
#import "CDConsumptionModel.h"


@interface TLCollectMoneyHintVC ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, copy) NSString *speakStr;
@property (nonatomic, copy) NSString *mobileStr;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isHttpFailed;

@end

@implementation TLCollectMoneyHintVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实时到账";
    self.isFirst = YES;
    self.isHttpFailed = NO;
 
    
    //
    [self tl_placeholderOperation];
    
    
    //开启定时器
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer tl_scheduledTimerWithTimeInterval:20 repeats:YES block:^(NSTimer *timer) {
        
        [weakSelf getInfoIsFirst:weakSelf.isFirst];
        
    }];
    
}

//--//
- (void)tl_placeholderOperation {

    if (self.isHttpFailed) {
        
        [self getInfoIsFirst:self.isFirst];

        
    } else {
    
        [self getInfoIsFirst:self.isFirst];

    }

}


- (void)getInfoIsFirst:(BOOL)isFirst {

    TLNetworking *http = [TLNetworking new];
    http.code = @"808248";
    if (isFirst) {
        
        http.showView = self.view;
        http.isShowMsg = YES;
        
    } else {
    
        http.isShowMsg = NO;

    }
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"1";
    http.parameters[@"storeCode"] = [ZHShop shop].code;
    
    //
    [http postWithSuccess:^(id responseObject) {
        
        self.isFirst = NO;
        [self setPlaceholderViewTitle:@"暂无收款信息" operationTitle:@"重新获取"];
        NSArray *arr =  responseObject[@"data"][@"list"];
        if (arr.count > 0) {
            
            //
            [self removePlaceholderView];
            
            //
            [self setUpUI];
            
            //
            CDConsumptionModel *model = [CDConsumptionModel tl_objectWithDictionary:arr[0]];
            
            if ([[CDVoicePlayer player] needPlayMsgWithCode:model.code]) {
                
                [CDVoicePlayer player].speechSynthesizer.delegate = self;
                [[CDVoicePlayer player] playMsg:[model playMsg]];
            }
            
            //
            self.nameLbl.text = model.userMobile;
            self.moneyLbl.text = [model.storeAmount convertToRealMoney];
            self.timeLbl.text = [model.payDatetime convertToDetailDate];
            
            
        } else {
            
            [self addPlaceholderView];
            
        }
        
    } failure:^(NSError *error) {
        
        [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
        [self addPlaceholderView];
        
    }];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[CDVoicePlayer player].speechSynthesizer continueSpeaking];
    [CDVoicePlayer player].speechSynthesizer.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [CDVoicePlayer player].speechSynthesizer.delegate = nil;

}

- (void)dealloc {
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;

    
    [CDVoicePlayer player].speechSynthesizer.delegate = nil;
    [[CDVoicePlayer player].speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}

#pragma mark- delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {

    //暂停定时器
    self.timer.fireDate = [NSDate distantFuture];
    
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {

    self.timer.fireDate = [NSDate distantPast];

}




- (void)setUpUI {

    if (self.moneyLbl) {
        return;
    }
    
    UIScrollView *bgScrolView = [[UIScrollView alloc] init];
    [self.view addSubview:bgScrolView];
    bgScrolView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    bgScrolView.backgroundColor = [UIColor whiteColor];
    [bgScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //
    UIView *containerView = [[UIView alloc] init];
    [bgScrolView addSubview:containerView];
    
    //
    UILabel *sdHintLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(15)
                                       textColor:[UIColor zh_textColor]];
    [containerView addSubview:sdHintLbl];
    sdHintLbl.text = @"收到";
    
    
    
    //支付人员姓名
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(32)
                                     textColor:[UIColor zh_textColor]];
    [containerView addSubview:nameLbl];
    self.nameLbl = nameLbl;
    
    //
    UILabel *sdHintLbl2 = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(18)
                                        textColor:[UIColor zh_textColor]];
    [containerView addSubview:sdHintLbl2];
    sdHintLbl2.text = @"支付的";
    
    //金额
    UILabel *moneyLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(32)
                                      textColor:[UIColor zh_themeColor]];
    [containerView addSubview:moneyLbl];
    self.moneyLbl = moneyLbl;
    
    
    //timeLbl
    UILabel *timeLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor zh_textColor2]];
    [containerView addSubview:timeLbl];
    self.timeLbl = timeLbl;
    
    
    //按钮
//    UIButton *todayBillBtn = [[UIButton alloc] init];
//    [todayBillBtn setTitle:@"今日账单" forState:UIControlStateNormal];
//    [todayBillBtn setBackgroundColor:[UIColor zh_themeColor]];
    

//    
//    [containerView addSubview:todayBillBtn];
//    [todayBillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [todayBillBtn addTarget:self action:@selector(lookBill) forControlEvents:UIControlEventTouchUpInside];
//    todayBillBtn.layer.cornerRadius = 45;
//    todayBillBtn.layer.masksToBounds = YES;
    
    //--约束--//
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.equalTo(bgScrolView.mas_width);
    }];
    
    
    [sdHintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(containerView.mas_top).offset(50);
        
    }];
    
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(sdHintLbl.mas_bottom).offset(35);
        
    }];
    
    
    [sdHintLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(nameLbl.mas_bottom).offset(45);
        
    }];
    //
    
    [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(sdHintLbl2.mas_bottom).offset(36);
        
    }];
    
    //
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView);
        make.top.equalTo(moneyLbl.mas_bottom).offset(20);
        make.bottom.equalTo(containerView.mas_bottom);
        
    }];
    //
//    [todayBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(90);
//        make.width.mas_equalTo(90);
//        make.centerX.equalTo(containerView.mas_centerX);
//        make.top.equalTo(moneyLbl.mas_bottom).offset(70);
//        //        make.left.equalTo(containerView.mas_left);
//        //        make.right.equalTo(containerView.mas_right);
//        ////        make.height.mas_equalTo(50);
//    }];

    
    //
    

}


@end
