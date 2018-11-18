//
//  XPAlertTool.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XPAlertTool : NSObject
+ (void)showAlertWithSupeView:(UIView *)view andText:(NSString *)text;
+ (void)showLoginViewControllerWithVc:(UIViewController *)vc orOtherVc:(UIViewController *)otherVc  andSelectedIndex:(NSInteger )index;
+ (void)callToUserWithPhone:(NSString *)phone toView:(UIView *)view;
@end
