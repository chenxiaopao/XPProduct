//
//
//  XPBaseSearchTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/12.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseSearchHistoryTableViewCell.h"


@implementation XPBaseSearchHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setHistoryData:(NSMutableArray *)historyData{
    _historyData = historyData;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat marginX = 20;
    CGFloat marginY = 10;
    CGFloat leftSpace = 10;
    CGFloat topSpace = 10;
    CGFloat currentX = marginX;
    CGFloat currentY = marginY;
    CGFloat lastLabelWidth = 0;
    CGFloat labelHeight = 30;
    CGFloat row = 0;
    
    for (int i=0;i<historyData.count;i++){
        CGFloat labelWidth = [self labelWidthWithString:historyData[i] withLabelHeight:labelHeight];
        if (i == 0){
            currentX = currentX+lastLabelWidth ;
        }else{
            currentX = currentX+lastLabelWidth + leftSpace;
        }
        
        
        
        if (currentX+labelWidth+leftSpace > XP_SCREEN_WIDTH){
            row += 1;
            currentY = marginY + row *(labelHeight + topSpace);
            currentX = marginX;
            
        }
        lastLabelWidth = labelWidth;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(currentX, currentY, labelWidth, labelHeight)];
        
        label.text = historyData[i];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        label.tag = historyLabelTag+i;
        label.userInteractionEnabled =YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
    }
    
}
- (CGFloat)labelWidthWithString:(NSString *)text withLabelHeight:(CGFloat)height{
    NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attriDict context:nil];
    if (rect.size.width >XP_SCREEN_WIDTH -100){
        rect.size.width = XP_SCREEN_WIDTH -100;
    }
    return rect.size.width+20;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = label.tag;
    if (self.historyLabelBlock){
        self.historyLabelBlock(self.historyData[index-historyLabelTag]);
    }
}
@end
