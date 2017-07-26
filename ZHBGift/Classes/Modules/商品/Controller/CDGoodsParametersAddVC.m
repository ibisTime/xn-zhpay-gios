//
//  CDGoodsParametersAddVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsParametersAddVC.h"
#import "CDGoodsParameterModel.h"
#import "AddressPickerView.h"

@interface CDGoodsParametersAddVC ()

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) TLTextField *parameterNameTf;
@property (nonatomic, strong) TLTextField *countTf;
@property (nonatomic, strong) TLTextField *sendAddressTf;

@property (nonatomic, strong) TLTextField *weightTf;
@property (nonatomic, strong) AddressPickerView *addressPicker;

//
@property (nonatomic,strong) TLTextField *rmbTf;

@property (nonatomic, strong) UIButton *opBtn;



@end

@implementation CDGoodsParametersAddVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (!self.parameterModel) {
        [self.parameterNameTf becomeFirstResponder];

    }

}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加规格";

    [self setUpUI];
    
    [self initData];
    [self initChangeUI];
    
}

- (void)initChangeUI {

    if (!self.parameterModel) {
        self.title = @"添加规格";
        [self.opBtn setTitle:@"完成添加" forState:UIControlStateNormal];
        
        return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:0 target:self action:@selector(delete)];
    [self.opBtn setTitle:@"修改规格" forState:UIControlStateNormal];
    self.title = @"修改规格";

}

- (void)initData {


    self.parameterNameTf.text = self.parameterModel.name;
    self.rmbTf.text = [self.parameterModel.price1 convertToRealMoney];

    self.countTf.text = [self.parameterModel.quantity stringValue];
    self.weightTf.text = self.parameterModel.weight;
    self.sendAddressTf.text = self.parameterModel.province;

}


#pragma mark- 规格删除
- (void)delete {

    [TLAlert  alertWithTitle:@"确定删除" msg:nil confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
     [self callDelegateWithType:NewGoodsParameterOperationTypeDelete model:self.parameterModel];
     
//        if (self.isOpNewGoods) {
//            
//            [self callDelegateWithType:NewGoodsParameterOperationTypeDelete model:self.parameterModel];
//            
//        } else {
//            
//            //delete
//            TLNetworking *deleteHttp = [TLNetworking new];
//            deleteHttp.showView = self.view;
//            deleteHttp.code = @"808031";
//            deleteHttp.parameters[@"code"] = self.parameterModel.code;
//            [deleteHttp postWithSuccess:^(id responseObject) {
//                
//                [self callDelegateWithType:OldGoodsParameterOperationTypeDelete model:self.parameterModel];
//                
//            } failure:^(NSError *error) {
//                
//                
//            }];
//            
//        }

        
    }];
    
   
}


