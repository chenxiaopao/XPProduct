//
//  XPBuyInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/24.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyInfoTableViewCell.h"
#import "XPSupplyModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XPBuyInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@end

@implementation XPBuyInfoTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPSupplyModel *)model{
    _model = model;
    if ([model.name containsString:@","]){
        self.titleLabel.text =  [[model.name componentsSeparatedByString:@","] lastObject];
    }else{
        self.titleLabel.text = model.name;
    }
//    self.titleLabel.text =  model.name;
    self.userName.text = model.user_name;
    self.address.text = model.address;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",model.price];
    if ([model.saleTime isEqualToString:@"现货"]){
        self.publishTimeLabel.text = model.saleTime;
    }else{
        self.publishTimeLabel.text = [NSString stringWithFormat:@"预售:%@",model.saleTime];
    }
    if (model.images.count>0){
        [self.avatarView sd_setImageWithURL:model.images[0]];
    }
}
@end
