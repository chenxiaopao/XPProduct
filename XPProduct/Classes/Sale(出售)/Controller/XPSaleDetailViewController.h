//
//  XPSaleDetailViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/29.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPPurchaseModel;
@interface XPSaleDetailViewController : UIViewController

@property (nonatomic,strong) XPPurchaseModel *purchaseModel;
- (instancetype)initWithModel:(XPPurchaseModel *)purchaseModel;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setBottomBtn;
-(void)setBtnRadiusWithBtn:(UIButton *)btn androundingCorners:(UIRectCorner )corner;
- (void)setBtnPropertyWithBtn:(UIButton *)btn andTitle:(NSString *)title andBackgroundColor:(UIColor *)color;
- (void)bottomBtnClick:(UIButton *)sender;
@end
