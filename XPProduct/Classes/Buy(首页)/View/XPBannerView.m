//
//  XPBannerView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/10.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBannerView.h"

@interface XPBannerView () <UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIImageView *leftImageView;
@property (nonatomic,weak) UIImageView *middleImageView;
@property (nonatomic,weak) UIImageView *rightImageView;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic,weak) NSTimer *timer;
@end
int currentIndex;
CGFloat offsetX;

@implementation XPBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setUI];
//        [self addTimer];
        
    }
    return self;
}




- (void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    UIImageView *leftImageView = [[UIImageView alloc]init];
    [scrollView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UIImageView *middleImageView = [[UIImageView alloc]init];
    [scrollView addSubview:middleImageView];
    self.middleImageView = middleImageView;
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    [scrollView addSubview:rightImageView];

    self.rightImageView = rightImageView;
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [scrollView addGestureRecognizer:tap];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeTimer) name:removoTimerNotification object:nil];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(bannerView:didSelectedIndex:)]){
        [self.delegate bannerView:self didSelectedIndex:currentIndex ];
    }
}

- (void)addTimer{
//    XPWeakProxy *proxy = [XPWeakProxy proxyWithTarget:self];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];

    self.timer = timer;
}

- (void)nextPage{
    int count = (int)self.imageArr.count;
    currentIndex++;
    if (currentIndex== count){
        currentIndex = 0;
    }
    [self reloadImageWithCount:count currentIndex:currentIndex];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(width*3, height);
    //滚动到中间
    self.scrollView.contentOffset = CGPointMake(width, 0);
    
    self.leftImageView.frame = CGRectMake(0, 0, width, height);
    
    self.middleImageView.frame = CGRectMake(width, 0, width, height);
    
    self.rightImageView.frame = CGRectMake(width*2, 0, width, height);
    
    self.pageControl.frame = CGRectMake((width-80)/2, height-15, 80, 15);
    self.pageControl.numberOfPages = self.imageArr.count;
}

- (void)setImageArr:(NSArray<NSString *> *)imageArr{
    _imageArr = imageArr;
    currentIndex = 0;
    self.pageControl.currentPage = currentIndex;
    int count = (int)imageArr.count;
    self.leftImageView.image = [UIImage imageNamed: imageArr[count-1]];
    self.middleImageView.image = [UIImage imageNamed:imageArr[0]];
    self.rightImageView.image = [UIImage imageNamed:imageArr[1]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    offsetX = scrollView.contentOffset.x;
    [self removeTimer];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (fabs(offsetX-scrollView.contentOffset.x)>self.width/2){
        int count = (int)self.imageArr.count;
        //向右滑动
        if (scrollView.contentOffset.x>self.width){
            currentIndex = (currentIndex+1)%count;
        }else{
            currentIndex = (currentIndex-1+count)%count;
        }
       
        [self reloadImageWithCount:count currentIndex:currentIndex];
    }
}

- (void)reloadImageWithCount:(int)count currentIndex:(int)currentIndex{
    int leftIndex = (currentIndex-1+count)%count;
    int rightIndex = (currentIndex+1)%count;
    
    self.leftImageView.image = [UIImage imageNamed:self.imageArr[leftIndex]];
    self.middleImageView.image = [UIImage imageNamed:self.imageArr[currentIndex]];
    self.rightImageView.image = [UIImage imageNamed:self.imageArr[rightIndex]];
    
    //滚动到中间
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.pageControl.currentPage = currentIndex;
}
@end
