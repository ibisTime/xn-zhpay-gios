//
//  CDShopInfoChangeVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDShopInfoChangeVC.h"
#import "CDShopFitUpView.h"
#import "ZHGoodsDetailEditView.h"
#import "TLUploadManager.h"
#import "ZHMapController.h"
#import "TLImagePicker.h"
#import "CDSignAContractInfoVC.h"
#import "ZHShopTypeChooseVC.h"
#import "AddressPickerView.h"
#import "ZHSJIntroduceVC.h"

@interface CDShopInfoChangeVC ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) TLTextField *shopNameTf; //名称
@property (nonatomic,strong) TLTextField *shopAddressTf; //省市区县
@property (nonatomic,strong) TLTextField *detailAddressTf; //详细地址

@property (nonatomic,strong) TLTextField *shopPhoneTf; //电话
@property (nonatomic, strong) TLTextField *smsPhoneTf;

@property (nonatomic,strong) TLTextField *sloganTf; //广告语
@property (nonatomic, strong) TLTextView *sloganTextView;

//法人姓名，推荐人姓名
@property (nonatomic,strong) TLTextField *leagleNameTf;//法人
@property (nonatomic,strong) TLTextField *referrerMobileTf;//推荐人账号

//店铺封面
@property (nonatomic, strong) CDShopFitUpView *shopCoverView;
//gps
@property (nonatomic, strong) CDShopFitUpView *gpsView;

//签约信息
@property (nonatomic, strong) CDShopFitUpView *signAContractView;

//行业
@property (nonatomic, strong) CDShopFitUpView *shopTypeView;

//店铺详细信息，介绍以及图片
@property (nonatomic, strong) ZHGoodsDetailEditView *shopDetailView;

//--//
@property (nonatomic, assign) BOOL coverImgChanged;
@property (nonatomic, assign) BOOL detailImgsChanged;

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;


@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, strong) AddressPickerView  *addressPicker;


@end

@implementation CDShopInfoChangeVC
{
    dispatch_group_t _uploadGroup;
    TLImagePicker *_pickerVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺装修";
    
    self.coverImgChanged = NO;
    self.detailImgsChanged = NO;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
    
}

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //        __weak AddressPickerView *weakPick = _addressPicker;
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            weakSelf.shopAddressTf.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
        };
        //
        
    }
    return _addressPicker;
    
}

//--//
- (void)tl_placeholderOperation {

    [TLProgressHUD showWithStatus:nil];
    [[ZHShop shop] getShopTypeSuccess:^{
        
        [self removePlaceholderView];
        //1.获取店铺类型
        //2.获取店铺信息
        //
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:self.bgScrollView];
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        
        //
        [self UI];
        
        //
        [self shopDetailUI];
        
        //
        [self addEvent];
        
        //
        [self initData];
        
        [TLProgressHUD dismiss];

    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        [TLProgressHUD dismiss];

    }];
    

}


#pragma mark- 去定位
- (void)goMap {

    ZHMapController *mapVC = [[ZHMapController alloc] init];
    [mapVC setConfirm:^(CLLocationCoordinate2D point,NSString *detailAddress){
        
        self.longitude = [NSString stringWithFormat:@"%.14lf",point.longitude];
        self.latitude = [NSString stringWithFormat:@"%.14lf",point.latitude];
        
        self.gpsView.bottomLbl.text = [NSString stringWithFormat:@"Lng:%@ Lat:%@",[NSString stringWithFormat:@"%.2lf",point.longitude],[NSString stringWithFormat:@"%.2lf",point.latitude]];
        
    }];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

#pragma mark- 添加店铺封面
- (void)addShopViewImg {

    __weak typeof(self) weakself = self;
    _pickerVC = [[TLImagePicker alloc] initWithVC:self];
    _pickerVC.pickFinish = ^(NSDictionary *info){
        
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
//        NSData *imgData = UIImageJPEGRepresentation(image, ZIP_COEFFICIENT);
      

        [TLProgressHUD showWithStatus:nil];
        [image zipBegin:^{
            
            [TLProgressHUD dismiss];
            
            
        } end:^(UIImage *newImg) {
            
            weakself.coverImgChanged = YES;
            weakself.shopCoverView.tmpImageView.hidden = NO;
            weakself.shopCoverView.tmpImageView.image = newImg;
            
        }];
    };
    
    [_pickerVC picker];

}

#pragma mark- 选择店铺类型
//- (void)chooseShopType {
//
//    
//    ZHShopTypeChooseVC *vc = [[ZHShopTypeChooseVC alloc] init];
//    vc.selectedType = ^(NSString *typeName,NSString *code){
//        
//        self.shopType = code;
//        self.shopTypeView.bottomLbl.text = [NSString stringWithFormat:@"店铺类型: %@",typeName];
//    };
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)addInfo {

//    CDSignAContractInfoVC *vc = [[CDSignAContractInfoVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ZHSJIntroduceVC *vc = [[ZHSJIntroduceVC alloc] init];
    vc.type = IntroduceInfoSignAContractInfo;
    [self.navigationController pushViewController:vc animated:YES];

    
}

