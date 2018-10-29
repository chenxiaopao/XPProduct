//
//  XPBannerView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/10.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XPViewFrame.h"
#import "XPWeakProxy.h"
#import "XPConst.h"
@class XPBannerView;
@protocol XPBannerViewDelegate <NSObject>
- (void)bannerView:(XPBannerView *)bannerView didSelectedIndex:(NSInteger)index;

@end


@interface XPBannerView : UIView
@property (nonatomic,weak) id<XPBannerViewDelegate> delegate;
@property (nonatomic,strong) NSArray<NSString *> *imageArr;
- (void)addTimer;
- (void)removeTimer;

@end



