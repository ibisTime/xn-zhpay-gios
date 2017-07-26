//
//  CDOneBillDetailVC.m
//  ZHBGift
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDOneBillDetailVC.h"
#import "ZHBillModel.h"
#import "CDBillDetailCell.h"

@interface CDOneBillDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *moneyChangeLbl;
@property (nonatomic, strong) UILabel *statusLbl; //状态Lbl

@property (nonatomic, copy) NSDictionary *dataDict;
@property (nonatomic, copy) NSArray <NSString *>*typeNames;


@end

@implementation CDOneBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    self.view.backgroundColor = [UIColor whiteColor];

    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:tv];
    tv.dataSource = self;
    tv.delegate = self;
    tv.rowHeight = 50;
    tv.backgroundColor = [UIColor whiteColor];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //
    tv.tableHeaderView = [self tableHeaderView];
    
    //
    NSArray *typeNames = @[@"描述说明",@"创建时间"];
    self.typeNames = typeNames;
    
    //
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    dataDict[typeNames[0]] = [self.billModel getBizName];
    dataDict[typeNames[1]] = [self.billModel.createDatetime convertToDetailDate];



    self.dataDict = dataDict;
    self.statusLbl.text = @"交易成功";
    self.moneyChangeLbl.text = [self.billModel.transAmount convertToRealMoney];
    
    
}

- (UIView *)tableHeaderView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    //
    self.moneyChangeLbl = [UILabel labelWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 30) textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(28)
                                        textColor:[UIColor textColor]];
    [headerView addSubview:self.moneyChangeLbl];
    
    //
    self.statusLbl = [UILabel labelWithFrame:CGRectMake(0, self.moneyChangeLbl.yy + 19, SCREEN_WIDTH, 30) textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(15)
                                        textColor:[UIColor textColor2]];
    [headerView addSubview:self.statusLbl];

    headerView.height = self.statusLbl.yy + 20;
    
    return headerView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CDBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[CDBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        
        cell.rightLbl.textColor = [UIColor textColor];
        
    } else {
    
        cell.rightLbl.textColor = [UIColor textColor2];

    }
    
    cell.leftLbl.text = self.typeNames[indexPath.row];
    cell.rightLbl.text = self.dataDict[self.typeNames[indexPath.row]];
    
    

    return cell;

}

@end
