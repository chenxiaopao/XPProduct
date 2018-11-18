//
//  XPMineUserCardViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineUserCardViewController.h"
#import "XPPageView.h"
#import "UIImage+XPOriginImage.h"
#import "UIView+XPViewFrame.h"
#import "XPBaseCollectChildViewController.h"
#import "XPMineBuyOrSaleChildViewController.h"
@interface XPMineUserCardViewController ()

@end

@implementation XPMineUserCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //topView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 200)];
    imageView.image = [UIImage imageNamed:@"background_orange"];
    [self.view addSubview:imageView];
    
    UIImageView *avatorView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame)-30, 60, 60)];
    avatorView.image = [UIImage getImageWithName:@"avatar"];
    avatorView.layer.masksToBounds = YES;
    avatorView.layer.cornerRadius = avatorView.width/2;
    [self.view addSubview:avatorView];
    
    //middleView
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), XP_SCREEN_WIDTH, 100)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 100, 30)];
    label.font = [UIFont systemFontOfSize:20];
    label.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    [middleView addSubview:label];

    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, middleView.height-1, middleView.width, 1)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [middleView addSubview:bottomLine];
    [self.view addSubview:middleView];
    
    
    //bottomView
    NSArray *titleArr = @[@"采购",@"供应"];
    XPMineBuyOrSaleChildViewController *Vc1 = [[XPMineBuyOrSaleChildViewController alloc]init];
    XPMineBuyOrSaleChildViewController *Vc2 = [[XPMineBuyOrSaleChildViewController alloc]init];
 
    Vc1.type = XPMineBuyOrSaleCellTypeActive;
    Vc1.isBuy = YES;
    Vc1.view.backgroundColor = [UIColor redColor];
    
    Vc2.type = XPMineBuyOrSaleCellTypeActive;
    Vc2.isBuy = NO;
    Vc2.view.backgroundColor = [UIColor greenColor];
    
    NSArray *childVcs = @[Vc1,Vc2];
   
    CGFloat height = (XP_SCREEN_HEIGHT) -CGRectGetMaxY(middleView.frame);
    XPPageView *pageView = [[XPPageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), XP_SCREEN_WIDTH, height) titleArr:titleArr childVcs:childVcs parentVc:self contentViewCanScroll:YES];
    [self.view addSubview:pageView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init] ];
    self.navigationController.navigationBar.translucent = YES;
}

@end
