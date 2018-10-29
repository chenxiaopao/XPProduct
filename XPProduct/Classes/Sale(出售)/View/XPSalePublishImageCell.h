//
//  XPSalePublishImageCell.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPSalePublishImageCell ;
@protocol XPSalePublishImageCellDelegate <NSObject>
- (void)salePublishImageCell:(XPSalePublishImageCell *)cell didSelectedCloseBtnIndex:(NSInteger)index;
@end

@interface XPSalePublishImageCell : UICollectionViewCell
@property (nonatomic,weak) id<XPSalePublishImageCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,assign) BOOL isHideBtn;
@property (nonatomic,assign) NSInteger index;
@end
