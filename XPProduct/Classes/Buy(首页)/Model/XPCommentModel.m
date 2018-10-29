//
//  XPCommentModel.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCommentModel.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
@implementation XPCommentModel
- (float)height{
    CGFloat allHeight = 0.0;
    NSArray *modelArr = [XPCommentModel mj_objectArrayWithKeyValuesArray:self.subModel];
    if (self.subModel.count>0){
        for (XPCommentModel *model in modelArr) {
            NSMutableString *str =[ NSMutableString stringWithFormat:@"%@:%@",model.from_uname,model.content];
            CGFloat cellHeight = [self getHeightWithString:str andFont:[UIFont systemFontOfSize:17] andWidth:XP_SCREEN_WIDTH-50];
            allHeight += cellHeight;
        }
        if (self.subModel.count > 1){
            return allHeight+self.subModel.count*40;
        }else{
            return allHeight+30;
        }
        
    }else{
        return 0;
    }
}
- (CGFloat)getHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return height;
}
@end
