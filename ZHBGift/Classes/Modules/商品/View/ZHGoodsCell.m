//
//  ZHGoodsCell.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/13.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsCell.h"
#import "ZHGoodsModel.h"
#import "ZHCategoryManager.h"
#import "ZHOrderModel.h"

@interface ZHGoodsCell()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *mainTextLbl;
@property (nonatomic, strong) UILabel *subTextLbl;
@property (nonatomic, strong) UILabel *stateLbl;
@property (nonatomic, strong) UILabel *timeLbl;


@end

@implementation ZHGoodsCell

+ (CGFloat)rowHeight {
    return 95.0;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageView.clipsToBounds = YES;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageView];
//        self.coverImageView.backgroundColor = [UIColor orangeColor];
      
        CGFloat w = SCREEN_WIDTH - self.coverImageView.xx - 20 - 70 - 10;
        self.mainTextLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 10, self.coverImageView.y + 5, w , [[UIFont secondFont] lineHeight] + 1)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor zh_textColor]];
        [self addSubview:self.mainTextLbl];
        
        
        self.subTextLbl =  [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 10, self.mainTextLbl.yy + 3, self.mainTextLbl.width , 20)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont thirdFont]
                                         textColor:[UIColor colorWithHexString:@"#999999"]];
       [self addSubview:self.subTextLbl];
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageView.xx + 10, self.subTextLbl.yy + 3, self.mainTextLbl.width , 20)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont thirdFont]
                                     textColor:[UIColor colorWithHexString:@"#999999"]];
        [self addSubview:self.timeLbl];
        
        self.stateLbl =  [UILabel labelWithFrame:CGRectMake(0, self.mainTextLbl.y, 70 , self.mainTextLbl.height)
                                      textAligment:NSTextAlignmentRight
                                   backgroundColor:[UIColor whiteColor]
                                              font:[UIFont secondFont]
                                         textColor:[UIColor colorWithHexString:@"#999999"]];
        [self addSubview:self.stateLbl];
        self.stateLbl.xx_size = SCREEN_WIDTH - 10;
        

        
        //
        [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mainTextLbl.mas_right);
//            make.right.greaterThanOrEqualTo(self.mainTextLbl.mas_right);
            
            make.top.equalTo(self.mainTextLbl.mas_top);
            make.right.equalTo(self.mas_right).offset(-5);
        }];
        
        //auto
        [self.mainTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.coverImageView.mas_right).offset(10);
            make.top.equalTo(self.coverImageView.mas_top).offset(5);
            
            make.right.lessThanOrEqualTo(self.stateLbl.mas_left);
            //            make.right.equalTo(self.stateLbl.mas_left);
        }];
        //
        [self.subTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTextLbl.mas_left);
            make.top.equalTo(self.mainTextLbl.mas_bottom).offset(5);
        }];
        
        //
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTextLbl.mas_left);
            make.top.equalTo(self.subTextLbl.mas_bottom).offset(5);
        }];
        
        [self.mainTextLbl setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.stateLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        self.stateLbl.text = @"审核不通过";
        
        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] rowHeight] - 0.7, SCREEN_WIDTH, 0.7)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        
    }
    
    return self;

}

- (void)setModel:(id)model {

    _model = model;
    
    if ([model isKindOfClass:[ZHGoodsModel class]]) {
        
        ZHGoodsModel *goodsM = (ZHGoodsModel *)model;
        
        NSURL *url = [NSURL URLWithString:[goodsM.advPic convertImageUrl]];
        [self.coverImageView sd_setImageWithURL:url placeholderImage:nil];
        self.mainTextLbl.text = goodsM.name;
        self.timeLbl.text = [goodsM.updateDatetime convertToDetailDate];
        
        self.subTextLbl.text = [[ZHCategoryManager manager] getNameByCategoryCode:goodsM.category];

//        @"0" : @"审核中",
//        @"1" : @"待上架",
//        
//        @"91" : @"不通过",
//        @"3" : @"已上架",
//        @"4" : @"已下架"
        
        self.stateLbl.textColor = [UIColor zh_textColor];

        if ([goodsM.status isEqualToString:@"0"]) { //待审核
            
            self.stateLbl.text = @"待审核";
            self.stateLbl.textColor = [UIColor colorWithHexString:@"#2e88ec"];
            
        } else if ([goodsM.status isEqualToString:@"91"]) { //审核通过
            
            self.stateLbl.text = @"不通过";
            self.stateLbl.textColor = [UIColor zh_themeColor];

        } else if ([goodsM.status isEqualToString:@"1"] || [goodsM.status isEqualToString:@"3"]) { //
        
            self.stateLbl.text = @"审核通过";
            self.stateLbl.textColor = [UIColor zh_textColor];

        } else if ([goodsM.status isEqualToString:@"4"]) { //下架
        
            self.stateLbl.text = @"下架";
            self.stateLbl.textColor = [UIColor zh_themeColor];

        }
        
        self.stateLbl.text = [_model getStatusName];
        
    } else { //订单
    
//        //1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
//        ZHOrderModel *goodsM = (ZHOrderModel *)model;
//
//        ZHOrderDetailModel *model = goodsM.productOrderList[0];
//        NSString *urlStr = [model.advPic convertThumbnailImageUrl];
//        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//        self.mainTextLbl.text = goodsM.code;
//        self.subTextLbl.text = [goodsM.applyDatetime convertToDetailDate];
//        
//        if ([goodsM.status isEqualToString:@"1"]) {
//            
//            self.stateLbl.text = @"待支付";
//            
//        } else if ([goodsM.status isEqualToString:@"2"]){
//            
//            self.stateLbl.text = @"待发货";
//            
//        }  else if ([goodsM.status isEqualToString:@"3"]){
//            
//            self.stateLbl.text = @"已发货";
//        } else if ([goodsM.status isEqualToString:@"4"]){
//            
//            self.stateLbl.text = @"已收货";
//            
//        } else if ([goodsM.status isEqualToString:@"91"]){
//            
//            self.stateLbl.text = @"用户取消";
//            
//        } else if  ([goodsM.status isEqualToString:@"92"]){
//        
//            self.stateLbl.text = @"商户取消";
//
//        
//        }
  
    
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
