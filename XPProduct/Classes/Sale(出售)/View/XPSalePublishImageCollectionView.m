//
//  XPSalePublishImageCollectionView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSalePublishImageCollectionView.h"
#import "XPSalePublishImageCell.h"
@interface XPSalePublishImageCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,XPSalePublishImageCellDelegate>
@end

static NSString *salePublishImageCellID = @"salePublishImageCellID";
@implementation XPSalePublishImageCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self){
        [self registerNib:[UINib nibWithNibName:@"XPSalePublishImageCell" bundle:nil] forCellWithReuseIdentifier:salePublishImageCellID];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XPSalePublishImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:salePublishImageCellID forIndexPath:indexPath];
    if (indexPath.item == self.imageArr.count-1){
        cell.isHideBtn = YES;
    }
    cell.delegate =self;
    cell.index = indexPath.item;
    cell.imageView.image = self.imageArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collDelegate respondsToSelector:@selector(salePublishImageCollectionView:didSelectedIndexPath:)]){
        [self.collDelegate salePublishImageCollectionView:self didSelectedIndexPath:indexPath];
    }
}

#pragma mark - XPSalePublishImageCellDelegate
- (void)salePublishImageCell:(XPSalePublishImageCell *)cell didSelectedCloseBtnIndex:(NSInteger)index{
    if ([self.collDelegate respondsToSelector:@selector(salePublishImageCollectionView:didSelectedCloseBtnIndex:)]){
        [self.collDelegate salePublishImageCollectionView:self didSelectedCloseBtnIndex:index];
    }
   
    
}
@end
