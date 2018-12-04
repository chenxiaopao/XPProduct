//
//  XPMineBuyOrSaleChildViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/3.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPConst.h"
@interface XPMineBuyOrSaleChildViewController : UIViewController
@property (nonatomic,assign) XPMineBuyOrSaleCellType type;
@property (nonatomic,assign) BOOL isBuy;
- (instancetype)initWithUser_Id:(NSInteger)user_id andHeight:(CGFloat)height;
@end
