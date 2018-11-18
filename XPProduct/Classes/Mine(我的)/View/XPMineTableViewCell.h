//
//  XPMineTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPCommentAndSupplyModel;
@protocol XPMineTableViewCellDelegate <NSObject>
- (void)mineTableViewCell:(UITableViewCell *)cell disSelectedSupplyId:(NSInteger)_id;
@end

@interface XPMineTableViewCell : UITableViewCell
@property (nonatomic,strong) XPCommentAndSupplyModel  *model;
@property (nonatomic,weak) id<XPMineTableViewCellDelegate> delegate;
@end
