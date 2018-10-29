//
//  XPPageView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/30.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPPageView : UIView
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr childVcs:(NSArray *)childVcs parentVc:(UIViewController *)parentVc contentViewCanScroll:(BOOL)canScroll;
@end
