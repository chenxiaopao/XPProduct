//
//  XPBuyCommentViewController.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBuyCommentViewController : UIViewController
@property (nonatomic,strong) NSArray *commentDataArr;
@property (nonatomic,assign) NSInteger product_id;
@property (nonatomic,assign) BOOL isShowTextField;
@end
