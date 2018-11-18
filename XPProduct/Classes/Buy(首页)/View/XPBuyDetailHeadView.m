//
//  XPBuyDetailHeadView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailHeadView.h"
#import "UIView+XPViewFrame.h"
#import "XPBuyDetailHeadViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XPBuyDetailHeadView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,weak) UILabel *countLabel;
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,weak) UILabel *rightLabel;
@property (nonatomic,assign) CGFloat offsetX;
@end
static NSString *const BuyImageCellID = @"BuyImageCellID";
@implementation XPBuyDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr{
    if (self = [super initWithFrame:frame]){
        self.imageArr = imageArr;
        [self setCollectionView];
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width, 0, 30, self.height)];
        rightLabel.text = @"跳转到图片详情";
        rightLabel.numberOfLines = 0;
        rightLabel.lineBreakMode = NSLineBreakByWordWrapping;
        rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel = rightLabel;
        [self addSubview:rightLabel];
        
    }
    return self;
}


- (void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.frame.size;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width,self.height) collectionViewLayout:layout];
    [collectionView registerClass:[XPBuyDetailHeadViewCell class] forCellWithReuseIdentifier:BuyImageCellID];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bouncesZoom = NO;
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-70, CGRectGetMaxY(self.frame)-30, 60, 20)];
    countLabel.text = [NSString stringWithFormat:@"1/%d",(int)self.imageArr.count];
    countLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    countLabel.layer.cornerRadius = countLabel.height/2;
    countLabel.layer.masksToBounds = YES;
    countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel = countLabel;
    [self addSubview:countLabel];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XPBuyDetailHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BuyImageCellID forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.imageArr[indexPath.row]];
//    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.item]];
    
    return cell;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    int page = offsetX/self.width;
    self.countLabel.text = [NSString stringWithFormat:@"%d/%d",page+1,(int)self.imageArr.count];

    CGFloat width = self.collectionView.contentSize.width;
    if (scrollView.contentOffset.x >= width-self.width){
        CGFloat offsetX = fmod(scrollView.contentOffset.x, self.width);
        self.offsetX = offsetX;
        self.rightLabel.x = (self.width - offsetX);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
        if(self.offsetX > 60){
            if ([self.delegate respondsToSelector:@selector(buyDetailHeadView:)]){
                [self.delegate buyDetailHeadView:self];
            }
        }
    
}
@end