#pragma mark- 添加各种事件
- (void)addEvent {

    //
    [self.shopCoverView addTarget:self action:@selector(addShopViewImg) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.gpsView addTarget:self action:@selector(goMap) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.signAContractView addTarget:self action:@selector(addInfo) forControlEvents:UIControlEventTouchUpInside];
    //
    
//    [self.shopTypeView addTarget:self action:@selector(chooseShopType) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark-初始化店铺数据
- (void)initData {

    if (![ZHShop shop].isHasShop) {
        
        self.title = @"店铺装修";
        return;
    }

        self.title = @"店铺装修";

//        [[ZHShop shop].shopTypes  enumerateObjectsUsingBlock:^(ZHShopTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([obj.code isEqualToString:[ZHShop shop].type]) {
//                
//                self.shopTypeView.bottomLbl.text = obj.name; //code
//                
//            }
//            
//        }];
    
        self.shopTypeView.bottomLbl.text = @"礼品商"; //code
        self.shopType = [ZHShop shop].type;
        //
        self.shopNameTf.text = [ZHShop shop].name;
        self.shopCoverView.tmpImageView.hidden = NO;
        
        NSString *coverImgStr = [[ZHShop shop].advPic convertThumbnailImageUrl];
        [self.shopCoverView.tmpImageView sd_setImageWithURL:[NSURL URLWithString:coverImgStr]];
        self.referrerMobileTf.text = [ZHShop shop].refereeMobile;
        self.referrerMobileTf.enabled = NO;
        self.leagleNameTf.text = [ZHShop shop].legalPersonName;
        
        //详情图片
        self.shopDetailView.images = [ZHShop shop].detailPics.mutableCopy;
        self.shopDetailView.detailTextView.text = [ZHShop shop].descriptionShop;

        //位置信息
        self.shopAddressTf.text = [[[ZHShop shop].province add:[ZHShop shop].city] add:[ZHShop shop].area];
        self.province = [ZHShop shop].province;
        self.city = [ZHShop shop].city;
        self.area = [ZHShop shop].area;
        self.detailAddressTf.text = [ZHShop shop].address;
        self.longitude = [ZHShop shop].longitude;
        self.latitude = [ZHShop shop].latitude;
        
        //位置视图
        self.gpsView.bottomLbl.text = [self handleLng:self.longitude lat:self.latitude];
        
        self.shopPhoneTf.text = [ZHShop shop].bookMobile;
        self.smsPhoneTf.text = [ZHShop shop].smsMobile;

        self.sloganTextView.text = [ZHShop shop].slogan;
        
        
    
    

}

- (NSString *)handleLng:(NSString *)lng lat:(NSString *)lat {

    NSString *newLng = lng;
    NSString *newLat = lat;
    if (lng.length > 5 && lat.length > 5) {
       
        newLng = [lng substringToIndex:5];
        newLat = [lat substringToIndex:5];
    }
 
    return [NSString stringWithFormat:@"Lng:%@ Lat:%@",newLng,newLat];

}
#pragma mark- 店铺信息验证
- (BOOL)valitInput {
    
    if (!self.shopCoverView.tmpImageView.image) {
        [TLAlert alertWithHUDText:@"请选择店铺封面"];
        return NO;
    }
    
    if (!(self.shopType && self.shopType.length > 0)) {
        [TLAlert alertWithHUDText:@"请选择店铺类型"];
        return NO;
    }
    
    if (![self.shopNameTf.text valid]) {
        [TLAlert alertWithHUDText:@"请填写店铺名称"];
        return NO;
    }
    
    //
    if (![self.shopAddressTf.text valid]) {
        [TLAlert alertWithHUDText:@"请选择店铺地区"];
        return NO;
    }
    
    if (![self.detailAddressTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入店铺详细地址"];
        return NO;
        
    }
    
    if (![self.shopPhoneTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入联系电话"];
        return NO;
        
    }
    
    //
    if (![self.smsPhoneTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入短信手机号"];
        return NO;
        
    }
    
    //定位
    if(![self.longitude valid] || ![self.latitude valid]){
        [TLAlert alertWithHUDText:@"请对店铺进行定位"];
        return NO;
    }
    

    
    if (![self.sloganTextView.text valid]) {
        [TLAlert alertWithHUDText:@"请输入广告语"];
        return NO;
    }
    
    if (![self.leagleNameTf.text valid]) {
        [TLAlert alertWithHUDText:@"请输入法人姓名"];
        return NO;
    }
    
    if (![self.referrerMobileTf.text valid]) {
        [TLAlert alertWithHUDText:@"请输入推荐人账号"];
        return NO;
    }
    
//    if (![self.discountRateTf.text valid]) {
//        [TLAlert alertWithHUDText:@"请填写使用抵扣券分成比例"];
//        return NO;
//    }
//    if (![self.rateTf.text valid]) {
//        [TLAlert alertWithHUDText:@"请填写不使用抵扣券分成比例"];
//        return NO;
//    }
//    
//    
//    if ([self.discountRateTf.text floatValue] > 100.0) {
//        
//        [TLAlert alertWithHUDText:@"分成比例不能超过100%"];
//        return NO;
//    }
//    
//    if ([self.rateTf.text floatValue] > 100.0) {
//        
//        [TLAlert alertWithHUDText:@"分成比例不能超过100%"];
//        return NO;
//    }
    
    
    if (![self.shopDetailView.detailTextView.text valid]) {
        [TLAlert alertWithHUDText:@"请填写店铺详细信息"];
        return NO;
    }
    
    if (self.shopDetailView.images.count <= 0 || self.shopDetailView.images.count >=4) {
        [TLAlert alertWithHUDText:@"请选择1~3张店铺详情图片"];
        return NO;
    }
    return YES;
}

#pragma mark- 保存事件
- (void)save {
    
    if (![self valitInput]) {
        return;
    }
    
    UIImage *coverImg = self.shopCoverView.tmpImageView.image;
    
    _uploadGroup = dispatch_group_create();
    
    //元素为已上传的图片，可能为 0
    __block NSMutableArray <NSString *>*detailImagUrls = [NSMutableArray array];
    
    //元素为未上传的图片，可能为 0
    __block  NSMutableArray <UIImage *>*detailImgs = [NSMutableArray array];
    
    //上传成功 的key
    __block  NSMutableArray <NSString *>*detailImgsUploadSuccessKeys = [NSMutableArray array];
    
    [self.shopDetailView.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImage class]]) {
            
            self.detailImgsChanged = YES;
            [detailImgs addObject:obj];
            //第一张已经为[uiimage image] 后续肯定为Img
            if(idx == 0) {
                *stop = YES;
                detailImgs = self.shopDetailView.images;
            }
            
        } else {
            
            [detailImagUrls addObject:obj];
            
        }
        
    }];
    
    if (detailImagUrls) {
        detailImgsUploadSuccessKeys = [NSMutableArray arrayWithArray:detailImagUrls];
    }
    
    
    NSString *coverImgKey = [TLUploadManager imageNameByImage:coverImg];
    __block NSString *coverImgSuccessKey;
    
    
    //需要上传图片
    if (self.coverImgChanged || self.detailImgsChanged) {//----------
        
        TLNetworking *getUploadToken = [TLNetworking new];
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
                NSData *data =  UIImageJPEGRepresentation(coverImg, 1);
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
                coverImgSuccessKey = [ZHShop shop].advPic;
            }
            
            dispatch_group_t group  = _uploadGroup;
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                [TLProgressHUD dismiss];
                
                if (!coverImgSuccessKey) {
                    return ;
                }
                
                if (detailImgsUploadSuccessKeys.count != self.shopDetailView.images.count) {
                    return;
                }
                
                [self upLoadImageSuccess:coverImgSuccessKey detailImageKeys:[detailImgsUploadSuccessKeys componentsJoinedByString:@"||"]];
                
            });
            
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        //上传图片
        [self upLoadImageSuccess:[ZHShop shop].advPic detailImageKeys:[detailImagUrls componentsJoinedByString:@"||"]];
        
    }
    
}

