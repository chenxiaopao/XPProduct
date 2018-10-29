//
//  XPDropCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPDropCell.h"

@implementation XPDropCell


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isSelected){
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor greenColor];
    }else{
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        self.textLabel.textColor = [UIColor blackColor];
    }
}
@end
