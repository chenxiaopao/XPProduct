//
//  XPMineBuyDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineBuyDetailViewController.h"

@interface XPMineBuyDetailViewController ()

@end
static int const buyBottomBtnTag = 3000;
@implementation XPMineBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setBtnPropertyWithBtn:(UIButton *)btn andTitle:(NSString *)title andBackgroundColor:(UIColor *)color{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addBottomView{
    NSString *leftTitle;
    NSString *rightTitle;
    switch (self.type) {
        case XPMineBuyOrSaleCellTypeActive:
        {
            leftTitle = @"下架";
            rightTitle=@"修改";
        }
            break;
        case XPMineBuyOrSaleCellTypeInactive:
        {
            leftTitle = @"删除";
            rightTitle = @"上架";
        }
            break;
        case XPMineBuyOrSaleCellTypeDisabled:
        {
            leftTitle = @"修改";
            rightTitle = @"删除";
        }
            break;
    }
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, XP_SCREEN_HEIGHT-50, (XP_SCREEN_WIDTH-20)/2, 40)];
    [self setBtnPropertyWithBtn:leftBtn andTitle:leftTitle andBackgroundColor:[UIColor blueColor]];
    leftBtn.tag = buyBottomBtnTag;
    [self setBtnRadiusWithBtn:leftBtn androundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [self.view addSubview:leftBtn];
    
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), XP_SCREEN_HEIGHT-50, (XP_SCREEN_WIDTH-20)/2, 40)];
    UIColor *rightColor =  [UIColor colorWithRed:255/255.0 green:120/255.0 blue:17/255.0 alpha:1];
    [self setBtnPropertyWithBtn:rightBtn andTitle:rightTitle andBackgroundColor:rightColor];
    [self setBtnRadiusWithBtn:rightBtn androundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight];
    [self.view addSubview:rightBtn];
}

- (void)bottomBtnClick:(UIButton *)sender{
    
    switch (self.type) {
        case XPMineBuyOrSaleCellTypeActive:{
            
            if (sender.tag == buyBottomBtnTag) {
                NSLog(@"下架");
            }else{
                NSLog(@"修改");
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeInactive: {
            if (sender.tag == buyBottomBtnTag) {
                NSLog(@"删除");
            }else{
                NSLog(@"上架");
            }
            break;
        }
        case XPMineBuyOrSaleCellTypeDisabled: {
            if (sender.tag == buyBottomBtnTag) {
                NSLog(@"修改");
            }else{
                NSLog(@"删除");
            }
            break;
        }
    }
}
@end
