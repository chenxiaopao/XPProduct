
//
//  XPCommentAndSupplyModel.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCommentAndSupplyModel.h"

@implementation XPCommentAndSupplyModel

- (CGFloat)height{
    CGFloat cellHeight = 181;
    cellHeight += [self getHeightWithString:self.content andFont:[UIFont systemFontOfSize:15] andWidth:XP_SCREEN_WIDTH-20];
    return cellHeight;
}

- (CGFloat)getHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return height;
}

@end
