//
//  XPBuyDetailHeadView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class XPBuyDetailHeadView;
@protocol  XPBuyDetailHeadViewDelegate <NSObject>
- (void)buyDetailHeadView:(XPBuyDetailHeadView *)headView;
@end

@interface XPBuyDetailHeadView : UIView
@property (nonatomic,weak) id<XPBuyDetailHeadViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr;
@end
