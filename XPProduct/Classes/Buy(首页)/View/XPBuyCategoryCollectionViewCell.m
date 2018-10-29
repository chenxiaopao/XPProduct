//
//  XPBuyCategoryCollectionViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyCategoryCollectionViewCell.h"
@interface XPBuyCategoryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation XPBuyCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setCategoryModel:(XPBuyCategoryModel *)categoryModel{
    _categoryModel = categoryModel;
    
    self.imageView.image = [UIImage imageNamed:categoryModel.imageName];
    self.titleLabel.text = categoryModel.title;
 
    
    
}

@end
