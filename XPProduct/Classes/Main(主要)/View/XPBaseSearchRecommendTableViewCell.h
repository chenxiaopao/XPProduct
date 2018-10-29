//
//  XPBaseSearchRecommendTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XPViewFrame.h"
#import "XPConst.h"
//@class  XPBaseSearchRecommendTableViewCell;
//@protocol XPBaseSearchRecommendTableViewCellDelegate <NSObject>
//- (void)baseSearchRecommendTableViewCell:(XPBaseSearchRecommendTableViewCell *)cell labelTitle:(NSString *)title;
//@end


@interface XPBaseSearchRecommendTableViewCell : UITableViewCell
@property (nonatomic,strong) NSArray *recommendSearchArr;
@property (nonatomic,copy) void(^recommendLabelBlock)(NSString *) ;
//@property (nonatomic,weak) id<XPBaseSearchRecommendTableViewCellDelegate *> delegate;
@end
