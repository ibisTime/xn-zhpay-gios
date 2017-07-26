//
//  CDOrderDetaiVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDOrderDetaiVC.h"
#import "ZHOrderModel.h"
#import "CDSendTfView.h"

@interface CDOrderDetaiVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderDetailTV;


//@property (nonatomic,strong) UITextField *expressNumTf;
//@property (nonatomic,strong) UITextField *expressCompanyTf;

@property (nonatomic, strong) CDSendTfView *expressNumView;
@property (nonatomic, strong) CDSendTfView *expressCompanyView;


@end

@implementation CDOrderDetaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.orderModel) {
        
        return;
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(14)
                                 textColor:[UIColor textColor]];
    [self.view addSubview:lbl];
    lbl.numberOfLines = 0;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    
    }];
    
    NSString *str = nil;
    
    if (self.orderModel.applyNote) {
        
        str = [NSString stringWithFormat:@"订单号：%@\n收件人：%@\n联系电话：%@\n收件地址：%@\n买家嘱咐：%@",self.orderModel.code, self.orderModel.receiver,self.orderModel.reMobile, self.orderModel.reAddress,self.orderModel.applyNote];
      
    
    } else  {
    
        str = [NSString stringWithFormat:@"订单号：%@\n收件人：%@\n联系电话：%@\n收件地址：%@",self.orderModel.code, self.orderModel.receiver,self.orderModel.reMobile, self.orderModel.reAddress];
    
    }

    lbl.attributedText = [self attrTextWithStr:str];
    
    //
    UITableView *orderDetailTableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    orderDetailTableV.delegate  = self;
    orderDetailTableV.dataSource  = self;

    self.orderDetailTV = orderDetailTableV;
    //
    [self.view addSubview:orderDetailTableV];
    [orderDetailTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbl.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    //
    if ([self.orderModel.status isEqualToString:ORDER_STATUS_WILL_SEND]) {
        
        [self deliveryGooodsFooterView];
        
    } else {
    
        [self setUpTableViewFooter];

    }
    
    //
    
}

#pragma mark- 取消订单
- (void)cancleOrder {
    
    [TLAlert alertWithTitle:nil msg:@"确定取消订单？" confirmMsg:@"取消" cancleMsg:@"不取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808056";
        http.parameters[@"codeList"] = @[self.orderModel.code];
        //        http.parameters[@"remark"] = @"商户取消订单";
        //        http.parameters[@"updater"] = [ZHUser user].userId;
        http.parameters[@"updater"] = [ZHUser user].userId;
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"remark"] = @"商户取消";
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"取消订单成功"];
            if (self.deliverSuccess) {
                self.deliverSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    
}

#pragma mark- 发货
- (void)deliverGoods {
    
    if (![self.orderModel.status isEqualToString:@"2"]) {
        [TLAlert alertWithHUDText:@"未支付订单不能发货"];
        return;
    }
    
    if (![self.expressCompanyView.tf.text valid]) {
        [TLAlert alertWithHUDText:@"输入快递公司"];
        return;
    }
    
    if (![self.expressNumView.tf.text valid]) {
        [TLAlert alertWithHUDText:@"输入快递单号"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"808054";
    
    http.parameters[@"logisticsCode"] = self.expressNumView.tf.text; //物流单号
    http.parameters[@"code"] = self.orderModel.code; //单号
    http.parameters[@"logisticsCompany"] = self.expressCompanyView.tf.text; //物流公司
    http.parameters[@"deliverer"] = [ZHUser user].userId;
    http.parameters[@"token"] = [ZHUser user].token;
    
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    http.parameters[@"deliveryDatetime"] = [formatter stringFromDate:[NSDate date]];
    http.parameters[@"updater"] = @"admin"; //admin
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"发货成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.deliverSuccess) {
            self.deliverSuccess();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)deliveryGooodsFooterView {

    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    self.orderDetailTV.tableFooterView = footerV;
    
    //
    UILabel *chooseExpressLbl = [UILabel labelWithFrame:CGRectMake(15, 30, 60, 30)
                                           textAligment:NSTextAlignmentLeft
                                        backgroundColor:[UIColor whiteColor]
                                                   font:FONT(14)
                                              textColor:[UIColor orderThemeColor]];
    [footerV addSubview:chooseExpressLbl];
    chooseExpressLbl.text = @"选择快递";
    //快递公司
//    UITextField *expressTf = [self tfWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 15 - chooseExpressLbl.xx - 20, 35) placeholder:@"请输入快递"];
//    [footerV addSubview:expressTf];
//    expressTf.centerY = chooseExpressLbl.centerY;
//    self.expressCompanyTf=  expressTf;
    
    //
    self.expressCompanyView = [[CDSendTfView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 15 - chooseExpressLbl.xx - 20, 35)];
    [footerV addSubview:self.expressCompanyView];
    self.expressCompanyView.tf.placeholder = @"请输入快递";
    
    //
    [self.expressCompanyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(chooseExpressLbl.mas_right).offset(15);
        make.right.equalTo(footerV.mas_right).offset(-15);
        make.height.equalTo(@35);
        make.centerY.equalTo(chooseExpressLbl.mas_centerY);
        
    }];

    
    //发货按钮
    UIButton *sendBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"发货"];
    [footerV addSubview:sendBtn];
    [sendBtn setBackgroundColor:[UIColor orderThemeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(deliverGoods) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    UITextField *expressCodeTf = [self tfWithFrame:CGRectZero placeholder:@"输入快递单号"];
//    [footerV addSubview:expressCodeTf];
    
    self.expressNumView = [[CDSendTfView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 15 - chooseExpressLbl.xx - 20, 35)];
    [footerV addSubview:self.expressNumView];
    self.expressNumView.tf.placeholder = @"请输入快递单号";
    
    
    //取消发货anniu
    UIButton *cancleBtn = [[UIButton alloc] init];
    [footerV addSubview:cancleBtn];
    [cancleBtn setTitle:@"因特殊原因无法发货取消订单" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor orderThemeColor] forState:UIControlStateNormal];
    cancleBtn.layer.borderColor = [UIColor orderThemeColor].CGColor;
    cancleBtn.layer.borderWidth = 1;
    cancleBtn.layer.cornerRadius = 5;
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.titleLabel.font = FONT(13);
    [cancleBtn addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
    //
//    [chooseExpressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(footerV.mas_left).offset(15);
//        make.top.equalTo(footerV.mas_top).offset(30);
//    }];
//
//    [expressTf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(chooseExpressLbl.mas_right).offset(20);
//        make.centerY.equalTo(chooseExpressLbl.mas_centerY);
//        make.right.equalTo(footerV.mas_right).offset(-15);
//        make.height.mas_equalTo(35);
//    }];
  
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
        make.right.equalTo(footerV.mas_right).offset(-15);
        
        //
        make.top.equalTo(self.expressCompanyView.mas_bottom).offset(28);
        
    }];
    
    [self.expressNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(footerV.mas_left).offset(15);
        make.centerY.equalTo(sendBtn.mas_centerY);
        make.right.equalTo(sendBtn.mas_left).offset(-10)
        ;
        make.height.equalTo(self.expressCompanyView.mas_height);
    }];
    
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressNumView.mas_bottom).offset(40);
        make.left.equalTo(footerV.mas_left).offset(20);
        make.right.equalTo(footerV.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
}

