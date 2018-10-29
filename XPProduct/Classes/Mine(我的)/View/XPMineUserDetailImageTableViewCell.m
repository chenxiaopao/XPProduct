//
//  XPMineUserDetailImageTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineUserDetailImageTableViewCell.h"
#import "XPMineModel.h"
#import "UIView+XPViewFrame.h"
#import "UIImage+XPOriginImage.h"
@interface XPMineUserDetailImageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;

@end

@implementation XPMineUserDetailImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatorView.layer.cornerRadius = self.avatorView.width/2;
    self.avatorView.layer.masksToBounds = YES;
}

- (void)setModel:(XPMineModel *)model{
    _model = model;
    self.avatorView.image = [UIImage getImageWithName:@"avatar"];
    self.titleName.text = model.title;
}


@end
