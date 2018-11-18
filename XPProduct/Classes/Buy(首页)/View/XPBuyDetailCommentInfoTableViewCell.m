//
//  XPBuyDetailCommentInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailCommentInfoTableViewCell.h"
#import "XPCommentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XPBuyDetailCommentInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation XPBuyDetailCommentInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPCommentModel *)model{
    _model =  model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString: model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    self.nameLabel.text = model.user_name;
    self.content.text = model.content;
}

@end
