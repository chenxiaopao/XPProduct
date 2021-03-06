//
//  XPMineBuyDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineBuyDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "XPNetWorkTool.h"
#import "XPSupplyModel.h"
@interface XPMineBuyDetailViewController ()

@end
static int const buyBottomBtnTag = 3000;
@implementation XPMineBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setBtnPropertyWithBtn:(UIButton *)btn andTitle:(NSString *)title andBackgroundColor:(UIColor *)color{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addBottomView{
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
    CGFloat frameY = XP_SCREEN_HEIGHT-50;
    if (IS_IPHONE_X){
        frameY -= XP_BottomBar_Height;
    }
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, frameY, (XP_SCREEN_WIDTH-20), 40)];
    [self setBtnPropertyWithBtn:leftBtn andTitle:leftTitle andBackgroundColor:[UIColor blueColor]];
    leftBtn.tag = buyBottomBtnTag;
    
    [self setBtnRadiusWithBtn:leftBtn androundingCorners:UIRectCornerAllCorners];
    [self.view addSubview:leftBtn];
    
    
}

- (void)bottomBtnClick:(UIButton *)sender{
    
    switch (self.type) {
        case XPMineBuyOrSaleCellTypeActive:{
            if (sender.tag == buyBottomBtnTag) {
                NSString *state = @"0";
                NSString *title = @"下架";
                [self updateSupplyWithState:state andTitle:title];
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeInactive: {
            if (sender.tag == buyBottomBtnTag) {
                NSString *state = @"1";
                NSString *title = @"上架";
                [self updateSupplyWithState:state andTitle:title];
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeDisabled: {
            if (sender.tag == buyBottomBtnTag) {
                NSString *state = @"-2";
                NSString *title = @"删除";
                [self updateSupplyWithState:state andTitle:title];
                
            }
            break;
        }
    }
}

- (void)updateSupplyWithState:(NSString *)state andTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSString stringWithFormat:@"正在%@。。。",title];
    [[XPNetWorkTool shareTool] updateSupplyInfoWithState:state andId:self.supplyModel._id andCallBack:^(NSInteger tag) {
        if(tag){
            hud.label.text = [NSString stringWithFormat:@"%@成功",title];
        }else{
            hud.label.text = [NSString stringWithFormat:@"%@失败",title];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
            [self.navigationController popViewControllerAnimated:NO];
            
        });
    }];
    
}
@end