- (void)add {
    
    if (![self.rmbTf.text valid]) {
        self.rmbTf.text = 0;
    }


    
    if (![self.countTf.text valid]) {

        [TLAlert alertWithInfo:@"请填写商品数量"];
        return;
    }
    
    if (![self.sendAddressTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择发货地"];
        return;
    }
    
    if (![self.weightTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入产品重量"];
        return;
    }
    
    if (![self.parameterNameTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请填写规格名称"];
        return;
    }
    
    [self parameterOpNewGoods];
//    if (self.isOpNewGoods) {
//        
//        //商品新增
//        [self parameterOpNewGoods];
//        
//    } else {
//    
//        //商品为已添加
//        [self parameterOpOldGoods];
//    }
    

}


#pragma mark- 已有商品时的规格操作
- (void)parameterOpOldGoods {
    
    
    NSString *name = self.parameterNameTf.text;
    NSString *price1 =  [self.rmbTf.text convertToSysMoney];
    NSString *quantity = self.countTf.text;
    NSString *province = self.sendAddressTf.text;
    NSString *weight = self.weightTf.text;

    if (self.parameterModel) { //修改
        
        //
        TLNetworking *changeHttp = [TLNetworking new];
        changeHttp.showView = self.view;
        changeHttp.code = @"808032";
        changeHttp.parameters[@"code"] = self.parameterModel.code;
        changeHttp.parameters[@"price1"] = price1;
        changeHttp.parameters[@"price2"] = @"0";
        changeHttp.parameters[@"price3"] = @"0";
        changeHttp.parameters[@"province"] = province;
        changeHttp.parameters[@"weight"] = weight;
        changeHttp.parameters[@"quantity"] = quantity;
        changeHttp.parameters[@"orderNo"] = @"1";
        [changeHttp postWithSuccess:^(id responseObject) {
            
            CDGoodsParameterModel *model = self.parameterModel;
            model.name = self.parameterNameTf.text;
            model.price1 =  @([[self.rmbTf.text convertToSysMoney] longLongValue]);
//            model.price2 = @([[self.gwbTf.text convertToSysMoney] longLongValue]);
//            model.price3 = @([[self.qbbTf.text convertToSysMoney] longLongValue]);
            
            model.quantity = @([self.countTf.text longLongValue]);
            model.province = self.sendAddressTf.text;
            model.weight = self.weightTf.text;
            
            [self callDelegateWithType:OldGoodsParameterOperationTypeChange model:self.parameterModel];
            
         
            
        } failure:^(NSError *error) {
        
            
        }];
        
    } else { //新增
        
        TLNetworking *addHttp = [TLNetworking new];
        addHttp.showView = self.view;
        addHttp.code = @"808030";
        if (!self.productCode) {
            
            [TLAlert alertWithError:@"传入商品代码"];
            return;
        }
        
        addHttp.parameters[@"productCode"] = self.productCode;
        addHttp.parameters[@"name"] = name;
        addHttp.parameters[@"price1"] = price1;
        addHttp.parameters[@"price2"] = @"0";
        addHttp.parameters[@"price3"] = @"0";
        addHttp.parameters[@"province"] = province;
        addHttp.parameters[@"weight"] = weight;
        addHttp.parameters[@"quantity"] = quantity;
        
        addHttp.parameters[@"orderNo"] = @"1";
        [addHttp postWithSuccess:^(id responseObject) {
            
            CDGoodsParameterModel *model = [CDGoodsParameterModel new];
            model.code = [CDGoodsParameterModel randomCode];
            model.name = self.parameterNameTf.text;
            model.price1 =  @([[self.rmbTf.text convertToSysMoney] longLongValue]);
//            model.price2 = @([[self.gwbTf.text convertToSysMoney] longLongValue]);
//            model.price3 = @([[self.qbbTf.text convertToSysMoney] longLongValue]);
            model.quantity = @([self.countTf.text longLongValue]);
            model.province = self.sendAddressTf.text;
            model.weight = self.weightTf.text;
            
            [self callDelegateWithType:OldGoodsParameterOperationTypeAdd model:model];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }
    

}

#pragma mark- 新增商品时的规格操作
- (void)parameterOpNewGoods {

    if (self.parameterModel) {
        
        CDGoodsParameterModel *model = self.parameterModel;
        model.name = self.parameterNameTf.text;
        model.price1 =  @([[self.rmbTf.text convertToSysMoney] longLongValue]);
//        model.price2 = @([[self.gwbTf.text convertToSysMoney] longLongValue]);
//        model.price3 = @([[self.qbbTf.text convertToSysMoney] longLongValue]);
        model.quantity = @([self.countTf.text longLongValue]);
        model.province = self.sendAddressTf.text;
        model.weight = self.weightTf.text;
        
        
        [self callDelegateWithType:NewGoodsParameterOperationTypeChange model:model];

        
        return;
    }
    
    //新增
    CDGoodsParameterModel *model = [CDGoodsParameterModel new];
    model.code = [CDGoodsParameterModel randomCode];
    model.name = self.parameterNameTf.text;
    model.price1 =  @([[self.rmbTf.text convertToSysMoney] longLongValue]);
//    model.price2 = @([[self.gwbTf.text convertToSysMoney] longLongValue]);
//    model.price3 = @([[self.qbbTf.text convertToSysMoney] longLongValue]);
    model.quantity = @([self.countTf.text longLongValue]);
    model.province = self.sendAddressTf.text;
    model.weight = self.weightTf.text;
    
    [self callDelegateWithType:NewGoodsParameterOperationTypeAdd model:model];
    

}


- (void)callDelegateWithType:(GoodsParameterOperationType)type model:(CDGoodsParameterModel *)model {

    if (self.delegate && [self.delegate respondsToSelector:@selector(finishOperationWithType:model:playgroundVC:)]) {
        
        [self.delegate finishOperationWithType:type model:model playgroundVC:self];
        
    }

}

- (void)chooseAddress:(UIButton *)btn {

    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];

}

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _addressPicker.componentNum = 1;
        
        //        __weak AddressPickerView *weakPick = _addressPicker;
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            weakSelf.sendAddressTf.text = province;

        };
        //
        
    }
    return _addressPicker;
    
}

- (void)setUpUI {

    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.bgScrollView];
    
    //
    self.parameterNameTf = [self tfWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 45) leftTitle:@"规格描述" placeholder:@"类别规格的描述"];
    [self.bgScrollView addSubview:self.parameterNameTf];
    
    //
    self.countTf = [self tfWithFrame:CGRectMake(0, self.parameterNameTf.yy, SCREEN_WIDTH, 45) leftTitle:@"库存(件)" placeholder:@"数量"];
    [self.bgScrollView addSubview:self.countTf];
    self.countTf.keyboardType = UIKeyboardTypeNumberPad;
    
    //发货地
    self.sendAddressTf = [self tfWithFrame:CGRectMake(0, self.countTf.yy, SCREEN_WIDTH, 45) leftTitle:@"发货地" placeholder:@"请选择发货地"];
    [self.bgScrollView addSubview:self.sendAddressTf];
    self.sendAddressTf.enabled = NO;
    
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:self.sendAddressTf.frame];
    [self.bgScrollView addSubview:maskBtn];
    [maskBtn addTarget:self action:@selector(chooseAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //重量
    self.weightTf = [self tfWithFrame:CGRectMake(0, self.sendAddressTf.yy, SCREEN_WIDTH, 45) leftTitle:@"重量(kg)" placeholder:@"请输入重量"];
    [self.bgScrollView addSubview:self.weightTf];
    self.weightTf.keyboardType = UIKeyboardTypeDecimalPad;
    
    //人民币
    self.rmbTf = [self tfWithFrame:CGRectMake(0, self.weightTf.yy, SCREEN_WIDTH, 45) leftTitle:@"礼品券" placeholder:@"请输入礼品券价格，不填写默认为0"];
    [self.bgScrollView addSubview:self.rmbTf];
    self.rmbTf.keyboardType = UIKeyboardTypeDecimalPad;
    
    //购物币
//    self.gwbTf = [self tfWithFrame:CGRectMake(0, self.rmbTf.yy, SCREEN_WIDTH, 45) leftTitle:@"购物币" placeholder:@"请输入购物币价格，不填写默认为0"];
//    [self.bgScrollView addSubview:self.gwbTf];
//    self.gwbTf.keyboardType = UIKeyboardTypeDecimalPad;
//    
//    //钱包币
//    self.qbbTf = [self tfWithFrame:CGRectMake(0, self.gwbTf.yy, SCREEN_WIDTH, 45) leftTitle:@"钱包币" placeholder:@"请输入钱包币价格，不填写默认为0"];
//    [self.bgScrollView addSubview:self.qbbTf];
//    self.qbbTf.keyboardType = UIKeyboardTypeDecimalPad;
//    
    //
    UIButton *btn = [UIButton zhBtnWithFrame:CGRectMake(20, self.rmbTf.yy + 30, SCREEN_WIDTH - 40, 45) title:@"完成添加"];
    [self.bgScrollView addSubview:btn];
    self.opBtn = btn;
    [btn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];

}

//--//
- (TLTextField *)tfWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle placeholder:(NSString *)placeholder {
    
    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:100 placeholder:placeholder];
    tf.leftLbl.textColor = [UIColor goodsThemeColor];
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

@end
