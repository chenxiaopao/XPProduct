//
//  XPBuyCategoryViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyCategoryViewController.h"
#import "XPCategoryView.h"
@interface XPBuyCategoryViewController () <XPCategoryViewDelagete>

@end

@implementation XPBuyCategoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)XPCategoryView:(XPCategoryView *)categoryView didSelectedTitleArr:(NSArray *)titleArr{
    self.popBlock(titleArr,0);
    [self.navigationController popViewControllerAnimated:NO];
}


@end
