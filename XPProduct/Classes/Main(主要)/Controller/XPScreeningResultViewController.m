//
//  XPScreeningResultViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPScreeningResultViewController.h"
#import "XPGraySearchView.h"
#import "XPCategoryView.h"
#import "Masonry.h"
#import "MenuScreeningView.h"
#import "UIButton+XPAdjustFont.h"
#import "XPBuyInfoTableViewCell.h"
#import "MJRefresh.h"
#import "XPSaleInfoTableViewCell.h"
#import "XPNetWorkTool.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "XPPurchaseModel.h"
#import "XPAlertTool.h"
#import "XPSupplyModel.h"
#import "XPSaleDetailViewController.h"
#import "XPBuyDetailViewController.h"
#import "XPConst.h"
@interface XPScreeningResultViewController () <XPCategoryViewDelagete,MenuScreeningViewDelegate,UITableViewDelegate,UITableViewDataSource,XPGraySearchViewDelegate>
@property (nonatomic,weak) XPCategoryView *categoryView;
@property (nonatomic,weak) UIButton *categoryBtn;
@property (nonatomic,weak) MenuScreeningView *menu;
@property (nonatomic,strong) NSDictionary *categoryData;
@property (nonatomic,strong) NSString *leftTitle;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,strong) NSMutableDictionary *requestData;
@property (nonatomic,weak) XPGraySearchView *searchView;
@end

static NSString *const XPBuyInfoTableViewCellID = @"XPBuyInfoTableViewCellID";
static NSString  *XPSaleInfoTableViewCellID = @"XPSaleInfoTableViewCellID";
@implementation XPScreeningResultViewController

- (NSMutableDictionary *)requestData{
    if(_requestData == nil){
        _requestData =[NSMutableDictionary dictionaryWithDictionary:@{@"category":@"类别",@"sort":@"默认排序",@"address":@"地区"}];
    }
    return _requestData;
}



- (NSDictionary *)categoryData{
    if (_categoryData == nil){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productCategoryContainAll" ofType:@"plist"];
        NSDictionary *categoryData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        _categoryData =categoryData;
    }
    return _categoryData;
}

- (XPCategoryView *)categoryView{
    if (_categoryView == nil){
        
        CGFloat height = CGRectGetMaxY(self.categoryBtn.frame);
        CGRect rect = CGRectMake(0, height, XP_SCREEN_WIDTH, (XP_SCREEN_HEIGHT)-40-(XP_NavBar_Height));
        XPCategoryView *categoryView = [[XPCategoryView alloc]initWithFrame:rect categoryData:self.categoryData];
        categoryView.delegate = self;
        _categoryView = categoryView;
        [self.view addSubview:_categoryView];
    }
    return _categoryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCategoryView) name:@"hideCategoryView" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitleView];
    [self setTableView];
    [self setRefreshView];
    [self setDropView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.categoryView hide];
    [self.menu menuScreeningViewDismiss];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRefreshView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefreshData)];
    self.tableView.mj_header = header;
}


- (void)pullDownRefreshData{
    NSString *name = [self.requestData objectForKey:@"category"];
    NSString *address = [self.requestData objectForKey:@"address"];
    NSString *sort = [self.requestData objectForKey:@"sort"];
    NSLog(@"%@,%@,%@",name,address,sort);
    __weak typeof(self) weakSelf = self;
    if (self.isSale){
        [XPPurchaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"_id":@"id"
                     };
        }];
        
        [[XPNetWorkTool shareTool] searchPurchaseInfoWithName:name andAddress:address andSort:sort andCallBack:^(NSArray *modelArr) {
            if (modelArr.count > 0){
                weakSelf.dataArr = [XPPurchaseModel mj_objectArrayWithKeyValuesArray:modelArr];
            }else{
                weakSelf.dataArr  = modelArr;
                [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"没有更多数据啦"];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    }else{
        [XPSupplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"_id":@"id"
                     };
        }];
        
        [[XPNetWorkTool shareTool] searchSupplyInfoWithName:name andAddress:address andSort:sort andCallBack:^(NSArray *modelArr) {
            if (modelArr.count > 0){
                weakSelf.dataArr = [XPSupplyModel mj_objectArrayWithKeyValuesArray:modelArr];
            }else{
                weakSelf.dataArr  = modelArr;
                [XPAlertTool showAlertWithSupeView:weakSelf.view andText:@"没有更多数据啦"];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    }
    
}

- (void)setTableView{
    CGRect frame ;
    if (self.isTop){
        CGFloat height = (XP_SCREEN_HEIGHT)- 40;
        frame = CGRectMake(0, 32, XP_SCREEN_WIDTH,height );
    }else{
        CGFloat height = (XP_SCREEN_HEIGHT)- (XP_NavBar_Height)- 40;
        frame = CGRectMake(0, (XP_NavBar_Height)+32, XP_SCREEN_WIDTH,height );
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame];
    if (IS_IPHONE_X){
        tableView.height = tableView.height - XP_BottomBar_Height+8;
    }
    tableView.dataSource =self;
    tableView.delegate = self;
    if (self.isSale){
        [tableView registerNib:[UINib nibWithNibName:@"XPSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:XPSaleInfoTableViewCellID];
        
    }else{
        [tableView registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:XPBuyInfoTableViewCellID];
        
    }
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
}

- (void)hideCategoryView{
    [self.categoryBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
     [self.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.categoryView hide];
    self.categoryBtn.selected = NO;
}

- (void)setTitleView{
    XPGraySearchView *titleView = [[XPGraySearchView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH-60, 44)];
    self.searchView = titleView;
    titleView.delegate = self;
//    if (self.isSale){
//        titleView.placeholder = @"请输入要供应的货品";
//    }else{
//        titleView.placeholder = @"请输入要采购的货品";
//    }
    
    self.navigationItem.titleView = titleView;
}

- (void)setDropView{
    CGFloat originY ;
    if (self.isTop){
        originY = 0;
    }else{
        originY = XP_NavBar_Height;
    }
    
    UIButton *categoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, originY, XP_SCREEN_WIDTH/3-1, 40)];
    self.categoryBtn = categoryBtn;
    categoryBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:categoryBtn];
    NSString *title;
    if ([self.categoryTitleArr.lastObject isEqualToString:@"全部"]){
        title = self.categoryTitleArr.firstObject;
    }else{
        title = self.categoryTitleArr.lastObject;
    }
    self.leftTitle = self.categoryTitleArr.firstObject;
    [self.requestData setObject:title forKey:@"category"];
    
    MenuScreeningView *menu = [[MenuScreeningView alloc]initWithFrame:CGRectMake(XP_SCREEN_WIDTH/3, originY, XP_SCREEN_WIDTH, 40)];
    menu.backgroundColor = [UIColor whiteColor];
    self.menu = menu;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    [categoryBtn setTitle:title forState:UIControlStateNormal];
    [categoryBtn adjustBtnFont];
    [self.categoryBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    categoryBtn.adjustsImageWhenHighlighted = NO;
    [self adjustCategoryBtnInset];
    UIView *seperatorLine = [[UIView alloc]init];
    [self.view addSubview:seperatorLine];
    
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomLine];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(categoryBtn);
        make.height.equalTo(@20);
        make.left.equalTo(categoryBtn.mas_right);
        make.width.equalTo(@1);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(categoryBtn.mas_bottom).offset(-1);
        make.height.equalTo(@1);
    }];
    
   
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)adjustCategoryBtnInset{
    [self.categoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.categoryBtn.imageView.bounds.size.width+2 , 0, self.categoryBtn.imageView.bounds.size.width + 10)];
    [self.categoryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.categoryBtn.titleLabel.bounds.size.width + 10, 0, -self.categoryBtn.titleLabel.bounds.size.width+2 )];
}

