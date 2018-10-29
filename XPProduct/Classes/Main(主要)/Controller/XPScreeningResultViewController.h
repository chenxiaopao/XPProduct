//
//  XPScreeningResultViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPScreeningResultViewController : UIViewController
@property (nonatomic,strong) NSArray *categoryTitleArr;
@property (nonatomic,assign) BOOL isSale;

- (void)pullUpRefreshData;
- (void)pullDownRefreshData;
@end
