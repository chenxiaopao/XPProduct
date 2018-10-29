//
//  XPBuyDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyDetailViewController.h"
#import <WebKit/WebKit.h>
#import "XPConst.h"
#import "XPBuyDetailHeadView.h"
#import "XPBuyDetailProductInfoTableViewCell.h"
#import "XPBuyDetailUserInfoTableViewCell.h"
#import "XPBuyDetailCommentInfoTableViewCell.h"
#import "UIView+XPViewFrame.h"
#import "XPMineUserCardViewController.h"
#import "XPBuyCommentViewController.h"

@interface XPBuyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,XPBuyDetailHeadViewDelegate>
@property (nonatomic,weak) UIView *alphaView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) WKWebView *webView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat tableViewContentSizeHeight;
@property (nonatomic,assign) CGFloat webViewContentSizeHeight;
@end

static NSString *const productInfoCellID = @"productInfoCellID";
static NSString *const userInfoCellID = @"userInfoCellID";
static NSString *const commentInfoCellID = @"commentInfoCellID";
@implementation XPBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewAndWebView];
    [self setTableHeadViewAndFooterView];
    [self addAlphaView];
    [self addObserver];
    [self addBottomView];
  
}

- (void)addBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, XP_SCREEN_HEIGHT-60, XP_SCREEN_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.width, 1)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, (bottomView.width-20)/3, 40)];
    commentBtn.backgroundColor = [UIColor lightGrayColor];
    [self setBtnRadiusWithBtn:commentBtn androundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [commentBtn setTitle:@"添加评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame), commentBtn.y,(bottomView.width-20)/3, commentBtn.height)];
    [collectBtn setTitle:@"添加收藏" forState:UIControlStateNormal];
    collectBtn.backgroundColor = [UIColor blueColor];
    [collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(collectBtn.frame), commentBtn.y,(bottomView.width-20)/3, commentBtn.height)];
    [callBtn setTitle:@"打电话" forState:UIControlStateNormal];
    callBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:120/255.0 blue:17/255.0 alpha:1];
    [self setBtnRadiusWithBtn:callBtn androundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:topLine];
    [bottomView addSubview:commentBtn];
    [bottomView addSubview:collectBtn];
    [bottomView addSubview:callBtn];
}

- (void)callBtnClick:(UIButton *)sender{
    NSMutableString * phoneNumber=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1001011"];
    WKWebView * webView = [[WKWebView alloc] init];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    [self.view addSubview:webView];
}

- (void)commentBtnClick:(UIButton *)sender{
    XPBuyCommentViewController *vc =[[XPBuyCommentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)collectBtnClick:(UIButton *)sender{
    NSLog(@"收藏");
}
-(void)setBtnRadiusWithBtn:(UIButton *)btn androundingCorners:(UIRectCorner )corner{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners: corner cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = btn.bounds;
    layer.path = bezierPath.CGPath;
    btn.layer.mask = layer;
}

- (void)addObserver{
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self setScrollViewContentSize];
}

- (void)setScrollViewContentSize{
    CGFloat tableViewContentSizeHeight =  self.tableView.contentSize.height;
    CGFloat webViewContentSizeHeight =  self.webView.scrollView.contentSize.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, tableViewContentSizeHeight+webViewContentSizeHeight);
    self.tableViewContentSizeHeight = tableViewContentSizeHeight;
    self.webViewContentSizeHeight = webViewContentSizeHeight;
//    NSLog(@"%f,%f",tableViewContentSizeHeight,webViewContentSizeHeight);
}

-(void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)setTableHeadViewAndFooterView{
    NSArray *imageArr = @[@"boluo",@"nihoutao",@"tudou",@"caomei"];
    XPBuyDetailHeadView *headView = [[XPBuyDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT/2) imageArr:imageArr];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 40)];
    footerView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, XP_SCREEN_WIDTH, 20)];
    footerLabel.text = @"---图片详情---";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLabel];
    self.tableView.tableFooterView = footerView;
}

