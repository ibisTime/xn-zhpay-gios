//
//  CDGoodsAddVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDGoodsAddVC.h"
#import "ZHGoodsDetailEditView.h"
#import "TLImagePicker.h"
#import "TLUploadManager.h"
#import "ZHGoodsModel.h"
#import "ZHCategoryManager.h"
#import "CDGoodsParametersAddVC.h"
#import "CDParameterCell.h"
#import "CDGoodsParameterModel.h"

@interface CDGoodsAddVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,GoodsParametersOperationDelegate>


@property (nonatomic, strong) UIButton *saveBtn;

//
@property (nonatomic, strong) UITableView *goodsAddTV;
@property (nonatomic, strong) TLTextField *goodsNameTf;

@property (nonatomic, strong) TLTextField *sloganTf;
@property (nonatomic, strong) TLTextView *sloganTextView;

@property (nonatomic, strong) TLTextField *goodsTypeTf;

@property (nonatomic, strong) UIPickerView *categoryPicker;

@property (nonatomic, strong) ZHGoodsDetailEditView *detailEditView;
//
@property (nonatomic, strong) UIImageView *coverImageView;
//
@property (nonatomic, assign) BOOL coverImgChanged;
@property (nonatomic, assign) BOOL detailImgsChanged;
@property (nonatomic, assign) BOOL isChangeType;

@property (nonatomic, strong) NSMutableArray <CDGoodsParameterModel *> *parameterModelArr;

@end

@implementation CDGoodsAddVC {

    TLImagePicker *picker;
    dispatch_group_t _uploadGroup;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _uploadGroup = dispatch_group_create();
    self.parameterModelArr = [[NSMutableArray alloc] init];
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
    if (self.goods) {
        
        [self tl_placeholderOperation];
        
    } else {
    
        [self setUpUI];
        [self initData];

    }
  
}


- (void)tl_placeholderOperation {

    //先查询规格
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808037";
    http.parameters[@"productCode"] = self.goods.code;
    [http postWithSuccess:^(id responseObject) {
        
        self.parameterModelArr = [CDGoodsParameterModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [self setUpUI];
        
        [self initData];
        [self removePlaceholderView];
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        
    }];

}


- (void)setUpUI {

    UITableView *addTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 65) style:UITableViewStylePlain];
    
    [self.view addSubview:addTV];
    self.goodsAddTV = addTV;
    self.goodsAddTV.delegate = self;
    self.goodsAddTV.dataSource = self;
    self.goodsAddTV.rowHeight = 60;
    self.goodsAddTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //header
    [self seetUpTableViewHeader];
    
    //footer
    UIButton *addParametersBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    addParametersBtn.backgroundColor = [UIColor whiteColor];
    [addParametersBtn setImage:[UIImage imageNamed:@"店铺装修-封面"] forState:UIControlStateNormal];
    self.goodsAddTV.tableFooterView = addParametersBtn;
    [addParametersBtn addTarget:self action:@selector(addParameters) forControlEvents:UIControlEventTouchUpInside];
    
    //保存
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, addTV.yy + 10, SCREEN_WIDTH - 40, 45)];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = FONT(15);
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"保存编辑，并发布" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor shopThemeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn = btn;

}

