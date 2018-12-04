//
//  XPMineCommentTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineCommentTableViewController.h"
#import "XPNetWorkTool.h"
#import "XPCommentAndSupplyModel.h"
#import <MJExtension/MJExtension.h>
#import "XPMineTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "XPSupplyModel.h"
#import "XPBuyDetailViewController.h"
#import "XPAlertTool.h"
#import "UIImage+XPOriginImage.h"
#import "XPNoDataTableViewCell.h"
@interface XPMineCommentTableViewController () <XPMineTableViewCellDelegate>
@property (nonatomic,strong) NSArray *modelArr;
@end

@implementation XPMineCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    [self.tableView registerNib: [UINib nibWithNibName:@"XPNoDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"noDataCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XPMineTableViewCell" bundle:nil] forCellReuseIdentifier:@"mineCommentCell"];
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
    [self setNavItem];
}

- (void)setNavItem{
    UIImage *image = [UIImage xp_originImageNamed:@"delete"];
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnClick:)];
    self.navigationItem.rightBarButtonItem = clearBtn;
}

- (void)clearBtnClick:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除所有评论吗？" message:@"考虑清楚？？" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [[XPNetWorkTool shareTool] loadCommentAndSupplyInfoIsDeleteAll:YES WithCallback:^(id obj) {

             self.modelArr = nil;
             [XPAlertTool showAlertWithSupeView:self.view andText:@"清除成功"];
             [self.tableView reloadData];
             [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent =  YES;
    
    [super viewWillDisappear:animated];
}

- (void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载数据中。。。";
     [[XPNetWorkTool shareTool] loadCommentAndSupplyInfoIsDeleteAll:NO WithCallback:^(NSArray *modelArr) {
        self.modelArr = [XPCommentAndSupplyModel mj_objectArrayWithKeyValuesArray:modelArr];
        [hud removeFromSuperview];
        [self.tableView reloadData];
        
    }];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.modelArr.count > 0){
        return self.modelArr.count;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelArr.count > 0){
        XPMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCommentCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.modelArr[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        XPNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell" forIndexPath:indexPath];
        return  cell;
    }
}


#pragma mark - XPMineTableViewCellDelegate
- (void)mineTableViewCell:(UITableViewCell *)cell disSelectedSupplyId:(NSInteger)_id{
    [[XPNetWorkTool shareTool] loadSupplyInfoWithId:_id User_id:@"" andState:@"" andCallBack:^(NSArray *modelArr, NSError *error) {
        [XPSupplyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"_id":@"id"
                     };
        }];
        XPSupplyModel *model =  [XPSupplyModel mj_objectWithKeyValues:modelArr[0]];
        XPBuyDetailViewController *vc = [[XPBuyDetailViewController alloc]initWithhSupplyModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
