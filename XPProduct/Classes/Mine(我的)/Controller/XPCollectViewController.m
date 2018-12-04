//
//  XPCollectViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/30.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCollectViewController.h"
#import "XPPageView.h"
#import "XPCollectChildViewController.h"
#import "XPBaseCollectChildViewController.h"
@interface XPCollectViewController ()
@property (nonatomic,strong) UIPanGestureRecognizer *panGest;
@end

@implementation XPCollectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    for (UIGestureRecognizer *gest in self.navigationController.view.gestureRecognizers) {
        if (![gest isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
            self.panGest = (UIPanGestureRecognizer *)gest;
            gest.enabled = NO;
        }else{
            
            gest.enabled = YES;
        }
    }
    [self setInitUI];
    
   

}
- (void)viewDidDisappear:(BOOL)animated{
    self.panGest.enabled = YES;
    [super  viewDidDisappear:animated];
}


- (void)setInitUI{
    NSArray *titleArr = @[@"采购",@"供应"];
    BOOL isScroll;
    switch (self.type) {
        case 1:
        {
            self.title = @"我的收藏";
            isScroll = NO;
        }
            break;
        case 0:
        {
            isScroll = NO;
            self.title = @"浏览历史";
        }
            break;
    }

    CGFloat height = (XP_SCREEN_HEIGHT) - (XP_NavBar_Height);
    XPBaseCollectChildViewController *Vc1 = [[XPCollectChildViewController alloc]init];
    Vc1.isBuy = YES;
    
    Vc1.type = self.type;
    Vc1.view.backgroundColor = [UIColor whiteColor];
    XPBaseCollectChildViewController *Vc2 = [[XPCollectChildViewController alloc]init];
    Vc2.view.backgroundColor = [UIColor whiteColor];
    Vc2.type = self.type;
    NSArray *childVcs = @[Vc1,Vc2];
    
    XPPageView *pageView = [[XPPageView alloc]initWithFrame:CGRectMake(0, XP_NavBar_Height, XP_SCREEN_WIDTH, height) titleArr:titleArr childVcs:childVcs parentVc:self contentViewCanScroll:isScroll];
    
    [self.view addSubview:pageView];
    
}


@end
