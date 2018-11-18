
//
//  XPPageView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/30.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPPageView.h"
#import "UIView+XPViewFrame.h"
//@class contentView;
//@protocol ContentViewDelegate <NSObject>
//- (void)contentView:(contentView *)contentView progress:(CGFloat)progress
//@end
@interface XPPageView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray<UIViewController *> *childVcs;
@property (nonatomic,weak) UIViewController *parentVc;
@property (nonatomic,weak) UIView *scrollLine;
@property (nonatomic,weak) UILabel *selectedLabel;
@property (nonatomic,weak) UIScrollView *titleView;
@property (nonatomic,weak) UICollectionView *contentView;
@property (nonatomic,assign) CGFloat startOffset;
@property (nonatomic,assign) BOOL canScroll;
@end
static BOOL isTap = false;
static int const labelTag = 2625;
static NSString *const contentID = @"contentID";
@implementation XPPageView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr childVcs:(NSArray *)childVcs parentVc:(UIViewController *)parentVc contentViewCanScroll:(BOOL)canScroll{
    self = [super initWithFrame:frame];
    if (self) {
        self.canScroll = canScroll;
        self.titleArr = titleArr;
        self.childVcs = childVcs;
        self.parentVc = parentVc;
        [self setTitleView];
        [self setContentView];
    }
    return self;
}

#pragma mark - 设置contentView
- (void)setContentView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    layout.itemSize = CGSizeMake(self.width, self.height-self.titleView.height);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.titleView.height, self.width, self.height-self.titleView.height) collectionViewLayout:layout];
    
    NSLog(@"%@",NSStringFromCGRect(collectionView.frame));
    if (!self.canScroll){
        collectionView.scrollEnabled = NO;
    }
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentSize = CGSizeMake(self.childVcs.count *self.width, 0);
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentID];
    self.contentView = collectionView;
    [self addSubview:collectionView];
    
    for (UIViewController *vc in self.childVcs) {
        [self.parentVc addChildViewController:vc];
        vc.view.frame = collectionView.bounds;
    }
    
}
#pragma mark - 设置titleView
- (void)setTitleView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    CGFloat width = 0;
    CGFloat height = scrollView.height-1;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (self.titleArr.count > 6){
        width = 60;
    }else{
        width = self.width/self.titleArr.count;
    }
    scrollView.contentSize = CGSizeMake(width *self.titleArr.count, 0);
   
    for (int i=0; i<self.titleArr.count; i++) {
        x = i*width;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
        if(i == 0){
            self.selectedLabel = label;
            label.textColor = [UIColor greenColor];
        }
        label.tag = labelTag + i;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label addGestureRecognizer:tap];
        label.text = self.titleArr[i];
        [scrollView addSubview:label];
    }
    
    UIView *scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, scrollView.height-1.5, width, 1)];
    scrollLine.backgroundColor = [UIColor greenColor];
    self.scrollLine = scrollLine;
    [scrollView addSubview:scrollLine];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, scrollView.height-0.5, self.width, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:bottomLine];
    
    
    self.titleView = scrollView;
    [self addSubview:scrollView];
}


- (void)labelTap:(UITapGestureRecognizer *)tap{
    isTap = true;
    UILabel *label = (UILabel *)tap.view;
    if (label.tag == self.selectedLabel.tag){
        return ;
    }
//    NSInteger index =  label.tag - labelTag;
    [self adjustscrollLineAndContentViewOffsetWithLabel:label];
    [self adjustLabelTextColor:label];
//    NSString *title = self.titleArr[index];
    
    
}

- (void)adjustLabelTextColor:(UILabel *)label{
    label.textColor = [UIColor greenColor];
    self.selectedLabel.textColor = [UIColor blackColor];
    self.selectedLabel = label;
}

- (void)adjustscrollLineAndContentViewOffsetWithLabel:(UILabel *)label {
    
    NSInteger index = label.tag - labelTag;
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollLine.x = label.width * index;
    }];
    
    [self.contentView setContentOffset:CGPointMake(self.contentView.width * index, 0)];
}
#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *view  = self.childVcs[indexPath.item].view;
    view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:view];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isTap = false;
    self.startOffset = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isTap){
        return ;
    }
    CGFloat offset = scrollView.contentOffset.x - self.startOffset;
    CGFloat progress = (offset)/self.contentView.width;
    int currentIndex = self.startOffset / self.contentView.width;
    int targetIndex ;
    if (offset > 0){
        targetIndex = currentIndex + 1;
        if (targetIndex >= self.childVcs.count){
            targetIndex = (int)self.childVcs.count - 1;
        }
    }else{
        targetIndex = currentIndex - 1;
        if (targetIndex < 0){
            targetIndex = 0;
        }
    }
//    NSLog(@"%d,%d",currentIndex,targetIndex);
    
    UILabel *currentLabel = [self viewWithTag:labelTag+currentIndex];
    UILabel *targetLabel = [self viewWithTag:labelTag+targetIndex ];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollLine.x = currentLabel.width * progress + currentLabel.x ;
    }];
    CGFloat greenDelta =  255.0*progress;
    if (progress > 0){
        targetLabel.textColor = [UIColor colorWithRed:0 green:greenDelta/255.0 blue:0 alpha:1];
        currentLabel.textColor = [UIColor colorWithRed:0 green:(255-greenDelta)/255.0 blue:0 alpha:1];
        
    }else{
        targetLabel.textColor = [UIColor colorWithRed:0 green:-greenDelta/255.0 blue:0 alpha:1];
        currentLabel.textColor = [UIColor colorWithRed:0 green:(255+greenDelta)/255.0 blue:0 alpha:1];
        
    }

}

@end
