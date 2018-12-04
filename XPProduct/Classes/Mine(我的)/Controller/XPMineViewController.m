//
//  XPMineTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineViewController.h"
#import "XPMineMiddleCollectionViewCell.h"
#import "XPCollectViewController.h"
#import "XPMineBuyOrSaleViewController.h"
#import "XPMineCommentTableViewController.h"
#import "XPMineUserDetailTableViewController.h"
#import "UIImage+XPOriginImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XPMineViewController () <XPUnLoginViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *cellDataArr;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) XPUnLoginView *unLoginView;
@property (nonatomic,strong) NSArray *pushVcArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *arr;
@end

CGFloat const unLoginViewH = 220;
static NSString *const mineMiddleCellID = @"mineMiddleCellID";
@implementation XPMineViewController
#pragma mark - 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.itemSize = CGSizeMake((XP_SCREEN_WIDTH-40)/3, 50);;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, self.unLoginView.height-60, XP_SCREEN_WIDTH-20,50) collectionViewLayout:layout];
        collectionView.scrollEnabled = NO;
        collectionView.layer.cornerRadius = 5;
        collectionView.layer.masksToBounds = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerNib:[UINib nibWithNibName:@"XPMineMiddleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:mineMiddleCellID];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSArray *)pushVcArray{
    if (_pushVcArray == nil){
        _pushVcArray = @[@"XPMineBuyOrSaleViewController",@"XPMineBuyOrSaleViewController",@"XPMineFeedbackViewController",@"XPMineSettingTableViewController"];
    }
    return _pushVcArray;
}
- (NSArray *)cellDataArr{
    if (_cellDataArr == nil){
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"XPMineModelData" ofType:@"plist"];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        
       NSArray *modelArr = [XPMineModel mj_objectArrayWithKeyValuesArray:dictArr];
       _cellDataArr = modelArr;
        
    }
    return _cellDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr = @[@"我的收藏",@"浏览历史",@"我的评论"];
    [self addTableView];
    [self addUnLoginView];
    [self.unLoginView addSubview:self.collectionView];
    self.tableView.contentInset = UIEdgeInsetsMake(unLoginViewH, 0, 0, 0);


}

- (void)addUnLoginView{
    XPUnLoginView *unLoginView = [[XPUnLoginView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, unLoginViewH)];
    unLoginView.delegate = self;
    
    self.unLoginView = unLoginView;
    [self.view addSubview:unLoginView];
}
- (void)addTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    if iOS11_LATER {
        [tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else if iOS7_LATER{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView = tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat offset = self.unLoginView.height + scrollView.contentOffset.y;
    if (scrollView.contentOffset.y+unLoginViewH > 0){//上拉
        self.unLoginView.y = -offset;

    }else{//下拉
        self.unLoginView.height = -scrollView.contentOffset.y;
        self.collectionView.y = self.unLoginView.height-60;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init] ];
    self.unLoginView.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    [self.unLoginView.avatorView sd_setImageWithURL: [NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
}

#pragma mark - UITableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.frame = CGRectMake(0, 0, 30, 30);
        
    }
    XPMineModel *model = self.cellDataArr[indexPath.row];
    cell.textLabel.text=model.title;
    if (![model.subTitle isEqualToString:@""]){
        cell.detailTextLabel.text = model.subTitle;
    }
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{;
    UIViewController *vc = [NSClassFromString(self.pushVcArray[indexPath.row]) new];
    if (indexPath.row == 0){
        ((XPMineBuyOrSaleViewController *)vc).isBuy = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
  
}

#pragma mark - XPUnLoginViewDelegate
- (void)unLoginView:(XPUnLoginView *)unLoginView avatorViewClick:(UIView *)avatorView{
    XPMineUserDetailTableViewController *vc = [[XPMineUserDetailTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
 
}


#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XPMineMiddleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mineMiddleCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.arr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XPMineItemType type=-1;
    XPCollectViewController * collect = [[XPCollectViewController alloc]init];
    
    
    if (indexPath.item==0){
        type = XPMineItemTypeCollect;
        collect.type = type;
        [self.navigationController pushViewController:collect animated:YES];
    }else if (indexPath.item == 1){
        type = XPMineItemTypeHistory;
        collect.type = type;
        [self.navigationController pushViewController:collect animated:YES];
    }else{
        XPMineCommentTableViewController *vc = [[XPMineCommentTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
@end
