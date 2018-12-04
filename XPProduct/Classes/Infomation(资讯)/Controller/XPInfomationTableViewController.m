//
//  XPInfomationTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPInfomationTableViewController.h"
#import "XPBaseSearchTableViewController.h"
#import "XPInfoListTableViewController.h"
#import "UIImage+XPOriginImage.h"
#import "MJRefresh.h"
#import <MJExtension/MJExtension.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "XPInfoDetailViewController.h"
#import "XPInfoTableViewCell.h"
#import "XPNetWorkTool.h"
#import "XPMessDetailModel.h"
@interface XPInfomationTableViewController ()
@property (nonatomic,weak) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *infoCellDataArr;

@end

static NSString *InfoCellID = @"InfoCell";
static NSInteger page=1;
@implementation XPInfomationTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTableView];

}

- (void)setTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"XPInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];
    self.tableView.mj_footer = footer;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    page = 1;
}

- (void)pullUpRefresh{
    page += 1;
    [[XPNetWorkTool shareTool] loadInfoDetailWithPage:page DataFinish:^(id result, NSError *error) {
        
        NSArray *arr = [XPMessDetailModel mj_objectArrayWithKeyValuesArray:result];
        [self.infoCellDataArr addObjectsFromArray:arr];
       
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

    }];
}

- (void)pullDownRefresh{
    
    [[XPNetWorkTool shareTool] loadInfoDetailWithPage:1 DataFinish:^(id result, NSError *error) {
        self.infoCellDataArr = [XPMessDetailModel mj_objectArrayWithKeyValuesArray:result];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoCellDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.model = self.infoCellDataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XPMessDetailModel *model = self.infoCellDataArr[indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"http://www.qqncpw.cn%@",model.information_url];
    XPInfoDetailViewController *vc = [[XPInfoDetailViewController alloc]init];
    vc.path = path;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
