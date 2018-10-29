//
//  XPSaleInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSaleInfoTableViewCell.h"
#import "XPPurchaseModel.h"
@interface XPSaleInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrpitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation XPSaleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPPurchaseModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.descrpitionLabel.text = model.descriptions;
    self.publishTimeLabel.text = model.publishTime;
    self.countLabel.text = model.count;
    self.addressLabel.text = model.address;
}
@end
