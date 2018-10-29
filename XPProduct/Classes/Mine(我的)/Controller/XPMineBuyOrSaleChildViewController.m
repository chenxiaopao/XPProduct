//
//  XPMineBuyOrSaleChildViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/3.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineBuyOrSaleChildViewController.h"
#import "MJRefresh.h"
#import "XPSaleInfoTableViewCell.h"
#import "XPBuyInfoTableViewCell.h"
#import "XPMineSaleDetailViewController.h"
#import "XPMineBuyDetailViewController.h"
#import "XPConst.h"
#import "XPNetWorkTool.h"
#import "MJExtension.h"
#import "XPPurchaseModel.h"
#import "XPAlertTool.h"
@interface XPMineBuyOrSaleChildViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end
static NSString *const mineBuyCellID = @"mineBuyCellID";
static NSString *const mineSaleCellID = @"mineSaleCellID";
@implementation XPMineBuyOrSaleChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self setRefreshView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    
}

- (void)setRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
    
}




- (void)loadPurchaseInfoWithState:(NSString *)state andUser_ID:(NSString *)user_id{
    __weak typeof(self) weakSelf = self;
    [XPPurchaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    [[XPNetWorkTool shareTool] loadPurchaseInfoWithUser_id:user_id andState:state andName:nil CallBack:^(NSArray *modelArr, NSError *error) {
        if (error != nil){
            if (modelArr.count>0){
                weakSelf.dataArr =  [XPPurchaseModel mj_objectArrayWithKeyValuesArray:modelArr];
                //            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [weakSelf.tableView reloadData];
            }else{
                [XPAlertTool showAlertWithSupeView:self.view andText:@"没有您要找的数据o(╥﹏╥)o"];
                //            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            [weakSelf.tableView reloadData];
            }
        }
   
    }];
}

- (void)refreshData{
    if (self.isBuy){
        
        NSString *state = [NSString stringWithFormat:@"%ld",(long)self.type];
        NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        switch (self.type) {
               
            case XPMineBuyOrSaleCellTypeActive:
            {
                [self loadPurchaseInfoWithState:state andUser_ID:user_id];
            }
                break;
            case XPMineBuyOrSaleCellTypeInactive:
            {
                [self loadPurchaseInfoWithState:state andUser_ID:user_id];
            }
                break;
            case XPMineBuyOrSaleCellTypeDisabled:
            {

                [self loadPurchaseInfoWithState:state andUser_ID:user_id];
            }
                break;
        }
    }else{
        switch (self.type) {
            case XPMineBuyOrSaleCellTypeActive:
            {
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1"]];
            }
                break;
            case XPMineBuyOrSaleCellTypeInactive:
            {
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1"]];
            }
                break;
            case XPMineBuyOrSaleCellTypeDisabled:
            {
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"1"]];
            }
                break;
        }
    }
     [self.tableView.mj_header endRefreshing];
}

- (void)setTableView{
    UITableView *tableView =  [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    if (self.isBuy){
        [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:mineSaleCellID];
    }else{
        [tableView registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:mineBuyCellID];
        
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
        XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineSaleCellID forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        XPBuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineBuyCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isBuy){//是采购
     
        XPMineSaleDetailViewController *vc = [[XPMineSaleDetailViewController alloc]initWithModel:self.dataArr[indexPath.row]];
        vc.type =  self.type;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        XPMineBuyDetailViewController *vc = [[XPMineBuyDetailViewController alloc]init];
        vc.notCanSelected = YES;
        vc.type =  self.type;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
@end
