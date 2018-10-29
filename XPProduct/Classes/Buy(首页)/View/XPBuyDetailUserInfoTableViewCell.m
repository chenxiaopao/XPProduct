//
//  XPBuyDetailUserInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailUserInfoTableViewCell.h"
#import "UIView+XPViewFrame.h"
@implementation XPBuyDetailUserInfoTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.avatorView.layer.cornerRadius = 10;
    self.avatorView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
