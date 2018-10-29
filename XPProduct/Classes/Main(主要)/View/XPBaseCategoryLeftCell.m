//
//  XPBaseCategoryLeftCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseCategoryLeftCell.h"
@interface XPBaseCategoryLeftCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation XPBaseCategoryLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, 0, 100, 40);
        label.font = [UIFont systemFontOfSize:17];
        self.titleLabel = label;
        [self.contentView addSubview:self.titleLabel];
        self.selectedBackgroundView = [[UIView alloc]init];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isSelected){
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor greenColor];
    }else{
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
