//
//  XPBuyDetailViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPSupplyModel;
@interface XPBuyDetailViewController : UIViewController
@property (nonatomic,strong) XPSupplyModel *supplyModel;
- (instancetype)initWithhSupplyModel:(XPSupplyModel *)model;
- (void)addBottomView;
-(void)setBtnRadiusWithBtn:(UIButton *)btn androundingCorners:(UIRectCorner )corner;

@end