#pragma mark- 添加规格的-- delegate
- (void)finishOperationWithType:(GoodsParameterOperationType)type model:(CDGoodsParameterModel *)model playgroundVC:(UIViewController *)vc {

    switch (type) {
            
        //old
        case OldGoodsParameterOperationTypeAdd: {
        
            [TLAlert alertWithSucces:@"添加规格成功"];
            [self.parameterModelArr addObject:model];
            [self.goodsAddTV reloadData];
   
        } break;
        case OldGoodsParameterOperationTypeDelete: {
            
            [TLAlert alertWithSucces:@"规格已删除"];
            __block NSInteger hintIdx = -1;
            [self.parameterModelArr enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.code isEqualToString:model.code]) {
                    hintIdx = idx;
                }
                
            }];
            
            if (hintIdx >= 0) {
                
                [self.parameterModelArr removeObjectAtIndex:hintIdx];
                [self.goodsAddTV reloadData];
            }

            
        } break;
            
        case OldGoodsParameterOperationTypeChange: {
            
            [TLAlert alertWithSucces:@"规格修改成功"];
            [self.goodsAddTV reloadData];

        } break;
            
       // new
        case NewGoodsParameterOperationTypeAdd: {
            
            [self.parameterModelArr addObject:model];
            [self.goodsAddTV reloadData];
            
            if (self.goodsAddTV.contentSize.height > self.goodsAddTV.frame.size.height)
            {
                CGPoint offset = CGPointMake(0, self.goodsAddTV.contentSize.height - self.goodsAddTV.frame.size.height);
                [self.goodsAddTV setContentOffset:offset animated:NO];
            }
            
        } break;
            
        case NewGoodsParameterOperationTypeDelete: {
            
            __block NSInteger hintIdx = -1;
            [self.parameterModelArr enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.code isEqualToString:model.code]) {
                    hintIdx = idx;
                }
                
            }];
            
            if (hintIdx >= 0) {
                
                [self.parameterModelArr removeObjectAtIndex:hintIdx];
                [self.goodsAddTV reloadData];
            }
            
        } break;
            
        case NewGoodsParameterOperationTypeChange: {
            
            [self.goodsAddTV reloadData];
            
        } break;

    }

    if (vc && vc.navigationController) {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

//
- (void)addParameters {

    CDGoodsParametersAddVC *addVC = [[CDGoodsParametersAddVC alloc] init];
    addVC.delegate = self;
    addVC.isOpNewGoods = self.goods == nil;
    addVC.productCode = self.goods ?  self.goods.code : nil ;
    [self.navigationController pushViewController:addVC animated:YES];

}

#pragma mark- 上架
- (void)shangJiaAction {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808013";
    
    http.parameters[@"code"] = self.goods.code;
    http.parameters[@"location"] = @"1";
    http.parameters[@"orderNo"] = @"1";

    http.parameters[@"updater"] = [ZHUser user].userId;
    http.parameters[@"remark"] = @"商户自己上架";
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"上架成功"];
        [self.navigationController popViewControllerAnimated:YES];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_good_list" object:nil];
        
//        if (self.addSuccess) {
//            self.addSuccess();
//        }
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark- 下架
- (void)xiaJiaAction {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808014";
    http.parameters[@"code"] = self.goods.code;
    http.parameters[@"updater"] = [ZHUser user].userId;
    http.parameters[@"remark"] = @"商户自己下架";
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下架成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
          [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_good_list" object:nil];
        
//        if (self.addSuccess) {
//            self.addSuccess();
//        }
        
    } failure:^(NSError *error) {
        
    }];

    
}

#pragma mark-有商品 进行数据初始化
- (void)initData {

    if (!self.goods) {
        
        self.title = @"添加商品";
        return;
    }
    self.title = @"修改商品";
    
    if ([self.goods.status isEqualToString:GOODS_STATUS_SHANG_JIA]) {
        
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下架" style:0 target:self action:@selector(xiaJiaAction)];
        
        [self.saveBtn setTitle:@"修改商品，请先将商品下架" forState:UIControlStateNormal];
        self.saveBtn.enabled = NO;
        self.goodsAddTV.tableFooterView = nil;
        self.goodsAddTV.allowsSelection = NO;

    } else {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上架" style:0 target:self action:@selector(shangJiaAction)];
        
        [self.saveBtn setTitle:@"保存编辑" forState:UIControlStateNormal];


    
    }
//  self.rmbTf.text = [self.goods.price1 convertToRealMoney];
//  self.gwbTf.text = [self.goods.price2 convertToRealMoney];
//  self.qbbTf.text = [self.goods.price3 convertToRealMoney];
    
        //
        self.goodsNameTf.text = self.goods.name;
        
        NSString *advPic = [self.goods.advPic convertImageUrl];
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:advPic]  placeholderImage:nil];
        self.coverImageView.hidden = NO;
        self.sloganTextView.text = self.goods.slogan;

        self.detailEditView.detailTextView.text = self.goods.descriptionPro;
        self.detailEditView.images = [NSMutableArray arrayWithArray:self.goods.pics];
        
        //显示商品类型
        
        NSString *big = [[ZHCategoryManager manager] getNameByCategoryCode:self.goods.category];
        NSString *small = [[ZHCategoryManager manager] getNameByCategoryCode:self.goods.type];
        
        self.goodsTypeTf.text = [NSString stringWithFormat:@"%@ %@",big,small];
        
        
        //隐藏底部按钮
        self.title = @"商品详情";
        
