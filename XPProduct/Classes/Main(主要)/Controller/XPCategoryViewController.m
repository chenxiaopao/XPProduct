//
//  XPCategoryViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCategoryViewController.h"
#import "XPCategoryView.h"
#import "UIView+XPViewFrame.h"
#import "XPScreeningResultViewController.h"
@interface XPCategoryViewController () <XPCategoryViewDelagete>

@end

@implementation XPCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productCategoryContainAll" ofType:@"plist"];
    NSDictionary *categoryData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    CGRect frame = CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT-(XP_NavBar_Height));
//    if (IS_IPHONE_X){
//        frame.size.height = frame.size.height-XP_BottomBar_Height;
//    }
    XPCategoryView *categoryView =  [[XPCategoryView alloc]initWithFrame:frame categoryData:categoryData];
    categoryView.delegate = self;
    [categoryView show];
    [self.view addSubview:categoryView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - XPCategoryViewDelegate
- (void)XPCategoryView:(XPCategoryView *)categoryView didSelectedTitleArr:(NSArray *)titleArr{
    XPScreeningResultViewController *vc = [[XPScreeningResultViewController alloc]init];
    vc.categoryTitleArr = titleArr;
    vc.isTop = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
