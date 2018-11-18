//
//  XPMineSaleDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/3.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineSaleDetailViewController.h"
#import "XPNetWorkTool.h"
#import "MBProgressHUD.h"
@interface XPMineSaleDetailViewController ()

@end

@implementation XPMineSaleDetailViewController
static int const bottomBtnTag = 3000;
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setBottomBtn{
    NSString *leftTitle;
    switch (self.type) {
        case XPMineBuyOrSaleCellTypeActive:
        {
            leftTitle = @"下架";
        }
            break;
        case XPMineBuyOrSaleCellTypeInactive:
        {
            leftTitle = @"上架";
        }
            break;
        case XPMineBuyOrSaleCellTypeDisabled:
        {
            leftTitle = @"删除";
        }
            break;
    }
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, XP_SCREEN_HEIGHT-50, XP_SCREEN_WIDTH-20, 40)];
    [self setBtnPropertyWithBtn:leftBtn andTitle:leftTitle andBackgroundColor:[UIColor blueColor]];
    leftBtn.tag = bottomBtnTag;
    [self setBtnRadiusWithBtn:leftBtn androundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [self.view addSubview:leftBtn];

}

- (void)updatePurchaseState:(NSString *)state andTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSString stringWithFormat:@"正在%@。。。",title];
    [[XPNetWorkTool shareTool] publishPurchaseInfoWithArr:nil andModel:self.purchaseModel andState:state andCallBack:^(BOOL tag) {
        if(tag){
            hud.label.text = [NSString stringWithFormat:@"%@成功",title];
        }else{
            hud.label.text = [NSString stringWithFormat:@"%@失败",title];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
    
}

- (void)bottomBtnClick:(UIButton *)sender{
    switch (self.type) {
        case XPMineBuyOrSaleCellTypeActive:{
            if (sender.tag == bottomBtnTag) {
                NSString *state = @"0";
                NSString *title = @"下架";
                [self updatePurchaseState:state andTitle:title];
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeInactive: {
            if (sender.tag == bottomBtnTag) {
                NSString *state = @"1";
                NSString *title = @"上架";
                [self updatePurchaseState:state andTitle:title];
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeDisabled: {
            if (sender.tag == bottomBtnTag) {
                
            }
            break;
        }
    }
}

@end
