//
//  XPMineUserDetailSubtitleTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineUserDetailSubtitleTableViewCell.h"
#import "XPMineModel.h"
@interface XPMineUserDetailSubtitleTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *subtitleName;

@end

@implementation XPMineUserDetailSubtitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPMineModel *)model{
    _model = model;
    self.subtitleName.text = [[NSUserDefaults standardUserDefaults] objectForKey:model.subTitle];
    
    self.titleName.text = model.title;
}


@end
