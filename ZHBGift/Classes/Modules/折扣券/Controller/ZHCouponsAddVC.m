//
//  ZHCouponsAddVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCouponsAddVC.h"
#import "ZHGoodsDetailEditView.h"
#import "TLDatePicker.h"
#import "TLUploadManager.h"
#import "ZHShop.h"
#import "IQKeyboardManager.h"
#import "ZHChooseVC.h"

#define LEFT_TITLE_WIDTH 110
@interface ZHCouponsAddVC ()

//名称
@property (nonatomic,strong) TLTextField *nameTf;
//类型
@property (nonatomic,strong) TLTextField *discountFuncTf;

//满减
@property (nonatomic,strong) UIView *discountDetailView;


//开始日期
@property (nonatomic,strong) TLTextField *beginTimeTf;

//结束日期
@property (nonatomic,strong) TLTextField *endTimeTf;

//详情编辑
@property (nonatomic,strong) TLTextView *detailEditView;

@property (nonatomic,strong) TLDatePicker *datePiker;
@property (nonatomic,strong) UILabel *jianFanLbl;

//使用条件
@property (nonatomic,strong) TLTextField *targetMoneyTf;

//使用条件
@property (nonatomic,strong) TLTextField *discountMoneyTf;


//
//@property (nonatomic,copy) NSString *type; // 1 or 2
@property (nonatomic,assign) BOOL isBegin;
@property (nonatomic,assign) BOOL isEnd;
//
//@property (nonatomic,assign) NSInteger isAdding;


@end

@implementation ZHCouponsAddVC
{

    dispatch_group_t _uploadGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是否正在添加
//    _isAdding = NO;

    if(self.coupon) {
    
        self.title = @"抵扣券信息";

    } else {
        
        self.title = @"新增抵扣券";

    }
    
    [self setUpUI];
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:bgScrollView];
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);

    
    self.nameTf = [self tfWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"抵扣券名称" placeholder:@"请输入抵扣券名称"];
    [bgScrollView addSubview:self.nameTf];
    
    //
    [bgScrollView addSubview:self.discountDetailView];
    self.discountDetailView.y = self.nameTf.yy;
    
    //抵扣方式说明
    TLTextField *introduceTf = [self tfWithFrame:CGRectMake(0, self.nameTf.yy, SCREEN_WIDTH, 45) leftTitle:@"折扣方式" placeholder:nil];
    [bgScrollView addSubview:introduceTf];
    introduceTf.text = @"消费满N元,抵扣M元";

    //使用满足金额
    self.targetMoneyTf = [self tfWithFrame:CGRectMake(0, introduceTf.yy + 10, SCREEN_WIDTH, 45) leftTitle:@"使用条件(元)" placeholder:@"请输入最低使用门槛的金额"];
    [bgScrollView addSubview:self.targetMoneyTf];
    self.targetMoneyTf.keyboardType = UIKeyboardTypeNumberPad;

    
    //减免金额
    self.discountMoneyTf = [self tfWithFrame:CGRectMake(0, self.targetMoneyTf.yy, SCREEN_WIDTH, 45) leftTitle:@"满减金额(元)" placeholder:@"请输入满减金额"];
    [bgScrollView addSubview:self.discountMoneyTf];
    self.discountMoneyTf.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //开始
    [bgScrollView addSubview:self.beginTimeTf];
    self.beginTimeTf.y = self.discountMoneyTf.yy + 10;
    
    //结束
    [bgScrollView addSubview:self.endTimeTf];
    self.endTimeTf.y = self.beginTimeTf.yy + 1;
    
    //详情
    UIView *bootomBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.endTimeTf.yy + 10, SCREEN_WIDTH, 40)];
    bootomBGView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bootomBGView];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(15)
                                 textColor:[UIColor shopThemeColor]];
    [bootomBGView addSubview:lbl];
    lbl.text = @"抵扣券使用情况";
    self.detailEditView.frame = CGRectMake(15, lbl.yy, SCREEN_WIDTH - 30, 120);
    [bootomBGView addSubview:self.detailEditView];
    bootomBGView.height = self.detailEditView.yy;
    
    //操作按钮
    UIButton *operationBtn = [UIButton zhBtnWithFrame:CGRectMake(15, bootomBGView.yy  +20, SCREEN_WIDTH - 30, 45) title:@"保存"];
    [bgScrollView addSubview:operationBtn];
    [operationBtn addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchUpInside];
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, operationBtn.yy + 20);
    
    __weak typeof(self) weakSelf = self;
    self.datePiker.confirmAction = ^(NSDate *date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        if (weakSelf.isBegin) {
            
            weakSelf.beginTimeTf.text = [dateFormatter stringFromDate:date];

        } else {
        
            weakSelf.endTimeTf.text = [dateFormatter stringFromDate:date];
        }
        weakSelf.isBegin = NO;
        weakSelf.isEnd = NO;
        
    };
    
    if (!self.coupon) {
    
        return;
    };
    
        if ([self.coupon.status isEqualToString:@"0"]) { //待上架---即可修改又可以上架
            
        
            [operationBtn setTitle:@"上架" forState:UIControlStateNormal];
            
        } else if([self.coupon.status isEqualToString:@"1"]){ //已上架
            
            [operationBtn setTitle:@"下架" forState:UIControlStateNormal];
            
        } else if([self.coupon.status isEqualToString:@"2"]) { //已下架
            
            [operationBtn setTitle:@"上架" forState:UIControlStateNormal];
            
        } else if([self.coupon.status isEqualToString:@"91"]) { //期满作废
            
            [operationBtn setTitle:@"上架" forState:UIControlStateNormal];
            
        }
    
        
        self.nameTf.text = self.coupon.name;
        self.targetMoneyTf.text = [self.coupon.key1 convertToRealMoney];
        self.discountMoneyTf.text = [self.coupon.key2 convertToRealMoney];
                self.beginTimeTf.text = [self.coupon.validateStart convertDate];
        self.endTimeTf.text = [self.coupon.validateEnd convertDate];
        self.detailEditView.text = self.coupon.desc;
    
}



