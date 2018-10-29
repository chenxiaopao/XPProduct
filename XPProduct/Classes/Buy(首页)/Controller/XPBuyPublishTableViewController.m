//
//  XPBuyPublishTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyPublishTableViewController.h"
#import "UIView+XPViewFrame.h"
#import "XPBuyPublishTableViewCell.h"
#import "XPBuyPublishModel.h"
#import "MJExtension.h"
#import "XPBuyCategoryViewController.h"
#import "XPBuyPickView.h"
#import "MBProgressHUD.h"
#import "XPNetWorkTool.h"
@interface XPBuyPublishTableViewController () <XPBuyPickViewDelegate>
@property (nonatomic,strong) NSArray<XPBuyPublishModel *>  *publishModelArr;
@end
static NSString *const buyPublishCellID = @"buyPublishCellID";

@implementation XPBuyPublishTableViewController

- (NSArray<XPBuyPublishModel *> *)publishModelArr{
    if (_publishModelArr == nil){
        NSArray *arr = @[
                         @{@"titleName":@"采购货品:",@"subTitleName":@"例如（柚子）"},
                         @{@"titleName":@"采购数量:",@"subTitleName":@"例如（1000斤）"},
                         @{@"titleName":@"采购单价:",@"subTitleName":@"例如（2.5）默认单位元，不用填"},
                         @{@"titleName":@"采购地区:",@"subTitleName":@"例如（福建省福州市）"},
                         @{@"titleName":@"其他描述:",@"subTitleName":@"例如（期望品种）"},
                         ];
        _publishModelArr = [XPBuyPublishModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return _publishModelArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布收购";
    [self addPublishBtn];
//    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"XPBuyPublishTableViewCell" bundle:nil] forCellReuseIdentifier:buyPublishCellID];
    
 
}

- (void)addPublishBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.height-50-(XP_NavBar_Height), XP_SCREEN_WIDTH-20, 50)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"确认发布" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)publishBtnClick{
    
    BOOL isCanPublish = true;
    NSMutableArray *arr = [NSMutableArray array];
    for (XPBuyPublishTableViewCell *cell in [self.tableView visibleCells]) {
        if([cell.textField.text  isEqual: @""]) {
            isCanPublish = false;
        }else{
            [arr addObject:cell.textField.text];
        }
    }
    if (isCanPublish){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在发布";
     
        [[XPNetWorkTool shareTool] publishPurchaseInfoWithArr:arr andModel:nil andState:nil  andCallBack:^(BOOL tag) {
            if(tag){
                hud.label.text = @"发布成功";
            }else{
                hud.label.text = @"发布失败";
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"需填写完整信息";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XPBuyPublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:buyPublishCellID forIndexPath:indexPath];
    XPBuyPublishModel *model;
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            __weak __typeof (self) weakSelf = self;
            __weak __typeof (cell) weakCell = cell;
            cell.block = ^{
                XPBuyCategoryViewController *vc = [[XPBuyCategoryViewController alloc]init];
                vc.popBlock = ^(NSArray * arr, NSInteger index) {
                    weakCell.textField.text = [arr lastObject];
                };
                [weakSelf.navigationController pushViewController:vc animated:NO];
            };
            
        }
        if(indexPath.row == 2){
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        model = [self.publishModelArr objectAtIndex:indexPath.row];
    }else{
        if (indexPath.row == 0){
            XPBuyPickView *pickView = [[XPBuyPickView alloc]init];
            pickView.buyPickViewDelegate = self;
            cell.textField.inputView = pickView;
        }
        model = [self.publishModelArr objectAtIndex:indexPath.row+3];
    }
    cell.data = model;
    return cell;
}

#pragma mark - XPBuyPickViewDelegate
- (void)XPBuyPickView:(XPBuyPickView *)pickView addressName:(NSString *)addressName{
    XPBuyPublishTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    cell.textField.text = addressName;
}
@end
