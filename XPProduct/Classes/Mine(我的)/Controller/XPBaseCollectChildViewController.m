//
//  XPBaseCollectChildViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseCollectChildViewController.h"
#import "XPConst.h"
#import "XPSaleInfoTableViewCell.h"
#import "XPBuyInfoTableViewCell.h"
#import "MJRefresh.h"
#import "XPSaleDetailViewController.h"
#import "XPMineSaleDetailViewController.h"
#import "XPBuyDetailViewController.h"
@interface XPBaseCollectChildViewController () <UITableViewDelegate,UITableViewDataSource>

@end

static NSString *const collectBuyCellID=@"collectBuyCellID";
static NSString *const collectSaleCellID=@"collectSaleCellID";

@implementation XPBaseCollectChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setTableView];
    [self setRefreshView];
}



- (void)setRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)getData{
    
    if (self.isBuy){
        self.dataArr = [NSMutableArray arrayWithArray: @[@"1"]];
    }else{
        self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1"]];
    }
    
}

- (void)setTableView{
    UITableView *tableView =  [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    if (self.isBuy){
        [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:collectSaleCellID];
    }else{
        [tableView registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:collectBuyCellID];
        
    }
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - UITableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBuy){
        return 135;
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBuy){
        XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectSaleCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        XPBuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectBuyCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBuy){
        XPSaleDetailViewController *vc = [[XPSaleDetailViewController alloc]init];
        [self.parentViewController.navigationController pushViewController:vc animated:NO];
        
    }else{
        XPBuyDetailViewController *vc = [[XPBuyDetailViewController alloc]init];
        [self.parentViewController.navigationController pushViewController:vc animated:NO];
    }
}



@end

