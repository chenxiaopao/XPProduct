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
#import "XPInfoDetailViewController.h"
@interface XPInfomationTableViewController ()
@property (nonatomic,strong) NSMutableArray *infoCellDataArr;
@end

static NSString *InfoCellID = @"InfoCell";

@implementation XPInfomationTableViewController
- (NSMutableArray *)infoCellDataArr{
    if(_infoCellDataArr == nil){
        _infoCellDataArr = [NSMutableArray array];
        
    }
    return  _infoCellDataArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_me"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:InfoCellID];
    [self setNavView];
    [self setRefreshView];
    
}
- (void)setNavView{
    
    UIImage *image = [UIImage imageNamed:@"icon_search"];
    UIImage *blackImage = [image xp_imageWithColor:[UIColor blackColor]];
    UIImage *newImage =[blackImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:newImage style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick)];
    
    
    UIBarButtonItem *nullItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    self.navigationItem.rightBarButtonItems = @[nullItem,searchItem];
}
- (void)searchItemClick{
    XPBaseSearchTableViewController *searchVC = [[XPBaseSearchTableViewController alloc]init];
    searchVC.searchRecommendArr = @[@"大大",@"geg6",@"哈哈",@"嘻嘻"];
    __weak __typeof(self) weakSelf = self;
    searchVC.pushBlock = ^(NSString *title) {
        XPInfoListTableViewController *vc =  [XPInfoListTableViewController new];
        vc.searchTitle = title;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    searchVC.historyDataKey = @"infoHistoryKey";
    [self.navigationController pushViewController:searchVC animated:YES];}
- (void)setRefreshView{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(refreshOldData)];
    
}
- (void)refreshNewData{
    
    for (int i=0; i<10; i++) {
        
        [self.infoCellDataArr addObject:[NSString stringWithFormat:@"%d+++",i]];
        if (i ==9){
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }
    
}
- (void)refreshOldData{
    
        for (int i=10; i<20; i++) {
            
            [self.infoCellDataArr addObject:[NSString stringWithFormat:@"%d+++",i]];
            if (i ==19){
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoCellDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellID  forIndexPath:indexPath];
    cell.textLabel.text = self.infoCellDataArr[indexPath.row];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[XPInfoDetailViewController new] animated:YES];
}

@end
