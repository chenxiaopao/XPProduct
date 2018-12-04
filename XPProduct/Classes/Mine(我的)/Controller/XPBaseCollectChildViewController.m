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
#import <MJRefresh/MJRefresh.h>
#import "XPSaleDetailViewController.h"
#import "XPMineSaleDetailViewController.h"
#import "XPBuyDetailViewController.h"
#import "XPNetWorkTool.h"
#import <MJExtension/MJExtension.h>
#import "XPCollectBrowseModel.h"
#import "XPPurchaseModel.h"
#import "XPAlertTool.h"
#import "XPSupplyModel.h"
#import "XPNoDataTableViewCell.h"
@interface XPBaseCollectChildViewController () <UITableViewDelegate,UITableViewDataSource>

@end

static NSString *const collectBuyCellID=@"collectBuyCellID";
static NSString *const collectSaleCellID=@"collectSaleCellID";

@implementation XPBaseCollectChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"refreshing" object:nil];
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"supplyRefreshing" object:nil];
    [self setTableView];
    [self setRefreshView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData{
    
    if (self.isBuy){
        [self refreshBuyData];
    }else{
        [self refreshSaleData];
    }
}

- (void)refreshSaleData{
    
    NSDictionary *dict = @{
                           @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"state":@"1",
                           @"tableType":@(self.type),
                           @"type":@"1"
                           };
    __weak typeof(self)  weakSelf = self;
    [XPSupplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"purchase_id",
                 @"user_id":@"purchase_userId",
                 @"state":@"purchase_state"
                 };
    }];
    
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(id obj) {
        
        weakSelf.dataArr = [XPSupplyModel mj_objectArrayWithKeyValuesArray:obj];
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)refreshBuyData{

    
    NSDictionary *dict = @{
                           @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"state":@"1",
                           @"tableType":@(self.type),
                           @"type":@"0"
                           };
    __weak typeof(self)  weakSelf = self;
    [XPPurchaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"purchase_id",
                 @"user_id":@"purchase_userId",
                 @"state":@"purchase_state"
                 };
    }];
    
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(id obj) {
        
        weakSelf.dataArr = [XPPurchaseModel mj_objectArrayWithKeyValuesArray:obj];
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)setTableView{
    CGFloat height = XP_SCREEN_HEIGHT-(XP_NavBar_Height)-50;
    if (IS_IPHONE_X){
        height = height - XP_BottomBar_Height;
    }
    CGRect frame = CGRectMake(0, 0, XP_SCREEN_WIDTH, height);
    
    UITableView *tableView =  [[UITableView alloc]initWithFrame:frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XPNoDataTableViewCell" bundle:nil] forCellReuseIdentifier: @"noDataCell"];
    if (self.isBuy){
        [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:collectSaleCellID];
    }else{
        [tableView registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:collectBuyCellID];
        
    }
   
    
    
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - UITableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0){
        return 1;
    }
    return self.dataArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBuy){
        return 135;
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > 0){
        if (self.isBuy){
            XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectSaleCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataArr[indexPath.row];
            
            return cell;
        }else{
            XPBuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectBuyCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataArr[indexPath.row];
            return cell;
            
        }
    }else{
        XPNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > 0){
        if (self.isBuy){
            XPSaleDetailViewController *vc = [[XPSaleDetailViewController alloc]initWithModel:self.dataArr[indexPath.row]];
            [self.parentViewController.navigationController pushViewController:vc animated:NO];
            
        }else{
            XPBuyDetailViewController *vc = [[XPBuyDetailViewController alloc]initWithhSupplyModel:self.dataArr[indexPath.row]];
            [self.parentViewController.navigationController pushViewController:vc animated:NO];
        }
    }
    
}



@end

