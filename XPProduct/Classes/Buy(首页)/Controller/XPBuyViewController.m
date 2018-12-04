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
#import <SDWebImage/UIImageView+WebCache.h>
#import "XPNetWorkTool.h"
#import "XPSupplyModel.h"
#import <MJExtension/MJExtension.h>
@interface XPBuyViewController () <XPSearchViewDelegate,XPBuyTableViewDelegate,XPBannerViewDelegate>
@property (nonatomic,weak) XPBuyTableView *tableView;
@property (nonatomic,weak) XPBannerView *bannerView;
@property (nonatomic,assign) CGFloat bannerViewHeight ;
@property (nonatomic,strong) NSArray *bannerArr;
@end

@implementation XPBuyViewController

- (NSArray *)bannerArr{
    if(_bannerArr==nil){
        _bannerArr = @[@"菠萝",@"西瓜",@"柚子",@"草莓"];
    }
    return _bannerArr;
}

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
    [self.tableView.mj_header beginRefreshing];
}

- (void)setBannerView{
    
    XPBannerView *bannerView = [[XPBannerView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, self.bannerViewHeight)];
    bannerView.backgroundColor = [UIColor redColor];
    NSArray *imageArr = @[@"boluo",@"xigua",@"youzi",@"caomei"];
    bannerView.imageArr = imageArr;
    bannerView.delegate = self;
    self.bannerView = bannerView;
    [self.view addSubview:bannerView];
}

- (void)setTableView{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"XPBuyCategoryData" ofType:@"plist"];
    NSArray *categoryArr = [NSArray arrayWithContentsOfFile:path];

    XPBuyTableView *tableView = [[XPBuyTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped categoryData:categoryArr];
    tableView.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.buyDelegate = self;
    tableView.contentInset = UIEdgeInsetsMake(self.bannerViewHeight, 0, 0, 0);
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_header = header;
    [tableView.mj_header beginRefreshing];
    [self.view addSubview:tableView];
    
   
 
}

- (void)loadData{
    //进程间通信
    __weak typeof(self) weakSelf = self;
    [XPSupplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XPNetWorkTool shareTool] loadSupplyInfoWithId:0 User_id:@"0" andState:@"1"  andCallBack:^(id obj,NSError *error) {
            if (error == nil){
                 weakSelf.tableView.supplyArr = [XPSupplyModel mj_objectArrayWithKeyValuesArray:obj];
            }
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
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
    NSArray *arr = @[self.bannerArr[index]];
    XPScreeningResultViewController *Vc = [[XPScreeningResultViewController alloc]init];
    Vc.categoryTitleArr = arr;
    [self.navigationController pushViewController:Vc animated:YES];
}

#pragma mark - XPbuyTableViewDelegate

- (void)buyTableViewDidScroll:(XPBuyTableView *)tableView{
    
    CGFloat startOffsetY = -self.bannerViewHeight;
//    NSLog(@"%f***%f***%f",tableView.contentOffset.y,startOffsetY,self.bannerView.y);
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
    XPBuyDetailViewController *buy = [[XPBuyDetailViewController alloc]initWithhSupplyModel:tableView.supplyArr[indexPath.row]];
    [self.navigationController pushViewController:buy animated:YES];
    
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
