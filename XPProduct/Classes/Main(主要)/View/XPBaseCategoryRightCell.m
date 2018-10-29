//
//  XPBaseCategoryRightCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBaseCategoryRightCell.h"
@interface XPBaseCategoryRightCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end
static NSString *const categoryRightCollectionCellID = @"categoryRightCollectionCellID";
@implementation XPBaseCategoryRightCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}


- (UICollectionView *)collectionView{
    if (_collectionView==nil){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((self.width-80)/3, 50);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource =self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.scrollEnabled = NO;
        collectionView.contentInset= UIEdgeInsetsMake(0, 10, 0, 10);
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:categoryRightCollectionCellID];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (void)setRightCellData:(NSArray *)rightCellData{
    _rightCellData = rightCellData;
    [self.collectionView reloadData];
    self.collectionView.frame = self.contentView.bounds;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rightCellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryRightCollectionCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    label.layer.cornerRadius = 5;
    label.frame = cell.contentView.bounds;
    label.userInteractionEnabled = YES;
    label.text = self.rightCellData[indexPath.row];
    if (label.text.length >4){
        [label setFont:[UIFont systemFontOfSize:12]];
    }else{
        [label setFont:[UIFont systemFontOfSize:15]];
    }
    [cell.contentView addSubview:label];
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableString *title = self.rightCellData[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(baseCategoryRightCell:didselectedTitle:)]){
        [self.delegate baseCategoryRightCell:self didselectedTitle:title];
    }
   
}

@end
