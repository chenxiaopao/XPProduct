
//
//  XPBuyDetailHeadViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailHeadViewCell.h"
@interface XPBuyDetailHeadViewCell ()

@end
@implementation XPBuyDetailHeadViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView = imageView;
    [self addSubview:imageView];
}
@end
