//
//  XPHomeViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyViewController.h"
#import "XPSearchView.h"
#import "XPBannerView.h"
#import "XPBuyTableView.h"
#import "XPBaseSearchTableViewController.h"
#import "MJRefresh.h"
#import "XPScreeningResultViewController.h"
#import "XPCategoryViewController.h"
#import "XPBuyPublishTableViewController.h"
#import "XPBuyDetailViewController.h"
#import "XPMineBuyOrSaleViewController.h"
#import "XPAlertTool.h"
#import "XPBannerView.h"
@interface XPBuyViewController () <XPSearchViewDelegate,XPBuyTableViewDelegate,XPBannerViewDelegate>
@property (nonatomic,weak) XPBuyTableView *tableView;
@property (nonatomic,weak) XPBannerView *bannerView;
@property (nonatomic,assign) CGFloat bannerViewHeight ;
@end

@implementation XPBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerViewHeight = 180;
    [self setSearchView];
    [self setTableView];
    [self setBannerView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.bannerView removeTimer];
    self.navigationController.navigationBar.translucent = YES;
    [super viewWillDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.bannerView addTimer];
    
}

- (void)setBannerView{
    
    XPBannerView *bannerView = [[XPBannerView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, self.bannerViewHeight)];
    bannerView.backgroundColor = [UIColor redColor];
    NSArray *imageArr = @[@"boluo",@"nihoutao",@"tudou",@"caomei"];
    bannerView.imageArr = imageArr;
    bannerView.delegate = self;
    self.bannerView = bannerView;
    [self.view addSubview:bannerView];
}

- (void)setTableView{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"XPBuyCategoryData" ofType:@"plist"];
    NSArray *categoryArr = [NSArray arrayWithContentsOfFile:path];

    XPBuyTableView *tableView = [[XPBuyTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped categoryData:categoryArr];
    tableView.buyDelegate = self;
    tableView.contentInset = UIEdgeInsetsMake(self.bannerViewHeight, 0, 0, 0);
    self.tableView = tableView;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_footer = footer;
    [self.view addSubview:tableView];
 
}

- (void)loadData{
    NSLog(@"shuaxin");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
    });

}

- (void)setSearchView{
    XPSearchView *searchView = [[XPSearchView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH-30, 44)];
    searchView.delegate = self;
    self.navigationItem.titleView = searchView;
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - XPBannerViewDelegate
- (void)bannerView:(XPBannerView *)bannerView didSelectedIndex:(NSInteger)index{
    NSLog(@"index:%ld",(long)index);
}

#pragma mark - XPbuyTableViewDelegate

- (void)buyTableViewDidScroll:(XPBuyTableView *)tableView{
    
    CGFloat startOffsetY = -self.bannerViewHeight;
    NSLog(@"%f***%f***%f",tableView.contentOffset.y,startOffsetY,self.bannerView.y);
    if (tableView.contentOffset.y <= 0.0){
        self.bannerView.y =startOffsetY - tableView.contentOffset.y;
    }
    if (tableView.contentOffset.y > 0){
        self.bannerView.y = startOffsetY;
    }
}

- (void)buyTableView:(XPBuyTableView *)tableView buyCollectionViewDidselected:(XPBuyColletionView *)collectionView didSelectdIndexPath:(NSIndexPath *)indexPath title:(NSString *)title isFirstCollectionView:(BOOL)isFirstCollectionView{
    XPScreeningResultViewController *vc = [[XPScreeningResultViewController alloc]init];
    vc.isSale = NO;
    if (isFirstCollectionView){
        switch (indexPath.row) {
            case 0:{
                XPBuyPublishTableViewController *vc = [[XPBuyPublishTableViewController alloc]init];
                [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:vc andSelectedIndex:0] ;
//                [self.navigationController pushViewController:[XPBuyPublishTableViewController new] animated:NO];
            }
                break;
            case 1:
            {
                XPMineBuyOrSaleViewController *vc = [[XPMineBuyOrSaleViewController alloc]init];
                vc.isBuy = YES;
                [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:vc andSelectedIndex:0];
//                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
                vc.categoryTitleArr = @[@"分类"];
                [self.navigationController pushViewController:vc animated:NO];
                break;
        }
    }else{
        if ([title isEqualToString:@"全部"]){
            [self.navigationController pushViewController:[[XPCategoryViewController alloc]init] animated:NO];
        }else{
            vc.categoryTitleArr = @[title];
            [self.navigationController pushViewController:vc animated:NO];
        }

    }
}

- (void)buyTableView:(XPBuyTableView *)tableView didSelectedIndexPath:(NSIndexPath *)indexPath{
    XPBuyDetailViewController *buy = [[XPBuyDetailViewController alloc]init];
    [self.navigationController pushViewController:buy animated:YES];
    NSLog(@"货品cell点击");
}


#pragma mark - XPSearchBarDelegate
- (void)searchView:(XPSearchView *)searchView{
    XPBaseSearchTableViewController *searchVC = [[XPBaseSearchTableViewController alloc]init];
    searchVC.historyDataKey = @"buyHistoryKey";
    searchVC.searchRecommendArr = @[@"柚子",@"西瓜",@"鸡"];
    __weak typeof(self) weakSelf = self;
    searchVC.pushBlock = ^(NSString *title) {
        XPScreeningResultViewController *vc =  [XPScreeningResultViewController new];
        vc.categoryTitleArr = @[title];
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
