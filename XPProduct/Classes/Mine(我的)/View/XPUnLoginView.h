//
//  XPUnLoginView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPUnLoginView;
@protocol XPUnLoginViewDelegate <NSObject>
- (void)unLoginView:(XPUnLoginView *)unLoginView avatorViewClick:(UIView *)avatorView;
@end

@interface XPUnLoginView : UIView
@property (nonatomic,weak) UIImageView *avatorView;
@property (nonatomic,strong)  NSString *userName;
@property (nonatomic,weak) id<XPUnLoginViewDelegate> delegate;
@end
