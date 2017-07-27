//
//  TLBaseVC.m
//  WeRide
//
//  Created by  tianlei on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLBaseVC.h"


//
#import "CDGoodsMgtVC.h"
#import "CDGoodsMgtVC.h"
#import "CDGoodsParametersAddVC.h"
#import "CDOutOfStockListVC.h"
#import "CDPutawayGoodsListVC.h"
#import "ZHGoodsListVC.h"

@interface TLBaseVC ()

@property (nonatomic, copy) NSArray <NSString *> *setClassArr;

@end

@implementation TLBaseVC {

    UILabel *_placeholderTitleLbl;
    UIButton *_opBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
//    NSLog(@"%@",NSStringFromClass([self class]));
    
    
    //店铺主题色作为全局主提
    if ([self checkSelfClass:@[@"CDGoodsMgtVC",@"CDPutawayGoodsListVC",@"CDOutOfStockListVC",@"CDGoodsAddVC",@"CDGoodsParametersAddVC"]]) {
       //店铺商品管理
        self.navigationController.navigationBar.barTintColor = [UIColor goodsThemeColor];
        
    } else if ([self checkSelfClass:@[@"ZHOrderVC",@"CDOrderCategoryVC",@"CDOrderDetailVC"]]) {
       //订单
      self.navigationController.navigationBar.barTintColor = [UIColor orderThemeColor];
    
    } else if ([self checkSelfClass:@[@"ZHBillVC",@"CDOneBillDetailVC",@"ZHBillTypeChooseVC"]]) {
       //账单
        self.navigationController.navigationBar.barTintColor = [UIColor billThemeColor];
        
    
    } else if ([self checkSelfClass:self.setClassArr]) {
        //账户
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor accountSettingThemeColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName : [UIColor accountSettingThemeColor]
                                                                          }];
        
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
    } else if ([self checkSelfClass:@[@"CDFenHongQuanVC",@"ZHSingleProfitFlowVC"]]) {
        //分红权ui
    
//        self.navigationController.navigationBar.shadowImage = [[UIColor blackColor] convertToImage];
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor shopThemeColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName : [UIColor shopThemeColor]
                                                                          }];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
    
    
    }
    
}

- (NSArray<NSString *> *)setClassArr {

    if (!_setClassArr) {
        
        _setClassArr = @[@"ZHAccountAboutVC",@"ZHChangeMobileVC",@"ZHPwdRelatedVC",@"ZHAboutUsVC",@"ZHBankCardListVC",@"ZHRealNameAuthVC",@"ZHBankCardAddVC"];

    }
    
    return _setClassArr;

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if ([self checkSelfClass:@[@"CDFenHongQuanVC",@"ZHSingleProfitFlowVC"]] || [self checkSelfClass:self.setClassArr]) {
    
        return UIStatusBarStyleDefault;

    }
    
    return UIStatusBarStyleLightContent;
    
}

- (BOOL)checkSelfClass:(NSArray<NSString *>*)classArr {

   __block BOOL is = NO;
    [classArr enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:NSClassFromString(obj)]) {
            *stop = YES;
            is = YES;
        }
    }];
    
    return is;

}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    
//    UIImage *btnImg = [[UIImage imageNamed:@"back_default"] changImageColor:[UIColor whiteColor] blendModel:kCGBlendModeDestinationIn];
    
    UIImage *btnImg = [UIImage imageNamed:@"back_default"];
    
    if ([self checkSelfClass:@[@"CDFenHongQuanVC",@"ZHSingleProfitFlowVC"]]) {
    
        btnImg = [UIImage imageNamed:@"back_goods"];
        
    } else if ([self checkSelfClass:self.setClassArr]) {
    
        btnImg = [UIImage imageNamed:@"back_set"];

    }
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btn setImage: btnImg forState:UIControlStateNormal];
    
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}




- (void)removePlaceholderView {

    if (self.tl_placeholderView) {
        
        [self.tl_placeholderView removeFromSuperview];

    }
    
}

- (void)addPlaceholderView{

    if (self.tl_placeholderView) {
        
        [self.view addSubview:self.tl_placeholderView];
        
    }

}

- (UIView *)tl_placeholderView {

    if (!_tl_placeholderView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        _placeholderTitleLbl = lbl;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        _opBtn = btn;
        _tl_placeholderView = view;
        
    }
    return _tl_placeholderView;
}

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)opTitle {

    if (self.tl_placeholderView) {
        
        _placeholderTitleLbl.text = title;
        [_opBtn setTitle:opTitle forState:UIControlStateNormal];
        
    } else {
    
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(18) textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        lbl.text = title;
        _placeholderTitleLbl = lbl;
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        _opBtn = btn;
        _tl_placeholderView = view;
    
    }

}






#pragma mark- 站位操作
- (void)tl_placeholderOperation {

    if ([self isMemberOfClass:NSClassFromString(@"TLBaseVC")]) {
        
        NSLog(@"子类请重写该方法");
        
    }

}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告---%@",NSStringFromClass([self class]));
    
}

@end
