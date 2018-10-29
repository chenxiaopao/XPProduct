//
//  XPBuyCategoryViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCategoryViewController.h"

@interface XPBuyCategoryViewController : XPCategoryViewController
@property (nonatomic,copy) void(^popBlock)(NSArray *,NSInteger);
@end
