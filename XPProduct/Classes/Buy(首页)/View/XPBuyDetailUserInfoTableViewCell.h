//
//  XPBuyDetailUserInfoTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPSupplyModel;
@interface XPBuyDetailUserInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) XPSupplyModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;

@end
