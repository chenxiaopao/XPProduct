//
//  XPBuyColletionView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBuyCategoryCollectionViewCell.h"
#import "XPBuyCategoryModel.h"
#import "MJExtension.h"

@class XPBuyColletionView;
@protocol XPBuyCollectionViewDelegate <NSObject>
- (void)buyCollectionView:(XPBuyColletionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath title:(NSString *)title isFirstCollectionView:(BOOL)isFirstCollectionView;
@end

@interface  XPBuyColletionView : UICollectionView
@property (nonatomic,weak) id<XPBuyCollectionViewDelegate> collDelegate;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout categoryData:(NSArray *)data ;
@end
