//
//  XPBuyDetailViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBuyDetailViewController : UIViewController
- (void)addBottomView;
-(void)setBtnRadiusWithBtn:(UIButton *)btn androundingCorners:(UIRectCorner )corner;
@property (nonatomic,assign) BOOL notCanSelected;
@end
