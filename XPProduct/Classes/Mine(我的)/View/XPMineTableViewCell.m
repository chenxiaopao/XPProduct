//
//  XPMineTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineTableViewCell.h"
#import "XPCommentAndSupplyModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+XPViewFrame.h"
@interface XPMineTableViewCell () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation XPMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(middleViewTap:)];
    [self.middleView addGestureRecognizer:tap];
    tap.delegate = self;
    self.middleView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];

    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.avatar.layer.cornerRadius = 25;
    self.avatar.layer.masksToBounds = YES;
}

- (void)middleViewTap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(mineTableViewCell:disSelectedSupplyId:)]){
        [self.delegate mineTableViewCell:self disSelectedSupplyId:self.model.topic_id];
    }
}


- (void)setModel:(XPCommentAndSupplyModel *)model{
    _model = model;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString: model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    self.userNameLabel.text = model.user_name;
    self.commentLabel.text = model.content;
    self.timeLabel.text = model.time;
    self.productName.text = model.product_name;
    NSMutableArray *arr =[NSMutableArray arrayWithArray: [model.images componentsSeparatedByString:@","]];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString: arr[0]] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    self.commentLabel.height = [self getHeightWithString:model.content andFont:[UIFont systemFontOfSize:15] andWidth:self.commentLabel.width];
    
}

- (CGFloat)getHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return height;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[touch.view class]);
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ){
        return NO;
    }
    return YES;
}

@end
