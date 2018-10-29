//
//  XPDetailCommentInfoTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  XPCommentModel,XPDetailCommentInfoTableViewCell;
@protocol XPDetailCommentInfoTableViewCellDelegate <NSObject>
- (void)DetailCommentInfoTableViewCell:(XPDetailCommentInfoTableViewCell *)cell replyBtnClick:(UIButton *)btn;
@end
@interface XPDetailCommentInfoTableViewCell : UITableViewCell
@property (nonatomic,weak) id<XPDetailCommentInfoTableViewCellDelegate> delegate;
@property (nonatomic,strong) XPCommentModel *model;
@end
