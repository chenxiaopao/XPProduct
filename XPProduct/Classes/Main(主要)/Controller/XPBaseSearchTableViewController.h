//
//  XPBaseSearchTableViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBaseSearchHistoryTableViewCell.h"
#import "XPSearchHistorySectionHeadView.h"
#import "XPBaseSearchRecommendTableViewCell.h"
#import "Masonry.h"
@interface XPBaseSearchTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *searchRecommendArr;
@property (nonatomic,copy) void(^pushBlock)(NSString *);
@property (nonatomic,strong) NSString *historyDataKey;
@end
