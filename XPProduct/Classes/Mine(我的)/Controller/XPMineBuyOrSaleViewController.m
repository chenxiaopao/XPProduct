//
//  XPMineBuyOrSaleViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/3.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineBuyOrSaleViewController.h"
#import "XPMineBuyOrSaleChildViewController.h"
#import "XPConst.h"
#import "XPPageView.h"
@interface XPMineBuyOrSaleViewController ()

@end

@implementation XPMineBuyOrSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.isBuy){
        self.title = @"我的采购";
    }else{
        self.title = @"我的供应";
    }
    NSArray *titleArr ;
    XPMineBuyOrSaleChildViewController *Vc1 = [[XPMineBuyOrSaleChildViewController alloc]init];
    XPMineBuyOrSaleChildViewController *Vc2 = [[XPMineBuyOrSaleChildViewController alloc]init];
    XPMineBuyOrSaleChildViewController *Vc3 = [[XPMineBuyOrSaleChildViewController alloc]init];
    if (self.isBuy ){
        Vc1.isBuy = YES;
        Vc2.isBuy = YES;
        Vc3.isBuy = YES;
    }
    Vc1.type = XPMineBuyOrSaleCellTypeActive;
    Vc1.view.backgroundColor = [UIColor redColor];
    
    Vc2.type = XPMineBuyOrSaleCellTypeInactive;
    Vc2.view.backgroundColor = [UIColor greenColor];
    
    Vc3.type = XPMineBuyOrSaleCellTypeDisabled;
    Vc3.view.backgroundColor = [UIColor blueColor];
    
    NSArray *childVcs = @[Vc1,Vc2,Vc3];
    if (self.isBuy){
        titleArr =@[@"采购中",@"已下架",@"被驳回",];
    }else{
        titleArr =@[@"供应中",@"已下架",@"被驳回",];
    }
    CGFloat height = (XP_SCREEN_HEIGHT) - (XP_NavBar_Height);
    XPPageView *pageView = [[XPPageView alloc]initWithFrame:CGRectMake(0, XP_NavBar_Height, XP_SCREEN_WIDTH, height) titleArr:titleArr childVcs:childVcs parentVc:self contentViewCanScroll:YES];
    [self.view addSubview:pageView];
}

@end
