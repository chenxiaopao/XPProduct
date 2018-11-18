//
//  XPBuyNoCommentView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/16.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyNoCommentView.h"
#import <Masonry/Masonry.h>
@interface XPBuyNoCommentView ()
@property (nonatomic,weak) UILabel *label;
@property (nonatomic,weak) UIButton *button;
@end
@implementation XPBuyNoCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"当前还没有评论噢~~~";
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [self.contentView addSubview:label];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"添加评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
    [self.contentView addSubview:button];
}

- (void)addComment:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(buyNoCommentView:commentBtnClick:)]){
        [self.delegate buyNoCommentView:self commentBtnClick:sender];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@30);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.label);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(20);
    }];
}
@end
