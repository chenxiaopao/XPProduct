//
//  UIButton+XPAdjustFont.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "UIButton+XPAdjustFont.h"

@implementation UIButton (XPAdjustFont)
- (void)adjustBtnFont{
    CGFloat size = 17;
    if (self.titleLabel.text.length >6){
        size =13;
    }else if (self.titleLabel.text.length >4){
        size = 15;
    }
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
}
@end
