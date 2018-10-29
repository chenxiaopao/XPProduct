//
//  XPUnLoginView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPUnLoginView.h"
#import "UIView+XPViewFrame.h"
#import "UIImage+XPOriginImage.h"
#import "UIImage+XPOriginImage.h"
@interface XPUnLoginView ()

@property (nonatomic,weak) UIImageView *bgImageView;
@property (nonatomic,weak) UIView *bgAvatorView;
@property (nonatomic,weak) UIImageView *avatorView;
@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UIImageView *arrowImageView;
@property (nonatomic,weak) UIView *bottomView;
@end

@implementation XPUnLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setDefaultAvatar];
        [self setUpUI];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.avatorView.image = image;
}
- (void)setUserName:(NSString *)userName{
    _userName = userName;
    self.nameLabel.text = userName;
}

- (void)setUpUI{
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"background_me"];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UIView *bgAvatorView = [[UIView alloc]init];
    [self addSubview:bgAvatorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [bgAvatorView addGestureRecognizer:tap];
    
    self.bgAvatorView = bgAvatorView;
    
    UIImageView *avatorView = [[UIImageView alloc]init];
    
    
    self.avatorView = avatorView;
    [self.bgAvatorView addSubview:avatorView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = [UIColor whiteColor];
    [self.bgAvatorView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    UIImage *image =  [UIImage imageNamed:@"icon_right_arrow"];
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[image xp_imageWithColor:[UIColor whiteColor]]];
    
    [self.bgAvatorView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithDisplayP3Red:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    self.bottomView = bottomView;
    [self.bgImageView addSubview:bottomView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgImageView.frame = CGRectMake(0, 0, self.width, self.height-30);
    CGFloat bgAvatorViewH = 60;
    CGFloat bgAvatorViewW = 200;
    CGFloat bgAvatorViewX = 20;
    CGFloat bgAvatorViewY = self.height-160;
//    self.center.y - bgAvatorViewH/2;
    self.bgAvatorView.frame = CGRectMake(bgAvatorViewX, bgAvatorViewY, bgAvatorViewW, bgAvatorViewH);

    
    self.avatorView.frame = CGRectMake(0, 0, bgAvatorViewH, bgAvatorViewH);
    self.avatorView.layer.cornerRadius = bgAvatorViewH/2;
    self.avatorView.layer.masksToBounds = YES;
    
   
    self.nameLabel.center = CGPointMake(0, CGRectGetMidY(self.avatorView.frame));
    self.nameLabel.x = CGRectGetMaxX(self.avatorView.frame)+5;
    [self.nameLabel sizeToFit];
    
    CGFloat arrowImageViewH = 20;
    CGFloat arrowImageViewW = 20;
    self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMidY(self.nameLabel.frame)-arrowImageViewH/2, arrowImageViewW, arrowImageViewH);
    
    
    self.bottomView.frame = CGRectMake(0, self.height-30, self.width, 30);
    
}
- (void)tap:(UITapGestureRecognizer*)sender{
    
    
    if ([self.delegate respondsToSelector: @selector(unLoginView:avatorViewClick:)]){
        [self.delegate unLoginView:self avatorViewClick:self.bgAvatorView];
    }
}
@end
