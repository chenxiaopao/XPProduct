//
//  XPBaseSearchTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/12.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPConst.h"
@interface XPBaseSearchHistoryTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *historyData;
@property (nonatomic,copy) void(^historyLabelBlock)(NSString *);
@end
