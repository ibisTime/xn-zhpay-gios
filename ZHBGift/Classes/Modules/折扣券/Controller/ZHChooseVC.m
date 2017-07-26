//
//  ZHChooseVC.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/20.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHChooseVC.h"

@interface ZHChooseVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,copy) NSArray *typeNames;
@end

@implementation ZHChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抵扣券类型";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.typeNames = @[@"满减",@"返现"];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedType) {
        self.selectedType(_typeNames[indexPath.row],indexPath.row + 1);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _typeNames.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *shopTypeId = @"shopTypeId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopTypeId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopTypeId];
        cell.textLabel.textColor = [UIColor zh_textColor];
        cell.textLabel.font = [UIFont secondFont];
    }
    cell.textLabel.text = _typeNames[indexPath.row];
    return cell;
    
}

@end
