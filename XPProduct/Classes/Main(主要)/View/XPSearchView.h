//
//  XPSearchBar.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIImage+XPOriginImage.h"
#import "UIView+XPViewFrame.h"
@class XPSearchView;
@protocol XPSearchViewDelegate <NSObject>
- (void)searchView:(XPSearchView *)searchView;
@end

@interface XPSearchView : UIView
@property (nonatomic,weak) id<XPSearchViewDelegate> delegate;
@end
