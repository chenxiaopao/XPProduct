//
//  XPSalePublishTimeViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPSalePublishTimeViewController : UIViewController
@property (nonatomic,copy) void(^timeBlock)(NSString *);
@end