//        if ([self.goods.status isEqualToString:@"91"] && self.goods.remark) {
//            
//            self.hintLbl.text = [NSString stringWithFormat:@"失败原因: %@",self.goods.remark];
//            
//        }
        
        //  TO_APPROVE("0", "待审核"), APPROVE_YES("1", "审批通过待上架"), APPROVE_NO("91",
        //        "审批不通过"), PUBLISH_YES("3", "已上架"), PUBLISH_NO("4", "已下架");
        
//        [self.confirmBtn setTitle:@"修改重提" forState:UIControlStateNormal];
        
}

#pragma mark- tableview -- delegeate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDGoodsParametersAddVC *VC= [[CDGoodsParametersAddVC alloc] init];
    VC.parameterModel = self.parameterModelArr[indexPath.row];
    VC.isOpNewGoods = self.goods == nil;
    VC.delegate = self;
    if (self.goods) {
        
        VC.productCode = self.goods.code;

    }
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark- tableview -- dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.parameterModelArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CDParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDParameterCell"];
    if (!cell) {
        
        cell = [[CDParameterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDParameterCell"];
//        cell.backgroundColor = RANDOM_COLOR;
    }
    
    CDGoodsParameterModel *model = self.parameterModelArr[indexPath.row];
    cell.contentLbl.text =  [model getDetailText];
    return cell;

}


- (void)remove:(id)sender {
    
    [sender removeFromSuperview];
    
}



#pragma mark- 添加封面图片
- (void)addCoverImage {
    
    __weak typeof(self) weakself = self;
    picker = [[TLImagePicker alloc] initWithVC:self];
    picker.pickFinish = ^(NSDictionary *info){
        
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        
        [TLProgressHUD showWithStatus:nil];
        [image zipBegin:^{
            
         [TLProgressHUD dismiss];

            
        } end:^(UIImage *newImg) {
            
            weakself.coverImageView.hidden = NO;
            weakself.coverImgChanged = YES;
            weakself.coverImageView.image = newImg;
            
        }];
        
    
        
    };
    [picker picker];
    
}

- (BOOL)validInput {

    if (!self.goodsNameTf.text || self.goodsNameTf.text.length <= 0 || self.goodsNameTf.text.length > 20) {
        
        [TLAlert alertWithHUDText:@"商品名称字数需小于20,大于0"];
        return NO;
    }
    
    
    //封面图片
    if (!self.coverImageView.image ) {
        
        [TLAlert alertWithHUDText:@"请选择商品封面图"];
        return NO;
        
    }
    
    
    
    if(![self.sloganTextView.text valid]){
        
        [TLAlert alertWithHUDText:@"请输入广告语"];
        return NO;
    }
    
    
    if(![self.goodsNameTf.text valid]){
        
        [TLAlert alertWithHUDText:@"请输入商品名称"];
        return NO;
    }
    
    if (![self.goodsTypeTf.text valid]) {
        [TLAlert alertWithHUDText:@"请选择商品参与类型"];
        return NO;
    }
    
    //详情图片
    if (self.detailEditView.images.count <= 0 || self.detailEditView.images.count > 3) {
        
        [TLAlert alertWithHUDText:@"请选择详情图片,最多三张"];
        return NO;
        
    }
    
    
    if(![self.detailEditView.detailTextView.text valid]){
        
        [TLAlert alertWithHUDText:@"请输入商品详情"];
        return NO;
    }
    
    
    //
    if (!self.goods && self.parameterModelArr.count <= 0) {
        
        [TLAlert alertWithInfo:@"商品至少添加一种规格"];
        return NO;
    }
    return YES;
    
}


#pragma mark- 增加商品
- (void)addGoods {
    
    if (![self validInput]) {
        
        return;
    }

    //
    //元素为已上传的图片，可能为 0
    __block NSMutableArray <NSString *>*detailImagUrls = [NSMutableArray array];
    
    //元素为未上传的图片，可能为 0
    __block  NSMutableArray <UIImage *>*detailImgs = [NSMutableArray array];
    
    //上传成功 的key
    __block  NSMutableArray <NSString *>*detailImgsUploadSuccessKeys = [NSMutableArray array];
    
    [self.detailEditView.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImage class]]) {
            
            self.detailImgsChanged = YES;
            [detailImgs addObject:obj];
            //第一张已经为[uiimage image] 后续肯定为Img
            if(idx == 0) {
                *stop = YES;
                detailImgs = self.detailEditView.images;
            }
            
        } else {
            
            [detailImagUrls addObject:obj];
            
        }
        
    }];
    
    if (detailImagUrls) {
        detailImgsUploadSuccessKeys = [NSMutableArray arrayWithArray:detailImagUrls];
    }
    
    
    NSString *coverImgKey = [TLUploadManager imageNameByImage:self.coverImageView.image];
    __block NSString *coverImgSuccessKey;
    
    
    TLNetworking *getUploadToken = [TLNetworking new];
    
    //需要上传图片
    if (self.coverImgChanged || self.detailImgsChanged) {//----------
        
        getUploadToken.showView = self.view;
        getUploadToken.code = @"807900";
        getUploadToken.parameters[@"token"] = [ZHUser user].token;
        [getUploadToken postWithSuccess:^(id responseObject) {
            
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [TLProgressHUD showWithStatus:nil];
            QNUploadManager *uploadManager = [TLUploadManager qnUploadManager];
            NSString *token = responseObject[@"data"][@"uploadToken"];
            
            //封面图片上传
            if(self.coverImgChanged){
                dispatch_group_enter(_uploadGroup);
                NSData *data =  UIImageJPEGRepresentation(self.coverImageView.image, 1);
                [uploadManager putData:data key:coverImgKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    dispatch_group_leave(_uploadGroup);
                    if (info.error) {
                        
                        [TLAlert alertWithHUDText:@"店铺图片上传失败"];
                        return ;
                        
                    }
                    
                    coverImgSuccessKey = key;
                    
                } option:nil];
                
            }
            
            //其它图片上传
            if (self.detailImgsChanged) {
                for (NSInteger i = 0; i < detailImgs.count; i ++) {
                    
                    dispatch_group_enter(_uploadGroup);
                    UIImage *image = detailImgs[i];
                    NSData *data =  UIImageJPEGRepresentation(image, 1);
                    [uploadManager putData:data key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        
                        dispatch_group_leave(_uploadGroup);
                        
                        if (info.error) {
                            
                            [TLAlert alertWithHUDText:@"店铺图片上传失败"];
                            return ;
                            
                        }
                        
                        [detailImgsUploadSuccessKeys addObject:key];
                        
                    } option:nil];
                    
                }
                
            }
            
            //上传完进行汇总
            if (!self.coverImgChanged) {
                coverImgSuccessKey = self.goods.advPic;
            }
            
            dispatch_group_t group  = _uploadGroup;
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [TLProgressHUD dismiss];
                
                if (!coverImgSuccessKey) {
                    
                    [TLAlert alertWithError:@"封面图片上传失败"];

                    return ;
                }
                
                if (detailImgsUploadSuccessKeys.count != self.detailEditView.images.count) {
                    [TLAlert alertWithError:@"详情图片上传失败"];
                    return;
                }
                
                [self upLoadImageSuccess:coverImgSuccessKey detailImageKeys:[detailImgsUploadSuccessKeys componentsJoinedByString:@"||"]];
                
            });
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else {//无需上传图片
        
        
        [self upLoadImageSuccess:self.goods.advPic detailImageKeys:[detailImagUrls componentsJoinedByString:@"||"]];
        
    }
    
}

