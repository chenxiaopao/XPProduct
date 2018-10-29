//
//  XPSalePublishImageCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSalePublishImageCell.h"

@interface XPSalePublishImageCell ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation XPSalePublishImageCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.closeBtn.userInteractionEnabled = YES;
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(salePublishImageCell:didSelectedCloseBtnIndex:)]){
        [self.delegate salePublishImageCell:self didSelectedCloseBtnIndex:self.index];
    }
}
- (void)setIsHideBtn:(BOOL)isHideBtn{
    _isHideBtn = isHideBtn;
    [self.closeBtn setHidden:isHideBtn];
    
}
@end
