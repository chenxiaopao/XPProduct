//
//  XPCollectChildViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/2.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCollectChildViewController.h"
#import "XPConst.h"
#import "XPSaleInfoTableViewCell.h"
#import "XPBuyInfoTableViewCell.h"
#import "MJRefresh.h"
#import "XPSaleDetailViewController.h"
#import "XPMineSaleDetailViewController.h"
#import "XPBuyDetailViewController.h"
@interface XPCollectChildViewController ()
@end

@implementation XPCollectChildViewController

- (void)getData{
    switch (self.type) {
        case XPMineItemTypeCollect:
        {
            if (self.isBuy){
                self.dataArr = [NSMutableArray arrayWithArray: @[@"1"]];
            }else{
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1"]];
            }
        }
            break;
        case XPMineItemTypeHistory:
        {
            if(self.isBuy){
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1"]];
            }else{
                self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"1"]];
            }
        }
            break;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self presentAlert:indexPath];
}

-(void)presentAlert:(NSIndexPath *)indexPath{
    NSString *title;
    if (self.type == XPMineItemTypeCollect){
        title = @"确定要取消收藏吗?";
    }else{
        title = @"确定要删除吗?";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"考虑清楚？？" preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dataArr removeObjectAtIndex:indexPath.item];
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == XPMineItemTypeCollect){
        return @"取消收藏";
    }
    return @"删除历史";
}

@end
