//
//  XPSalePublishImageCollectionView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPSalePublishImageCollectionView;
@protocol XPSalePublishImageCollectionViewDelegate <NSObject>
- (void)salePublishImageCollectionView:(XPSalePublishImageCollectionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)salePublishImageCollectionView:(XPSalePublishImageCollectionView *)collectionView didSelectedCloseBtnIndex:(NSInteger)index;
@end
@interface XPSalePublishImageCollectionView : UICollectionView
@property (nonatomic,weak) id<XPSalePublishImageCollectionViewDelegate> collDelegate;
@property (nonatomic,strong) NSArray *imageArr;
@end
