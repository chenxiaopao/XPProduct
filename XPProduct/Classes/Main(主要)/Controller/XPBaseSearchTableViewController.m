//
//  XPBaseSearchTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseSearchTableViewController.h"
#import <objc/message.h>
@interface XPBaseSearchTableViewController () <UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *searchHistoryArr;

@end

static NSString *baseSearchHistoryCellID = @"baseSearchHistoryCell";
static NSString *baseSearchRecommendCellID = @"baseSearchRecommendCellID";

@implementation XPBaseSearchTableViewController

- (void)setHistoryDataKey:(NSString *)historyDataKey{    
    _historyDataKey = historyDataKey;
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:historyDataKey]){
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:historyDataKey];
        self.searchHistoryArr = [NSMutableArray arrayWithArray:arr];
    }
}

- (NSArray *)searchRecommendArr{
    if(_searchRecommendArr == nil){
        _searchRecommendArr = @[@"哈密瓜",@"密柚",@"橘子",@"苹果",@"西瓜"];
    }
    return  _searchRecommendArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchBar];
  

    [self.tableView registerClass:[XPBaseSearchHistoryTableViewCell class] forCellReuseIdentifier:baseSearchHistoryCellID];
    [self.tableView registerClass:[XPBaseSearchRecommendTableViewCell class] forCellReuseIdentifier:baseSearchRecommendCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"请输入搜索内容";
//        unsigned int count =0;
//        Ivar *ivars = class_copyIvarList([searchBar class], &count);
//        for(int i =0;i<count;i++){
//            NSLog(@"%@",[NSString stringWithFormat:@"%s", ivar_getName(ivars[i])]);
//        }
    [searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    self.navigationItem.titleView = searchBar;
    UIButton *cancelBtn =  [searchBar valueForKey:@"cancelButton"];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (![self.searchHistoryArr containsObject:searchBar.text]){
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.searchHistoryArr];
        [mArr insertObject:searchBar.text atIndex:0];
        self.searchHistoryArr = mArr;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        self.pushBlock(searchBar.text);
        searchBar.text = @"";
        [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArr forKey:self.historyDataKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        XPBaseSearchRecommendTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:baseSearchRecommendCellID forIndexPath:indexPath];
        cell.recommendSearchArr = self.searchRecommendArr;
        __weak __typeof(self)weakSelf = self;
        cell.recommendLabelBlock = ^(NSString *title) {
            weakSelf.pushBlock(title);
        };
        return  cell;
    }else{
        XPBaseSearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseSearchHistoryCellID forIndexPath:indexPath];
        if (self.searchHistoryArr.count){
            cell.historyData = self.searchHistoryArr;
            __weak __typeof(self)weakSelf = self;
            cell.historyLabelBlock = ^(NSString *title) {
                weakSelf.pushBlock(title);
            };
        };
        return  cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        UIView *bgView = [[UIView alloc]init];
        UILabel *recommendLabel = [[UILabel alloc]init];
        recommendLabel.text = @"热门推荐";
        [bgView addSubview:recommendLabel];
        [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(10);
            
        }];
        bgView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        return bgView;
    }else{
        XPSearchHistorySectionHeadView *view =  [[[NSBundle mainBundle] loadNibNamed:@"XPSearchHistorySectionHeadView" owner:nil options:nil]lastObject];
        __weak __typeof(self)weakSelf = self;
        view.deleteBtn = ^{
            if (weakSelf.searchHistoryArr.count > 0){
                [weakSelf showAlert:weakSelf];
            };
        };
        
        view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.searchHistoryArr.count == 0){
        return 0;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.searchRecommendArr.count%2==0 ? self.searchRecommendArr.count/2*40+10 : (self.searchRecommendArr.count/2+1)*40+10;
    return  height;
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)showAlert:(XPBaseSearchTableViewController *)weakSelf{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除全部历史记录" message:@"考虑清楚？？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.searchHistoryArr removeAllObjects];
        XPBaseSearchHistoryTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        cell.historyData = weakSelf.searchHistoryArr;
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.historyDataKey];
    [weakSelf presentViewController:alert animated:YES completion:nil];
    
}

@end
