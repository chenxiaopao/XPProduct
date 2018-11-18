//
//  XPBuyDetailProductInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailProductInfoTableViewCell.h"
#import "XPSupplyModel.h"
#import "NSString+XPCalculateTimeSt.h"
@interface XPBuyDetailProductInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation XPBuyDetailProductInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPSupplyModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.standardLabel.text = model.standard;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f" ,model.price];
    self.countLabel.text = model.count;
    
    if ([model.saleTime isEqualToString:@"现货"]){
        self.saleTimeLabel.text = model.saleTime;
    }else{
        self.saleTimeLabel.text = [NSString stringWithFormat:@"预售:%@",model.saleTime];
    }
    self.publishTimeLabel.text = [NSString timeStringWithDateStr:model.publishTime];
    self.descriptionLabel.text = model.descriptions;
    self.addressLabel.text = model.address;
}
@end
