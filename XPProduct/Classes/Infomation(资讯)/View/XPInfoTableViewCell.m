//
//  XPInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/18.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPInfoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XPMessDetailModel.h"
@interface XPInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XPInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setModel:(XPMessDetailModel *)model{
    _model = model;
    NSString *imageStr = [NSString stringWithFormat:@"http://www.qqncpw.cn%@",model.information_img];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.nameLabel.text = model.information_title;
    self.timeLabel.text = model.create_time;
    
}


@end
