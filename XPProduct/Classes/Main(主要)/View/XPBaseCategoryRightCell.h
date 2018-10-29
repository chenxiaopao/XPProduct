//
//  XPBaseCategoryRightCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XPViewFrame.h"
@class  XPBaseCategoryRightCell;
@protocol XPBaseCategoryRightCellDelagate <NSObject>
- (void)baseCategoryRightCell:(XPBaseCategoryRightCell *)cell  didselectedTitle:(NSString *)title;
@end
@interface XPBaseCategoryRightCell : UITableViewCell
@property (nonatomic,weak) id<XPBaseCategoryRightCellDelagate> delegate;
@property (nonatomic,copy) void(^collectionCellBlock)(NSString *);
@property (nonatomic,strong) NSArray *rightCellData;
@end