//选择类型按钮
//- (void)chooseType {
//    
//    [self.view endEditing:YES];
//    
//    
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
//    pickerView.backgroundColor = [UIColor whiteColor];
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
//    self.categoryPicker = pickerView;
//    
//    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [maskCtrl addTarget:self action:@selector(remove:) forControlEvents:
//     UIControlEventTouchUpInside];
//    maskCtrl.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
//    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
//    [maskCtrl addSubview:pickerView];
//    
//}


- (void)upLoadImageSuccess:(NSString *)coverImageKey detailImageKeys:(NSString *)detailImgKeys {
    
    NSInteger bigIndex = [self.categoryPicker selectedRowInComponent:0]; //大类下标
    NSInteger smallIndex = [self.categoryPicker selectedRowInComponent:1]; //小类下表
    
    ZHCategoryModel *bigModel = [ZHCategoryManager manager].bigCategorys[bigIndex];
    
    //普通商品的上传
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.isAutoDeliverCompanyCode = NO;
    //    http.parameters[@"companyCode"] = [ZHUser user].userId;
    
    if (self.goods) { //修改重提
        
        http.code = @"808012";
        http.parameters[@"code"] = self.goods.code;
        
    } else { //普通新增商品
        
        http.code = @"808010";
        
    }
    
    if (self.goods && !self.isChangeType) { //没有修改过类别
        
        // http.parameters[@"category"] = self.goods.category; //小类
        http.parameters[@"type"] = self.goods.type; //小类
        
    } else {
        
        NSMutableArray *array = [ZHCategoryManager manager].categoryDict[bigModel.code];
        if (array.count > 0) {
            ZHCategoryModel *smallModel = array[smallIndex];
            //            http.parameters[@"category"] = smallModel.code; //小类
            http.parameters[@"type"] = smallModel.code; //小类
            
        } else {
            
            //          http.parameters[@"category"] = @"无"; //小类
            http.parameters[@"type"] = @"无"; //小类
            
        }
        
    }
    

//    if ([self.rmbTf.text valid]) {
//        http.parameters[@"price1"] = [self.rmbTf.text convertToSysMoney];//人民币
//        
//    }
//    if ([self.gwbTf.text valid]) {
//        http.parameters[@"price2"] = [self.gwbTf.text convertToSysMoney];//购物
//        
//    }
//    
//    if ([self.qbbTf.text valid]) {
//        
//        http.parameters[@"price3"] = [self.qbbTf.text convertToSysMoney]; //钱包
//        
//    }
    
    //
    http.parameters[@"slogan"] = self.sloganTextView.text;//广告语
    http.parameters[@"advPic"] = coverImageKey;//广告图
    http.parameters[@"pic"] = detailImgKeys; //图片详情拼接的字符串
    http.parameters[@"updater"] = [ZHUser user].userId;
    http.parameters[@"name"] = self.goodsNameTf.text;
    http.parameters[@"description"] = self.detailEditView.detailTextView.text; //详情
    //    http.parameters[@"costPrice"] = @"0"; //产品价
    //    http.parameters[@"quantity"] = @"1000000000"; //库存
    http.parameters[@"updater"] = [ZHUser user].userId; //更新人
    http.parameters[@"token"] = [ZHUser user].token; //更新人
    http.parameters[@"companyCode"] = [ZHUser user].userId;
    
    
    
        NSMutableArray *parametersArr = [[NSMutableArray alloc] initWithCapacity:self.parameterModelArr.count];
        [self.parameterModelArr enumerateObjectsUsingBlock:^(CDGoodsParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [parametersArr addObject: [obj toDictionry]];
        }];
        http.parameters[@"productSpecsList"] = parametersArr;
    
    
    [http postWithSuccess:^(id responseObject) {
        
        if(self.goods) {
            [TLAlert alertWithHUDText:@"保存商品成功"];
            
        } else {
            
            [TLAlert alertWithHUDText:@"发布商品成功"];
        }
        
          [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_good_list" object:nil];
//        
//        if (self.addSuccess) {
//          
//            self.addSuccess();
//        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark- pickerView  dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger count = 0;
    if (component ==  0) {
        
        count = [ZHCategoryManager manager].bigCategorys.count;
        
    } else {
        
        NSInteger index = [pickerView selectedRowInComponent:0];
        ZHCategoryModel *big = [ZHCategoryManager manager].bigCategorys[index];
        count = [ZHCategoryManager manager].categoryDict[big.code].count;
        
    }
    
    return count;
    
}


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *name;
    if (component == 0) { //大类
        
        ZHCategoryModel *big = [ZHCategoryManager manager].bigCategorys[row];
        name = big.name;
        
    } else { //小类
        
        NSInteger index = [pickerView selectedRowInComponent:0];
        ZHCategoryModel *big = [ZHCategoryManager manager].bigCategorys[index];
        
        NSMutableArray *smallCategoryArray = [ZHCategoryManager manager].categoryDict[big.code];
        if (smallCategoryArray.count > 0) {
            ZHCategoryModel *small = smallCategoryArray[row];
            name = small.name;
        } else {
            
            name = @"无";
            
        }
        
    }
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:name attributes:@{
                                                                                           
                                                                                           NSForegroundColorAttributeName: [UIColor zh_textColor],
                                                                                           NSFontAttributeName: [UIFont secondFont]
                                                                                           
                                                                                           }];
    return str;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.isChangeType = YES;
    if (component == 0 ) {
        [pickerView reloadComponent:1];
        
        ZHCategoryModel *big = [ZHCategoryManager manager].bigCategorys[row];
        
        NSMutableArray *smallArray = [ZHCategoryManager manager].categoryDict[big.code];
        if (smallArray.count > 0) {
            
            ZHCategoryModel *model = smallArray[0];
            self.goodsTypeTf.text = [NSString stringWithFormat:@"%@ %@",big.name,model.name];
        }
        
    } else {
        
        NSInteger bigIndex = [pickerView selectedRowInComponent:0];
        ZHCategoryModel *big = [ZHCategoryManager manager].bigCategorys[bigIndex];
        ZHCategoryModel *small = [ZHCategoryManager manager].categoryDict[big.code][row];
        self.goodsTypeTf.text = [NSString stringWithFormat:@"%@ %@",big.name,small.name];
      
    }
    
}

- (TLTextField *)tfWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle placeholder:(NSString *)placeholder {
    
    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:110 placeholder:placeholder];
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

- (void)seetUpTableViewHeader {


    //提交按钮
    //
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 800)];
    //
    self.goodsNameTf = [self tfWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) leftTitle:@"商品名称" placeholder:@"最多输入20个字符"];
    [headerView addSubview:self.goodsNameTf];
    
    //
    self.sloganTf = [self tfWithFrame:CGRectMake(0, self.goodsNameTf.yy, SCREEN_WIDTH, 45) leftTitle:@"广告语" placeholder:@"输入简单的广告语"];
    [headerView addSubview:self.sloganTf];
    self.sloganTf.enabled = NO;
    //
    self.sloganTf.height = 70;
    self.sloganTextView = [[TLTextView alloc] initWithFrame:CGRectMake(105, self.sloganTf.y, SCREEN_WIDTH - 105, self.sloganTf.height - 1)];
    [headerView addSubview:self.sloganTextView];
    self.sloganTextView.font = FONT(14);
    self.sloganTextView.placeholderLbl.font = self.sloganTextView.font;
    self.sloganTextView.textColor =  self.sloganTf.textColor;
    self.sloganTextView.placholder = @"输入简单的广告语";
    
    //类别选择
    self.goodsTypeTf = [self tfWithFrame:CGRectMake(0, self.sloganTf.yy, SCREEN_WIDTH, 45) leftTitle:@"分类" placeholder:@"请选择商品分类"];
    [headerView addSubview:self.goodsTypeTf];
    self.goodsTypeTf.enabled = NO;
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:self.goodsTypeTf.frame];
    [headerView addSubview:maskBtn];
    
    
    //三个币种