- (UIView *)tfBGView {


    UIView *v= [UIView new];


    return v;
}

- (UITextField *)tfWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {

    TLTextField *tf = [[TLTextField alloc] initWithFrame:frame];
//    tf.isAdjustPlaceholder = YES;
//    tf.isAdjustContentText = YES;
    tf.placeholder = placeholder;
    tf.font = FONT(13);
  

    return tf;
}

- (NSMutableAttributedString *)attrTextWithStr:(NSString *)str {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    return attr;

}

#pragma mark- 已经发货的footerView
- (void)setUpTableViewFooter {

    UILabel *lbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(14)
                                 textColor:[UIColor textColor]];
    lbl.numberOfLines = 0;
    
    NSString *text = nil;
    NSString *hintText = nil;
    
    if ([self.orderModel.status isEqualToString:ORDER_STATUS_HAS_RECEIVER]/*已收货*/) { //已收货
      text = [NSString stringWithFormat:@"%@：%@\n发货时间：%@\n用户已确认收货\n收货时间：%@",self.orderModel.logisticsCompany ,self.orderModel.logisticsCode ,_orderModel.deliveryDatetime ? [_orderModel.deliveryDatetime convertToDetailDate] : @"--",[self.orderModel.updateDatetime convertToDetailDate]];
        hintText = nil;
        
    } else if ([self.orderModel.status isEqualToString:ORDER_STATUS_HAS_SEND]) {
        // 已发货
       
       text = [NSString stringWithFormat:@"%@：%@\n发货时间：%@",self.orderModel.logisticsCompany,self.orderModel.logisticsCode,_orderModel.deliveryDatetime ? [_orderModel.deliveryDatetime convertToDetailDate] : @"--"];
        hintText = @"等待用户收货，用户忘记收货则已发货时间起7天后自动确认交易";
    } else if ([self.orderModel.status isEqualToString:ORDER_STATUS_WILL_SEND]) { //将要发货
    
    
    }
    
    lbl.attributedText = [self attrTextWithStr:text];
    
    CGSize size = [lbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    
    //
    lbl.frame = CGRectMake(15, 0, size.width, size.height);
    
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, size.height)];
    [bgView addSubview:lbl];
    
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(15, lbl.yy  +20, SCREEN_WIDTH - 30, 20)
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor orderThemeColor]];
    [bgView addSubview:hintLbl];
    hintLbl.text = hintText;
    hintLbl.numberOfLines = 0;
    CGSize hintSize = [hintLbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    hintLbl.height = hintSize.height + 5;
    
    //
    bgView.height = hintLbl.yy;
    
    self.orderDetailTV.tableFooterView = bgView;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {


    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, 50, 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:FONT(15)
                                 textColor:[UIColor orderThemeColor]];
    [v addSubview:lbl];
    lbl.text = @"货单";
    return v;

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, 50, 30)
                              textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                      font:FONT(13)
                                 textColor:[UIColor textColor]];
    [v addSubview:lbl];
    lbl.text = [NSString stringWithFormat:@"共计 %d 件货物",1];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v.mas_right).offset(-15);
        make.centerY.equalTo(v.mas_centerY);
    }];
    
    return v;
    
}

//--//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return self.orderModel.productOrderList.count;
    return 1;
}

//--//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = [UIColor textColor];
        cell.textLabel.numberOfLines = 0;
    }
    
    //
    cell.textLabel.text = [NSString stringWithFormat:@"%@  规格：%@   数量*%@",self.orderModel.product.name,self.orderModel.productSpecsName,self.orderModel.quantity];
    
    return cell;
    
}

@end
