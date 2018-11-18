//
//  XPCollectChildViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/2.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCollectChildViewController.h"
#import "XPPurchaseModel.h"
#import "XPNetWorkTool.h"
@interface XPCollectChildViewController ()
@end

@implementation XPCollectChildViewController



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
        [weakSelf updateHistoryData:weakSelf.dataArr[indexPath.row]];
        [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
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

- (void)updateHistoryData:(XPPurchaseModel *)model{
    int type = 0;
    if (!self.isBuy){
        type = 1;
    }
    NSDictionary *dict = @{
                           @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"product_id":@(model._id),
                           @"tableType":@(self.type),
                           @"updateHistory":@"1",
                           @"type":@(type)
                           };
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(id obj) {
        
    }];
}
@end
