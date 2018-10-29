//
//  XPBaseSearchRecommendTableViewCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseSearchRecommendTableViewCell.h"



@implementation XPBaseSearchRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setRecommendSearchArr:(NSArray *)recommendSearchArr{
    _recommendSearchArr = recommendSearchArr;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat originX = 10;
    CGFloat originY = 10;
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat labelHeight = 40;
    CGFloat labelWidth = (XP_SCREEN_WIDTH-20)/2;
    for(int i=0;i<recommendSearchArr.count;i++){
        currentX = originX + i%2*labelWidth;
        currentY = originY + i/2*labelHeight;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(currentX, currentY, labelWidth-10, labelHeight-10)];
        label.text = recommendSearchArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        
        label.layer.masksToBounds = YES;
        label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        label.layer.borderWidth = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        label.tag = recommendLabelTag+i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        [self.contentView addSubview:label];
        
    }
}

- (void)tap:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    if (self.recommendLabelBlock){
        self.recommendLabelBlock(self.recommendSearchArr[label.tag-recommendLabelTag]);
    }
  
}

@end
