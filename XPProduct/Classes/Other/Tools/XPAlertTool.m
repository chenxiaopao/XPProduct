//
//  XPAlertTool.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPAlertTool.h"
#import "MBProgressHUD.h"
#import "XPLoginViewController.h"
@implementation XPAlertTool
+ (void)showAlertWithSupeView:(UIView *)view andText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud removeFromSuperview];
    });
}

+ (void)showLoginViewControllerWithVc:(UIViewController *)vc orOtherVc:(UIViewController *)otherVc andSelectedIndex:(NSInteger )index{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先登录。。";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XPLoginViewController *login = [[XPLoginViewController alloc]init];
            login.destVc = otherVc;
            login.seletedIndex = index;
            
            [vc presentViewController:login animated:YES completion:nil];
            
        });
    }else{
        [vc.navigationController pushViewController:otherVc animated:YES];
    }
}

@end
