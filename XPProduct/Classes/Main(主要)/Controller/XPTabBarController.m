//
//  XPTabBarController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPTabBarController.h"
#import "XPNavigationViewController.h"
#import "XPBuyViewController.h"
#import "XPSaleViewController.h"
#import "XPInfomationTableViewController.h"
#import "XPMineViewController.h"
#import "UIImage+XPOriginImage.h"
#import "XPMineNavigationViewController.h"
#import "XPLoginViewController.h"
@interface XPTabBarController () <UITabBarControllerDelegate>

@end



@implementation XPTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpAllChildVcs];
    self.delegate = self;

}

- (void)setUpAllChildVcs{
    XPBuyViewController *buy = [[XPBuyViewController alloc]init];
    
    [self setUpChildVc:buy itemImage:[UIImage imageNamed:@"icon_findGoods_unSelect"] itemSelectedImage:[UIImage xp_originImageNamed:@"icon_findGoods_selected"] itemTitle:@"我要买"];
    
    XPSaleViewController *sale = [[XPSaleViewController alloc]init];
    UIImage *originImage = [UIImage xp_originImageNamed:@"icon_sellingGoods_selected"];
    UIImage *newImage = [originImage xp_imageWithColor:[UIColor colorWithRed:0 green:196/255.0 blue:0 alpha:1]];
    [self setUpChildVc:sale itemImage:[UIImage imageNamed:@"icon_sellingGoods_unSelect"] itemSelectedImage:newImage  itemTitle:@"我要卖"];
    
    
    XPInfomationTableViewController *info = [[XPInfomationTableViewController alloc]init];
    UIImage *originPublishImage = [UIImage xp_originImageNamed:@"icon_messageSelected"];
    UIImage *newPublishImage = [originPublishImage xp_imageWithColor:[UIColor colorWithRed:0 green:196/255.0 blue:0 alpha:1]];
    [self setUpChildVc:info itemImage:[UIImage imageNamed:@"icon_messageUnSelect"] itemSelectedImage:newPublishImage itemTitle:@"资讯"];
    
    
    XPMineViewController *mine = [[XPMineViewController alloc]init];
    [self setUpChildVc:mine itemImage:[UIImage imageNamed:@"icon_me_unSelect"] itemSelectedImage:[UIImage xp_originImageNamed:@"icon_me_selected"] itemTitle:@"我的"];
}
- (void)setUpChildVc:(UIViewController *)vc itemImage:(UIImage *)image itemSelectedImage:(UIImage*)selectedImage itemTitle:(NSString *)title{
//    DragerViewController *drag = [[DragerViewController alloc]init];
//    [drag.middleView addSubview:vc.view];
//    [drag addChildViewController:vc];
    if ([vc isKindOfClass:[XPMineViewController class] ]){
        XPNavigationViewController *nav = [[XPMineNavigationViewController alloc]initWithRootViewController:vc];
        nav.tabBarItem.title = title;
        nav.tabBarItem.image = image;
        
        nav.tabBarItem.selectedImage = selectedImage;
        self.tabBar.tintColor = [UIColor colorWithRed:0 green:196/255.0 blue:0 alpha:1];
        [self addChildViewController:nav];
    }else{
        vc.title = title;
        XPNavigationViewController  *nav = [[XPNavigationViewController alloc]initWithRootViewController:vc];
        nav.tabBarItem.title = title;
        nav.tabBarItem.image = image;
        
        nav.tabBarItem.selectedImage = selectedImage;
        self.tabBar.tintColor = [UIColor colorWithRed:0 green:196/255.0 blue:0 alpha:1];
        [self addChildViewController:nav];
    }
    
    
    
    
}

#pragma mark - UITabbarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    

    if([viewController.tabBarItem.title isEqualToString:@"我的"]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBuyVc:) name:@"selectedBuyVc" object:nil];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults objectForKey:@"isLogin"]){
            self.selectedIndex = 3;
            XPLoginViewController *vc = [XPLoginViewController new];
            vc.seletedIndex = 3;
            [[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex] presentViewController:vc animated:YES completion:nil];
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)selectedBuyVc:(NSNotification *)noti{
    [self setSelectedIndex:0];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
