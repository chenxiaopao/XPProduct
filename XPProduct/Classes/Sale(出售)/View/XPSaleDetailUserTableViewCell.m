//
//  XPSaleDetailUserTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/29.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSaleDetailUserTableViewCell.h"
#import "UIView+XPViewFrame.h"
#import "XPPurchaseModel.h"
#import "UIImage+XPOriginImage.h"
@interface XPSaleDetailUserTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@end

@implementation XPSaleDetailUserTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.avatorView.layer.cornerRadius = self.avatorView.width/2;
    self.avatorView.layer.masksToBounds = YES;
}

- (void)setPurchaseModel:(XPPurchaseModel *)purchaseModel{
    _purchaseModel = purchaseModel;
    self.avatorView.image = [UIImage getImageWithName:@"avatar"];
    self.titleName.text = purchaseModel.user_name;
}
@end