- (void)setUpUI {



}

- (void)operation {

    if (!self.coupon) {
       
        [self save];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808253";
    http.parameters[@"code"] = self.coupon.code;
    http.parameters[@"token"] = [ZHUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        if ([self.coupon.status isEqualToString:@"1"]) {
            
            [TLAlert alertWithHUDText:@"下架成功"];
            
        } else {
        
            [TLAlert alertWithHUDText:@"上架成功"];

        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.addSuccess) {
            self.addSuccess();
        }
        
    } failure:^(NSError *error) {
        
    }];


}

#pragma mark- 删除
- (void)delete {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808251";
    http.parameters[@"code"] = self.coupon.code;
    http.parameters[@"token"] = [ZHUser user].userId;;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"删除抵扣券成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.addSuccess) {
            self.addSuccess();
        }
        
    } failure:^(NSError *error) {
        
    }];


}

#pragma mark- 添加
- (void)save {
    
//    if (self.isAdding) {
//        return;
//    }
    
    if (![self.nameTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请填写抵扣券名称"];
        return;
    }

    //
    if (![self.beginTimeTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请选择起始日期"];
        return;
    }
    
    //
    if (![self.endTimeTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请选择结束日期"];
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
     formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date1 =  [formatter dateFromString:self.beginTimeTf.text];
    NSDate *date2 =  [formatter dateFromString:self.endTimeTf.text];

    //判断结束日期不能大于起始日期
    if ([date1 timeIntervalSince1970] >= [date2 timeIntervalSince1970]) {
        
        [TLAlert alertWithHUDText:@"结束日期必须晚于开始日期"];
        return;
        
    }
    
    
    if (![self.detailEditView.text valid]) {
        [TLAlert alertWithHUDText:@"请输入使用详情"];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.coupon) {//修改
        
        http.code = @"808252";
        http.parameters[@"code"] = self.coupon.code;

    } else {
        
        http.code = @"808250";
        
    }
    http.parameters[@"name"] = self.nameTf.text;
    http.parameters[@"description"] = self.detailEditView.text;
    http.parameters[@"storeCode"] = [ZHShop shop].code;//商家编号
    http.parameters[@"isPutaway"] = @"1";//是否上架
    http.parameters[@"validateStart"] = self.beginTimeTf.text;//起始日期
    http.parameters[@"validateEnd"] = self.endTimeTf.text;//终止日期
    http.parameters[@"type"] = @"1"; //1.满减 2.返现
    http.parameters[@"key1"] = [self convertToSysMoney:self.targetMoneyTf.text];//key1
    http.parameters[@"key2"] = [self convertToSysMoney:self.discountMoneyTf.text];//key2
    http.parameters[@"price"] = [self convertToSysMoney:self.discountMoneyTf.text];//价格
    http.parameters[@"currency"] = @"QBB";//币种
    http.parameters[@"token"] = [ZHUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
//        self.isAdding = YES;
        
        [TLAlert alertWithHUDText:@"添加抵扣券成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.addSuccess) {
            self.addSuccess();
        }
        
    } failure:^(NSError *error) {
        
//        self.isAdding = YES;

    }];
    
 
    
}

- (NSString *)convertToSysMoney:(NSString *)str {
    
    CGFloat v = [str floatValue];
    CGFloat t0 = v*1000;
    long long money = (long long)t0;
    return [NSString stringWithFormat:@"%lld",money];
}

//- (void)chooseType {
//
//    ZHChooseVC *vc = [[ZHChooseVC alloc] init];
//    vc.selectedType = ^(NSString *name,NSInteger type){
//    
//        self.discountFuncTf.text = name;
//        self.type = [NSString stringWithFormat:@"%ld",type];
//        if (type == 1) {
//            self.jianFanLbl.text = @"减";
//        } else {
//            self.jianFanLbl.text = @"返";
//        }
//        
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

- (void)chooseBeginTime {

    [self.view endEditing:YES];
    self.isBegin =  YES;
    [self.datePiker show];
}

- (void)chooseEndTime {

    [self.view endEditing:YES];
    self.isEnd = YES;
    [self.datePiker show];

}


- (TLTextField *)tfWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle placeholder:(NSString *)placeholder {
    
    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:LEFT_TITLE_WIDTH placeholder:placeholder];
    tf.leftLbl.textColor = [UIColor themeColor];
    UIView *line = [[UIView alloc] init];
    tf.leftLbl.font = FONT(14);
    tf.font = FONT(14);
    
    line.backgroundColor = [UIColor lineColor];
    [tf addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(tf.mas_left);
        make.width.equalTo(tf.mas_width);
        make.height.mas_equalTo(LINE_HEIGHT);
        make.bottom.equalTo(tf.mas_bottom);
        
    }];
    return tf;
    
}


//- (UIView *)discountDetailView {
//
//    if (!_discountDetailView) {
//        
//        _discountDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
//        _discountDetailView.backgroundColor = [UIColor whiteColor];
//        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
//        UITextField *tf1 = [[UITextField alloc] initWithFrame:CGRectMake(lbl1.xx, 0, SCREEN_WIDTH/2.0 - lbl1.xx, 45)];
//        self.targetMoneyTf = tf1;
//        tf1.keyboardType = UIKeyboardTypeDecimalPad;
//        tf1.font = [UIFont secondFont];
//        tf1.placeholder = @"输入金额";
//        lbl1.text = @"满";
//        lbl1.textColor = [UIColor zh_themeColor];
//        lbl1.textAlignment = NSTextAlignmentCenter;
//        [_discountDetailView addSubview:lbl1];
//        [_discountDetailView addSubview:tf1];
//        
//        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, 60, 45)];
//        UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(lbl2.xx, 0, tf1.width, 45)];
//        lbl2.text = @"减";
//        self.jianFanLbl = lbl2;
//        tf2.font = [UIFont secondFont];
//        tf2.keyboardType = UIKeyboardTypeDecimalPad;
//        self.discountMoneyTf = tf2;
//        lbl2.textColor = [UIColor zh_themeColor];
//        lbl2.textAlignment = NSTextAlignmentCenter;
//        tf2.placeholder = @"输入金额";
//        [_discountDetailView addSubview:lbl2];
//        [_discountDetailView addSubview:tf2];
//        
//    }
//    
//    return _discountDetailView;
//    
//}




- (TLDatePicker *)datePiker {

    if (!_datePiker) {
        
        _datePiker = [[TLDatePicker alloc] init];
        
    }
    return _datePiker;

}

- (void)remove:(UIControl *)ctrl {

    [ctrl removeFromSuperview];
}

//- (TLTextField *)nameTf {
//
//    if (!_nameTf) {
//        _nameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"抵扣券名称" titleWidth:LEFT_TITLE_WIDTH placeholder:@"请输入抵扣券名称"];
//        _nameTf.leftLbl.textColor = [UIColor themeColor];
//    }
//    return _nameTf;
//}

- (TLTextField *)discountFuncTf {

    if (!_discountFuncTf) {
        
        _discountFuncTf = [[TLTextField alloc] initWithframe:CGRectMake(0, self.nameTf.yy + 1, SCREEN_WIDTH, 45) leftTitle:@"折扣方式" titleWidth:LEFT_TITLE_WIDTH placeholder:@"请选择折扣方式"];
        UIButton *btn = [[UIButton alloc] initWithFrame:_discountFuncTf.bounds];
        [_discountFuncTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseType) forControlEvents:UIControlEventTouchUpInside];
    }
    return _discountFuncTf;
}