- (void)categoryBtnClick:(UIButton *)sender{
    [self.searchView resignResponder];
    sender.selected = !sender.selected;
    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    if (sender.selected){
        [sender setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
        [self.categoryView show];
        [self.menu menuScreeningViewDismiss];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
        [self.categoryView hide];
    }

}

#pragma mark - XPCategoryViewDelegate
- (void)XPCategoryView:(XPCategoryView *)categoryView didSelectedTitleArr:(NSArray *)titleArr{
    NSString *title;
    NSString *category;
    if (titleArr.count > 1){
        if ([titleArr[1] isEqualToString:@"全部"]){
            title = [titleArr firstObject];
        }else{
            title = [titleArr lastObject];
        }
        
        category = [NSString stringWithFormat:@"%@,%@",titleArr.firstObject,titleArr.lastObject];
    }else{
        title = [titleArr firstObject];
        category = [NSString stringWithFormat:@"%@",titleArr.firstObject];
    }
    [self.requestData setObject:category forKey:@"category"];
    self.isRefresh = [title isEqualToString:self.categoryBtn.titleLabel.text] ? NO :YES;
    self.leftTitle = titleArr.firstObject;
    
    [self.categoryBtn setTitle: title forState:UIControlStateNormal];
    [self.categoryBtn adjustBtnFont];
    [self adjustCategoryBtnInset];
    [self categoryBtnClick:self.categoryBtn];
    
    if (self.isRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (NSInteger)didSelectedLeftRowInXPCategoryView:(XPCategoryView *)categoryView{
    
    if ([self.categoryBtn.titleLabel.text isEqualToString:@"分类"] || ![self.categoryData.allKeys containsObject:self.leftTitle]){
        return 0;
    }
    NSInteger index = [self.categoryData.allKeys indexOfObject:self.leftTitle];
    return index;
}

#pragma mark - MenuScreeningViewDelegate

- (void)menuScreeningView:(MenuScreeningView *)menuView didSeletedAddressTitle:(NSString *)addressTitle fullAddressTitle:(NSString *)fullAddressTitle sortTitle:(NSString *)sortitle isRefresh:(BOOL)isRefresh{
    [self.searchView resignResponder];

    [self hideCategoryView];
    self.isRefresh = isRefresh;
    if(self.isRefresh){
        
        [self.requestData setObject:sortitle forKey:@"sort"];
        if (fullAddressTitle != nil){
            [self.requestData setObject:fullAddressTitle forKey:@"address"];
        }
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource UITableViewDeleagte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.isSale){
//        return self.dataArr.count;
//    }
//    return 3;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSale){
        XPSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XPSaleInfoTableViewCellID forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }else{
        XPBuyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XPBuyInfoTableViewCellID forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSale){
        return 135;
    }
    return  120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSale){
        XPSaleDetailViewController *vc = [[XPSaleDetailViewController alloc]initWithModel:self.dataArr[indexPath.row]];
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        XPBuyDetailViewController *buy = [[XPBuyDetailViewController alloc]initWithhSupplyModel:self.dataArr[indexPath.row]];
        [self.navigationController pushViewController:buy animated:YES];
    }
    
}

#pragma mark - XPGraySearchViewDelegate

- (void)searchBarSearchBtnClick:(UISearchBar *)searchBar{
    NSString *name = searchBar.text;
    [self.requestData setObject:name forKey:@"category"];
    [self.categoryBtn setTitle:name forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
    
}
@end