#pragma mark- 提交信息
- (void)upLoadImageSuccess:(NSString *)coverImageKey detailImageKeys:(NSString *)detailImgKeys {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if ([ZHShop shop].code) {
        http.code = SHOP_RE_ADD; //重新提交
        http.parameters[@"code"] = [ZHShop shop].code;
        http.parameters[@"updater"] = [ZHUser user].userId;
        
    } else {
        
        http.code = SHOP_ADD; //第一次提交
        
    }
    
    http.parameters[@"advPic"] = coverImageKey; //封面
    http.parameters[@"type"] = self.shopType;
    http.parameters[@"name"] = self.shopNameTf.text;
    
    http.parameters[@"province"] = self.province;
    http.parameters[@"city"] = self.city;
    http.parameters[@"area"] = self.area;
    
    http.parameters[@"address"] = self.detailAddressTf.text; //详细地址
    http.parameters[@"longitude"] = self.longitude; //经度
    http.parameters[@"latitude"] = self.latitude; //纬度
    http.parameters[@"bookMobile"] = self.shopPhoneTf.text; //订购电话
    http.parameters[@"smsMobile"] = self.smsPhoneTf.text;  //短信电话
    http.parameters[@"slogan"] = self.sloganTextView.text; //广告语
    
    http.parameters[@"legalPersonName"] = self.leagleNameTf.text; //法人
    http.parameters[@"userReferee"] = self.referrerMobileTf.text;//推荐人
    
    //1%
//    http.parameters[@"rate1"] = @"0.01";
    
//    [NSString stringWithFormat:@"%.4f",[self.discountRateTf.text floatValue]/100.0];//使用抵扣券分成比例
    
//    http.parameters[@"rate2"] = @"0.10";
//    [NSString stringWithFormat:@"%.4f",[self.rateTf.text floatValue]/100.0]; //不使用抵扣券 分成比例
    
    http.parameters[@"pic"] = detailImgKeys; //店铺图片
    http.parameters[@"description"] = self.shopDetailView.detailTextView.text; //描述
    http.parameters[@"token"] = [ZHUser user].token;
    http.parameters[@"owner"] = [ZHUser user].userId;
    
    //
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"提交成功,我们将会对您的店铺进行审核"];
        [self.navigationController popViewControllerAnimated:YES];
        
        [[ZHShop shop] getShopInfoSuccess:^(NSDictionary *shopDict) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kShopInfoChange object:nil];
            
        } failure:^(NSError *error) {
            
            
        }];
        if (self.success) {
            self.success();
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)chooseAddress {

    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];

}

