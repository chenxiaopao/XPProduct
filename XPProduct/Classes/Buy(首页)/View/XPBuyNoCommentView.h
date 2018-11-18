//
//  XPBuyNoCommentView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/16.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPBuyNoCommentView;
@protocol XPBuyNoCommentViewDelegate <NSObject>
- (void)buyNoCommentView:(XPBuyNoCommentView *)view commentBtnClick:(UIButton *)commentBtn;
@end

@interface XPBuyNoCommentView : UITableViewCell
@property (nonatomic,weak) id<XPBuyNoCommentViewDelegate> delegate;
@end
