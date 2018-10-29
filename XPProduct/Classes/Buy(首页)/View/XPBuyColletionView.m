//
//  XPBuyColletionView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyColletionView.h"
@interface XPBuyColletionView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) NSArray *categoryData;
@property (nonatomic,strong) NSArray<XPBuyCategoryModel *> *modelArr;
@end
static NSString * buyCollectionCellID = @"buyCollectionCellID";

@implementation XPBuyColletionView
- (NSArray<XPBuyCategoryModel *> *)modelArr{
    if (_modelArr == nil){
         _modelArr = [XPBuyCategoryModel mj_objectArrayWithKeyValuesArray:self.categoryData];
    }
    return _modelArr;
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout categoryData:(NSArray *)data {
   
    if (self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"XPBuyCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:buyCollectionCellID];
        self.categoryData = data;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XPBuyCategoryCollectionViewCell *cell =  [self  dequeueReusableCellWithReuseIdentifier:buyCollectionCellID forIndexPath:indexPath];
    cell.categoryModel = self.modelArr[indexPath.row];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.categoryData.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.collDelegate respondsToSelector:@selector(buyCollectionView:didSelectedIndexPath:title: isFirstCollectionView:)]){
        XPBuyCategoryModel *model  = self.modelArr[indexPath.row];
        BOOL isFirstCollectionView = self.categoryData.count == 6 ? NO: YES;
        [self.collDelegate buyCollectionView:(XPBuyColletionView *)collectionView didSelectedIndexPath:indexPath title:model.title isFirstCollectionView:isFirstCollectionView];
    }
    
}


@end