- (void)shopDetailUI {
//
//    UILabel *hinLbl = [UILabel labelWithFrame:CGRectMake(15, self.signAContractView.yy, SCREEN_WIDTH - 15, 50)
//                                 textAligment:NSTextAlignmentLeft
//                              backgroundColor:[UIColor whiteColor]
//                                         font:FONT(15)
//                                    textColor:[UIColor themeColor]];
//    [self.bgScrollView addSubview:hinLbl];
//    hinLbl.text = @"店铺描述";
    
    //
    ZHGoodsDetailEditView *shopDetailView = [[ZHGoodsDetailEditView alloc] initWithFrame:CGRectMake(0, self.signAContractView.yy, SCREEN_WIDTH, 200)];
    shopDetailView.placholder = @"请就关于您的店铺做一些20字以上60字以内的简单描述";
    shopDetailView.typeNameLbl.text = @"店铺描述";
    [self.bgScrollView addSubview:shopDetailView];
    self.shopDetailView = shopDetailView;
    //
//    店铺装修-提示
    UIImageView *hintImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, shopDetailView.yy + 25, 12, 12)];
    [self.bgScrollView addSubview:hintImageV];
    hintImageV.image = [UIImage imageNamed:@"店铺装修-提示"];
    
    //
    UILabel *hinInfoLbl = [UILabel  labelWithFrame:CGRectMake(hintImageV.xx + 9, hintImageV.y - 2, SCREEN_WIDTH - 35, 28)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:FONT(11)
                                         textColor:[UIColor zh_textColor2]];
    
    [self.bgScrollView addSubview:hinInfoLbl];
    hinInfoLbl.numberOfLines = 2;
    hinInfoLbl.text = @"添加店铺详情图片,最少一张,最多三张\n建议尺寸：690px,纵向无限制";
    //    self.shopDetailView = shopDetailView;
    
    
    //按钮
    UIButton *btn = [UIButton zhBtnWithFrame:CGRectMake(15, hinInfoLbl.yy + 20, SCREEN_WIDTH - 30, 45) title:@"本店已阅读签约协议,清楚并理解全部信息条款\n承诺遵守各项法律法规在此平台合法经营"];
    [self.bgScrollView addSubview:btn];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = FONT(11);
    
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, btn.yy + 20);
    
    
}

