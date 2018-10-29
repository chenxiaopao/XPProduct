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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"productCategory" ofType:@"plist"];
    NSDictionary *categoryData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    XPCategoryView *categoryView =  [[XPCategoryView alloc]initWithFrame:self.view.bounds categoryData:categoryData];
    categoryView.delegate = self;
    [categoryView show];
    [self.view addSubview:categoryView];
}


#pragma mark - XPCategoryViewDelegate
- (void)XPCategoryView:(XPCategoryView *)categoryView didSelectedTitleArr:(NSArray *)titleArr{
    XPScreeningResultViewController *vc = [[XPScreeningResultViewController alloc]init];
    vc.categoryTitleArr = titleArr;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
