//
//  XPBaseCollectChildViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPConst.h"
@interface XPBaseCollectChildViewController : UIViewController
@property (nonatomic,assign) BOOL isBuy;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) XPMineItemType type;
- (void)getData;
@end