//
- (void)UI {

    //名称
    self.shopNameTf = [self tfWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) leftTitle:@"店铺名称" placeholder:@"请输入店铺名称"];
    [self.bgScrollView addSubview:self.shopNameTf];
    
    //
    self.shopAddressTf = [self tfWithFrame:CGRectMake(0, self.shopNameTf.yy, SCREEN_WIDTH, 50) leftTitle:@"省/市/区(县)" placeholder:@"请选择省市区"];
    [self.bgScrollView addSubview:self.shopAddressTf];
    self.shopAddressTf.enabled = NO;
    
    UIButton *chooseAddressBtn = [[UIButton alloc] initWithFrame:self.shopAddressTf.frame];
    [self.bgScrollView addSubview:chooseAddressBtn];
    [chooseAddressBtn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //详细地址
    self.detailAddressTf = [self tfWithFrame:CGRectMake(0,  self.shopAddressTf.yy, SCREEN_WIDTH, 50) leftTitle:@"详细地址" placeholder:@"只需输入街道门牌号"];
    [self.bgScrollView addSubview:self.detailAddressTf];
    
    //联系电话
    self.shopPhoneTf = [self tfWithFrame:CGRectMake(0,  self.detailAddressTf.yy, SCREEN_WIDTH, 50) leftTitle:@"联系电话" placeholder:@"手机号码或固定电话（请填写区号）"];
    [self.bgScrollView addSubview:self.shopPhoneTf];
    self.shopPhoneTf.keyboardType = UIKeyboardTypeNumberPad;

    //
    self.smsPhoneTf = [self tfWithFrame:CGRectMake(0,  self.shopPhoneTf.yy, SCREEN_WIDTH, 50) leftTitle:@"短信电话" placeholder:@"请输入短信手机号"];
    [self.bgScrollView addSubview:self.smsPhoneTf];
    self.smsPhoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //广告语
    self.sloganTf = [self tfWithFrame:CGRectMake(0,  self.smsPhoneTf.yy, SCREEN_WIDTH, 50) leftTitle:@"广告语" placeholder:@"请简单描述自己的店铺"];
    [self.bgScrollView addSubview:self.sloganTf];
    self.sloganTf.enabled = NO;
    //
    self.sloganTf.height = 70;
    self.sloganTextView = [[TLTextView alloc] initWithFrame:CGRectMake(105, self.sloganTf.y, SCREEN_WIDTH - 105, self.sloganTf.height - 1)];
    [self.bgScrollView addSubview:self.sloganTextView];
    self.sloganTextView.font = FONT(14);
    self.sloganTextView.placeholderLbl.font = self.sloganTextView.font;
    self.sloganTextView.textColor =  self.sloganTf.textColor;
    self.sloganTextView.placholder = @"请简单描述自己的店铺";
    
    //法人
    self.leagleNameTf = [self tfWithFrame:CGRectMake(0,  self.sloganTf.yy, SCREEN_WIDTH, 50) leftTitle:@"法人姓名" placeholder:@"店铺法人姓名"];
    [self.bgScrollView addSubview:self.leagleNameTf];

    //推荐人
    self.referrerMobileTf = [self tfWithFrame:CGRectMake(0,  self.leagleNameTf.yy, SCREEN_WIDTH, 50) leftTitle:@"推荐人" placeholder:@"输入推荐人手机号"];
    [self.bgScrollView addSubview:self.referrerMobileTf];
    self.referrerMobileTf.keyboardType = UIKeyboardTypeNumberPad;

    
    
    //四大块
    //店铺封面
    self.shopCoverView = [[CDShopFitUpView alloc] initWithFrame:CGRectMake(0, self.referrerMobileTf.yy, SCREEN_WIDTH/2.0, 90)];
    [self.bgScrollView addSubview:self.shopCoverView];
    self.shopCoverView.topImageView.image = [UIImage imageNamed:@"店铺装修-封面"];
    self.shopCoverView.bottomLbl.text = @"店铺封面";
    
    
    //
    self.gpsView = [[CDShopFitUpView alloc] initWithFrame:CGRectMake(self.shopCoverView.xx, self.shopCoverView.y, SCREEN_WIDTH/2.0, self.shopCoverView.height)];
    [self.bgScrollView addSubview:self.gpsView];
    self.gpsView.topImageView.image = [UIImage imageNamed:@"店铺装修-GPS"];
    self.gpsView.bottomLbl.text = [self handleLng:@"--" lat:@"--"];

    //
    self.signAContractView = [[CDShopFitUpView alloc] initWithFrame:CGRectMake(0, self.gpsView.yy, SCREEN_WIDTH/2.0, self.shopCoverView.height)];
    [self.bgScrollView addSubview:self.signAContractView];
    self.signAContractView.topImageView.image = [UIImage imageNamed:@"店铺装修-签约信息"];
    self.signAContractView.bottomLbl.text = @"签约信息";
    
    
    //
    self.shopTypeView = [[CDShopFitUpView alloc] initWithFrame:CGRectMake(self.signAContractView .xx, self.signAContractView.y, SCREEN_WIDTH/2.0, self.shopCoverView.height)];
    [self.bgScrollView addSubview:self.shopTypeView];
    self.shopTypeView.topImageView.image = [UIImage imageNamed:@"店铺装修-行业"];
    self.shopTypeView.bottomLbl.text = @"无实体店铺,可选择网站";

    //
    
    //toplLine
    UIColor *lineColor = [UIColor themeColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.shopCoverView.y, SCREEN_WIDTH, LINE_HEIGHT)];
    topLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:topLine];
    
    
    //middleLIne
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.signAContractView.y, SCREEN_WIDTH, LINE_HEIGHT)];
    middleLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:middleLine];
    
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.signAContractView.yy - LINE_HEIGHT, SCREEN_WIDTH, LINE_HEIGHT)];
    bottomLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:bottomLine];
    
    //竖线
    UIView *yLine = [[UIView alloc] init];
    yLine.backgroundColor = lineColor;
    [self.bgScrollView addSubview:yLine];
    [yLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topLine.mas_top);
        make.bottom.equalTo(bottomLine.mas_bottom);
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.width.mas_equalTo(LINE_HEIGHT);
        
    }];


}


- (TLTextField *)tfWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle placeholder:(NSString *)placeholder {

    TLTextField *tf = [[TLTextField alloc] initWithframe:frame leftTitle:leftTitle titleWidth:110 placeholder:placeholder];
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


@end