- (TLTextField *)beginTimeTf {

    if (!_beginTimeTf) {
        
        _beginTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, self.discountFuncTf.height) leftTitle:@"起始时间" titleWidth:LEFT_TITLE_WIDTH placeholder:@"请点击选择起始时间"];
        _beginTimeTf.leftLbl.textColor = [UIColor themeColor];

        UIButton *btn = [[UIButton alloc] initWithFrame:_beginTimeTf.bounds];
        [_beginTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseBeginTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _beginTimeTf;
}

- (TLTextField *)endTimeTf {

    if (!_endTimeTf) {
        
        _endTimeTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, self.discountFuncTf.height) leftTitle:@"结束时间" titleWidth:LEFT_TITLE_WIDTH placeholder:@"请点击选择结束时间"];
        _endTimeTf.leftLbl.textColor = [UIColor themeColor];

        UIButton *btn = [[UIButton alloc] initWithFrame:_endTimeTf.bounds];
        [_endTimeTf addSubview:btn];
        [btn addTarget:self action:@selector(chooseEndTime) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _endTimeTf;
}

- (TLTextView *)detailEditView {

    if (!_detailEditView) {
        _detailEditView = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        _detailEditView.placholder = @"请输入使用情况，请谨慎描述";
        _detailEditView.font = FONT(15);
        _detailEditView.textColor = [UIColor textColor];
    }
    return _detailEditView;
}




@end
