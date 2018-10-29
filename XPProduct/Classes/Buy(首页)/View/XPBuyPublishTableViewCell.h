//
//  XPBuyPublishTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPBuyPublishModel;
@interface XPBuyPublishTableViewCell : UITableViewCell
@property (nonatomic,strong) XPBuyPublishModel *data;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,copy) void(^block)(void);
@end
