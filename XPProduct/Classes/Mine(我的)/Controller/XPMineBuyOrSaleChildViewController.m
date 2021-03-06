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
#import "XPSupplyModel.h"
#import "XPNoDataTableViewCell.h"
@interface XPMineBuyOrSaleChildViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,assign) CGFloat height;
@end
static NSString *const mineBuyCellID = @"mineBuyCellID";
static NSString *const mineSaleCellID = @"mineSaleCellID";

@implementation XPMineBuyOrSaleChildViewController

- (instancetype)initWithUser_Id:(NSInteger)user_id andHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.height = height;
        self.user_id = user_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    [self setTableView];
    [self setRefreshView];
        
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)setRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadSupplyInfoWithState:(NSString *)state andUser_ID:(NSString *)user_id{
    __weak typeof(self) weakSelf = self;
    [XPSupplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    [[XPNetWorkTool shareTool]loadSupplyInfoWithId:0 User_id:user_id andState:state andCallBack: ^(NSArray *modelArr,NSError *error) {
        if (error == nil){
            if (modelArr.count>0){
                weakSelf.dataArr =  [XPSupplyModel mj_objectArrayWithKeyValuesArray:modelArr];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.dataArr = nil;
                [weakSelf.tableView reloadData];
                [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"没有您要找的数据o(╥﹏╥)o"];
            }
        }
        
    }];
}



- (void)loadPurchaseInfoWithState:(NSString *)state andUser_ID:(NSString *)user_id{
    __weak typeof(self) weakSelf = self;
    [XPPurchaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    [[XPNetWorkTool shareTool] loadPurchaseInfoWithUser_id:user_id andState:state andName:nil CallBack:^(NSArray *modelArr, NSError *error) {
        if (error == nil){
            if (modelArr.count>0){
                weakSelf.dataArr =  [XPPurchaseModel mj_objectArrayWithKeyValuesArray:modelArr];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.dataArr = nil;
                [weakSelf.tableView reloadData];
                [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"没有您要找的数据o(╥﹏╥)o"];
                
            }
            
        }
   
    }];
}

- (void)refreshData{
    NSString *state = [NSString stringWithFormat:@"%ld",(long)self.type];
    NSString *user_id;
    if (self.user_id!=0){
        user_id = [NSString stringWithFormat:@"%ld",(long)self.user_id];
    }else{
        user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    }
    
    if (self.isBuy){
        [self loadPurchaseInfoWithState:state andUser_ID:user_id];
    }else{
        [self loadSupplyInfoWithState:state andUser_ID:user_id];
    }
     [self.tableView.mj_header endRefreshing];
}

- (void)setTableView{
    CGFloat height;
    if (self.user_id != 0){
        height = self.height-50;
//        if (IS_IPHONE_X==1){
//            height = height - XP_BottomBar_Height;
//        }
    }else{
        height = XP_SCREEN_HEIGHT-(XP_NavBar_Height)-50;
//        if (IS_IPHONE_X==1){
//            height = height - XP_BottomBar_Height;
//        }

       
    }
    
    

    CGRect frame = CGRectMake(0, 0, XP_SCREEN_WIDTH, height);
    
    UITableView *tableView =  [[UITableView alloc]initWithFrame:frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XPNoDataTableViewCell" bundle:nil] forCellReuseIdentifier: @"noDataCell"];
    if (self.isBuy){
        [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:mineSaleCellID];
    }else{
        [tableView registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:mineBuyCellID];
        
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
            XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineSaleCellID forIndexPath:indexPath];
            cell.model = self.dataArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            XPBuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineBuyCellID forIndexPath:indexPath];
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
        if (self.isBuy){//是采购
            XPMineSaleDetailViewController *vc = [[XPMineSaleDetailViewController alloc]initWithModel:self.dataArr[indexPath.row]];

            vc.type =  self.type;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            XPMineBuyDetailViewController *vc = [[XPMineBuyDetailViewController alloc]initWithhSupplyModel:self.dataArr[indexPath.row]];

            vc.type =  self.type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
