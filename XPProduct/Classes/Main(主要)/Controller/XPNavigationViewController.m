//
//  XPNavigationViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPNavigationViewController.h"

@interface XPNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation XPNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@",self.interactivePopGestureRecognizer);
    //全部pop手势
    id target = self.interactivePopGestureRecognizer.delegate;
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    
    
    

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //根控制器时禁止手势，跟控制器判断：self.viewControllers.count是否大于1
    //大于1则为非根控制器
    BOOL isOpen = self.viewControllers.count>1;
    return isOpen;

    
}
//自定义返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    //非跟控制器
    if (self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_left"]  style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
