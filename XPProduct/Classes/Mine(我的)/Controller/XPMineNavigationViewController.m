//
//  XPMineNavigationViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineNavigationViewController.h"

@interface XPMineNavigationViewController ()

@end

@implementation XPMineNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shadowImage = self.navigationBar.shadowImage;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    self.navigationBar.shadowImage = self.shadowImage;
}
@end