//    //人民币
//    self.rmbTf = [self tfWithFrame:CGRectMake(0, self.goodsTypeTf.yy, SCREEN_WIDTH, 45) leftTitle:@"人民币" placeholder:@"请输入人民币价格，不填写默认为0"];
//    [headerView addSubview:self.rmbTf];
//    self.rmbTf.keyboardType = UIKeyboardTypeDecimalPad;
//    
//    //购物币
//    self.gwbTf = [self tfWithFrame:CGRectMake(0, self.rmbTf.yy, SCREEN_WIDTH, 45) leftTitle:@"购物币" placeholder:@"请输入购物币价格，不填写默认为0"];
//    [headerView addSubview:self.gwbTf];
//    self.gwbTf.keyboardType = UIKeyboardTypeDecimalPad;
//    
//    
//    //钱包币
//    self.qbbTf = [self tfWithFrame:CGRectMake(0, self.gwbTf.yy, SCREEN_WIDTH, 45) leftTitle:@"钱包币" placeholder:@"请输入购物币价格，不填写默认为0"];
//    [headerView addSubview:self.qbbTf];
//    self.qbbTf.keyboardType = UIKeyboardTypeDecimalPad;
//    
    
    //商品显示图片
    UIButton *coverImgBgView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.goodsTypeTf.yy, SCREEN_WIDTH, 150)];
    [headerView addSubview:coverImgBgView];
    [coverImgBgView addTarget:self action:@selector(addCoverImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"店铺装修-封面"]];
    [coverImgBgView addSubview:addImgView];
    
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor textColor2]];
    [coverImgBgView addSubview:hintLbl];
    hintLbl.text = @"首页显示图片";
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [coverImgBgView addSubview:self.coverImageView];
    self.coverImageView .hidden =  YES;
    
    [addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(coverImgBgView.mas_centerX);
        make.centerY.equalTo(coverImgBgView.mas_centerY).offset(-10);
        
    }];
    
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addImgView.mas_centerX);
        make.top.equalTo(addImgView.mas_bottom).offset(5);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
    //线
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [coverImgBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(coverImgBgView.mas_left);
        make.right.equalTo(coverImgBgView.mas_right);
        make.height.mas_equalTo(LINE_HEIGHT);
        make.bottom.equalTo(coverImgBgView.mas_bottom);
        
    }];
    
    //详情描述
    self.detailEditView = [[ZHGoodsDetailEditView alloc] initWithFrame:CGRectMake(0, coverImgBgView.yy, SCREEN_WIDTH, 220)];
    [headerView addSubview:self.detailEditView];
    self.detailEditView.placholder = @"请就关于您的商品做一些20字以上60字以内的简单描述";
    self.detailEditView.typeNameLbl.text = @"商品详情";
    
    UIImageView *hintImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.detailEditView.yy , 12, 12)];
    [headerView addSubview:hintImageV];
    hintImageV.image = [UIImage imageNamed:@"店铺装修-提示"];
    
    //
    UILabel *hinInfoLbl = [UILabel  labelWithFrame:CGRectMake(hintImageV.xx + 9, hintImageV.y - 4, SCREEN_WIDTH - 35, 20)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
    
    [headerView addSubview:hinInfoLbl];
    hinInfoLbl.numberOfLines = 2;
    hinInfoLbl.text = @"详情图片推荐尺寸690*n（长度不限）最多添加三张";
    
    //规格shuoming
    UILabel *parametersLbl = [UILabel labelWithFrame:CGRectMake(15, self.detailEditView.yy + 30, SCREEN_WIDTH - 30, 30) textAligment:NSTextAlignmentLeft
                                     backgroundColor:[UIColor whiteColor]
                                                font:FONT(15)
                                           textColor:[UIColor goodsThemeColor]];
    [headerView addSubview:parametersLbl];
    parametersLbl.text = @"规格";
    
    //长度矫正
    headerView.height = parametersLbl.yy;
    
    
    UIView *parametersLblTopLine = [[UIView alloc] init];
    parametersLblTopLine.backgroundColor = [UIColor lineColor];
    [headerView addSubview:parametersLblTopLine];
    [parametersLblTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.height.mas_equalTo(LINE_HEIGHT);
        make.width.equalTo(headerView.mas_width);
        make.bottom.equalTo(parametersLbl.mas_top);
    }];

    self.goodsAddTV.tableHeaderView = headerView;

}


@end