- (void)addAlphaView{
    UIView *alphaView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 100)];
    alphaView.backgroundColor = [UIColor greenColor];
    alphaView.alpha =0;
    
    self.alphaView = alphaView;
    [self.view addSubview:alphaView];

}

- (void)setTableViewAndWebView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT*2)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate =self;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:@"XPBuyDetailProductInfoTableViewCell" bundle:nil] forCellReuseIdentifier:productInfoCellID];
    [tableView registerNib:[UINib nibWithNibName:@"XPBuyDetailUserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:userInfoCellID];
    [tableView registerNib:[UINib nibWithNibName:@"XPBuyDetailCommentInfoTableViewCell" bundle:nil] forCellReuseIdentifier:commentInfoCellID];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, XP_SCREEN_HEIGHT, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT) configuration:config];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/3721d736cf68"]]];
    webView.backgroundColor = [UIColor blueColor];
    self.webView = webView;
    
    if iOS11_LATER{
        [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else if iOS7_LATER{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [scrollView addSubview:tableView];
    [scrollView addSubview:webView];
    tableView.scrollEnabled = NO;
    webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (offsetY <= 100){
        self.alphaView.alpha = offsetY/100 * 1;
        self.navigationItem.title = @"";
    }else{
        self.navigationItem.title = @"名称";
        self.alphaView.alpha =  1;
    }
    CGFloat tableViewHeight = self.tableView.height;
    CGFloat webViewHeight = self.webView.height;
    if (scrollView != self.scrollView){
        return ;
    }
//    NSLog(@"%f",offsetY);
    self.webView.top = self.tableView.bottom;
    if (offsetY <= 0 ){
        self.tableView.contentOffset = CGPointZero;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.y = 0;
    }else if (offsetY < self.tableViewContentSizeHeight - tableViewHeight){
        self.tableView.y = offsetY;
        self.tableView.contentOffset = CGPointMake(0, offsetY);
        self.webView.scrollView.contentOffset = CGPointZero;
    }else if (offsetY < self.tableViewContentSizeHeight){
        self.tableView.y = self.tableViewContentSizeHeight-tableViewHeight;
        self.tableView.contentOffset = CGPointMake(0, self.tableViewContentSizeHeight-tableViewHeight);
        self.webView.scrollView.contentOffset =CGPointZero;
    }else if (offsetY < self.tableViewContentSizeHeight + self.webViewContentSizeHeight-webViewHeight){
        self.tableView.contentOffset = CGPointMake(0, self.tableViewContentSizeHeight-tableViewHeight);
        self.webView.y = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
    }else if (offsetY <= self.webViewContentSizeHeight+self.tableViewContentSizeHeight){
        self.tableView.contentOffset = CGPointMake(0, self.tableViewContentSizeHeight-tableViewHeight);
        self.webView.y = self.webViewContentSizeHeight+self.tableViewContentSizeHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, self.webViewContentSizeHeight+self.tableViewContentSizeHeight);
    }
    
}

#pragma mark - UITableView协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            XPBuyDetailProductInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productInfoCellID];
            
            return cell;
            break;
        }
        case 1:{
            XPBuyDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellID];
            return cell;
            break;
        }
        case 2:{
            XPBuyDetailCommentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellID];
            
            return cell;
            break;
        }
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 175;
    }else if (indexPath.section == 1){
        return 125;
    }else {
        return 145;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2){
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 15)];
    view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    return  view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.notCanSelected){
        return;
    }
    if (indexPath.section == 1){
        XPMineUserCardViewController *vc = [[XPMineUserCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if(indexPath.section==2){
        XPBuyCommentViewController *vc =[[XPBuyCommentViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


#pragma mark - XPBuyDetailHeadViewDelegate
- (void)buyDetailHeadView:(XPBuyDetailHeadView *)headView{
    CGFloat y = self.tableViewContentSizeHeight-40-self.alphaView.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, y);
    }];
}
@end
