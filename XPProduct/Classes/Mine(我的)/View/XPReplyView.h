//
//  XPReplyView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/12.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPReplyView;

@protocol XPReplyViewDelegate <NSObject>
- (void)replyViewDelegate:(XPReplyView *)replyView andTextField:(UITextField *)textField;
@end

@interface XPReplyView : UIView
@property (nonatomic,weak) id<XPReplyViewDelegate> delegate;
@end
