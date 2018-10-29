//
//  XPSaleViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSaleViewController.h"
#import "XPSearchView.h"
#import "XPBaseSearchTableViewController.h"
#import "XPScreeningResultViewController.h"
#import "XPBuyColletionView.h"
#import "XPSaleInfoTableViewCell.h"
#import "XPSalePublishViewController.h"
#import "MJRefresh.h"
#import "XPSaleDetailViewController.h"
#import "XPMineBuyOrSaleViewController.h"
#import "XPNetWorkTool.h"
#import "XPPurchaseModel.h"
#import "XPAlertTool.h"
#import "MBProgressHUD.h"
@interface XPSaleViewController () <XPSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,XPBuyCollectionViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *categoryData;
@property (nonatomic,strong) UIView *sectionHeadView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *recommendArr;
@property (nonatomic,strong) NSString *selectedTitle;
@property (nonatomic,weak) UIButton *firstBtn;
@end

static  NSString *saleRecommendCellID = @"saleRecommendCellID";
@implementation XPSaleViewController
- (NSArray *)categoryData{
    if (_categoryData == nil){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"XPSaleCategoryData" ofType:@"plist"];
        _categoryData = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _categoryData;
}
- (UIView *)sectionHeadView{
    if (_sectionHeadView == nil){
        NSArray *recommendArr = @[@"柚子",@"葡萄",@"苹果",@"梨子",@"香蕉"];
        self.recommendArr = recommendArr;
        CGFloat width = (XP_SCREEN_WIDTH - 20)/5;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 40)];
        headView.backgroundColor = [UIColor whiteColor];
//        [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        for (int i=0; i<5; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+i*width, 0, width, 39)];
            [btn setTitle:recommendArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if (i == 0){
                [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                self.selectedTitle = self.recommendArr[i];
                self.firstBtn = btn;
            }
            [btn addTarget:self action:@selector(sectionHeaderViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:btn];
            
        }
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height-1, XP_SCREEN_WIDTH, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [headView addSubview:bottomLine];
        _sectionHeadView = headView;
    }
    return  _sectionHeadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchView];
    [self setTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.firstBtn){
        [self sectionHeaderViewBtnClick:self.firstBtn];
    }
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)sectionHeaderViewBtnClick:(UIButton *)btn{
    if (![btn.titleLabel.textColor isEqual:[UIColor greenColor]]){
        for (UIView *view in self.sectionHeadView.subviews) {
            if ([view isKindOfClass: [UIButton class]]){
                [((UIButton *)view) setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
        self.selectedTitle = btn.titleLabel.text;
        [self reloadDataByTitle:btn.titleLabel.text];
        
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
    }
}

- (void)reloadDataByTitle:(NSString *)title{
    __weak typeof(self) weakSelf = self;
    [XPPurchaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    
    [[XPNetWorkTool shareTool] loadPurchaseInfoWithUser_id:nil andState:nil andName:title CallBack:^(NSArray *modelArr, NSError *error) {
        if (!error){
            if (modelArr.count > 0){
                weakSelf.dataArr = [XPPurchaseModel mj_objectArrayWithKeyValuesArray:modelArr];
            }else{
                weakSelf.dataArr  = modelArr;
                [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"没有更多数据啦"];
            }
            
            [self.tableView reloadData];
        }else{
            [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"服务器连接失败"];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:saleRecommendCellID];
    self.tableView = tableView;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    tableView.mj_footer = footer;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView.mj_footer beginRefreshing];
    [self.view addSubview:tableView];
    
}

- (void)loadData{
    [self reloadDataByTitle:self.selectedTitle];
}

- (void)setSearchView{
    XPSearchView *searchView = [[XPSearchView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH-30, 44)];
    searchView.delegate = self;
    self.navigationItem.titleView = searchView;
    
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return  1;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSArray *dataArr = self.categoryData[indexPath.section];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = 80;
        CGFloat height = 80;
        CGFloat margin = (XP_SCREEN_WIDTH - 80*3 -2*10-20)/2;
        layout.sectionInset = UIEdgeInsetsMake(20, margin, 20, margin);
        
        static  NSString *buyCategoryID = @"buyCategoryID";
        layout.itemSize = CGSizeMake(width, height);
        
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:buyCategoryID];
        if (cell==nil){
            
            cell = [[UITableViewCell alloc]init];
            for (UIView *subView in cell.contentView.subviews) {
                [subView removeFromSuperview];
            }
            XPBuyColletionView *collectionView = [[XPBuyColletionView alloc]initWithFrame:CGRectMake(10, 0, XP_SCREEN_WIDTH-20, 120) collectionViewLayout:layout categoryData:dataArr];
            
            collectionView.collDelegate = self;
            [cell.contentView addSubview: collectionView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        return cell;
    }else{
        XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:saleRecommendCellID forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        XPSaleDetailViewController *vc = [[XPSaleDetailViewController alloc]initWithModel:self.dataArr[indexPath.row]];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 120;
    }
    return 135;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return self.sectionHeadView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0){
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0){
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,XP_SCREEN_WIDTH , 50)];
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, footerView.width, 10)];
        topLabel.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, footerView.width, 40)];
        bottomLabel.text = @"采购推荐";
        bottomLabel.textColor = [UIColor redColor];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:20];
        [footerView addSubview:topLabel];
        [footerView addSubview:bottomLabel];
        return footerView;
    }
    return [UIView new];
}


#pragma mark - XPSearchViewDelegate
- (void)searchView:(XPSearchView *)searchView{
    XPBaseSearchTableViewController *searchVC = [[XPBaseSearchTableViewController alloc]init];
    searchVC.historyDataKey = @"saleHistoryKey";
    __weak __typeof(self) weakSelf = self;
    searchVC.pushBlock = ^(NSString *title) {
        XPScreeningResultViewController *vc =  [XPScreeningResultViewController new];
        vc.categoryTitleArr = @[title];
        vc.isSale = YES;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - XPBuyCollectionViewDelegate
- (void)buyCollectionView:(XPBuyColletionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath title:(NSString *)title isFirstCollectionView:(BOOL)isFirstCollectionView{
    switch (indexPath.row) {
        case 0:
        {
            XPSalePublishViewController *vc = [[XPSalePublishViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 1:
        {
            XPMineBuyOrSaleViewController *vc = [[XPMineBuyOrSaleViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            XPScreeningResultViewController *vc = [[XPScreeningResultViewController alloc]init];
            vc.categoryTitleArr = @[@"分类"];
            vc.isSale = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
            
            break;
    }
    
}
@end
