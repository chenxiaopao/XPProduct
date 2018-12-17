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
#import "XPSupplyModel.h"
#import "WebViewJavascriptBridge.h"
#import "SDWebImageManager.h"
#import "XPAlertTool.h"
#import "XPNetWorkTool.h"
#import "XPCollectBrowseModel.h"
#import <MJExtension/MJExtension.h>
#import "XPBuyNoCommentView.h"
#import "XPCommentModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface XPBuyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,XPBuyDetailHeadViewDelegate,XPBuyNoCommentViewDelegate>

@property (nonatomic,weak) UIView *alphaView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat tableViewContentSizeHeight;
@property (nonatomic,assign) CGFloat webViewContentSizeHeight;
@property (nonatomic,strong) NSArray *commentModelArr;
@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@property (nonatomic,strong) XPCollectBrowseModel *collectBrowseModel;
@property (nonatomic,strong) UIImage *shadowImage;
@property (nonatomic,weak) UIButton *collectBtn;
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIView *bgView;
@property (nonatomic,weak) MBProgressHUD *hud;
@property (nonatomic,weak) UIView *coverView;
@end


static NSString *const productInfoCellID = @"productInfoCellID";
static NSString *const userInfoCellID = @"userInfoCellID";
static NSString *const commentInfoCellID = @"commentInfoCellID";

CGFloat pinchChangeValue;
CGPoint panChangeValueOld;

@implementation XPBuyDetailViewController

- (instancetype)initWithhSupplyModel:(XPSupplyModel *)model
{
    self = [super init];
    if (self ) {
        self.supplyModel = model;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]){
            [self loadCollectDataWithProduct_id:self.supplyModel._id];
            [self loadHistoryDataWithProduct_id:self.supplyModel._id];
            [self loadCommentDataWithProduct_id:self.supplyModel._id];
        }

    }
    return self;
}

- (void)loadCommentDataWithProduct_id:(NSInteger)product_id{
    [[XPNetWorkTool shareTool]loadCommentInfoWithProduct_Id:product_id UserId:0 andCallback:^(NSArray * modelArr) {
        self.commentModelArr = [XPCommentModel mj_objectArrayWithKeyValuesArray:modelArr];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)loadHistoryDataWithProduct_id:(NSInteger)product_id{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *timeTitle = [dateFormatter stringFromDate:[NSDate new]];
    NSDictionary *dict = @{
                           @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"state":@"1",
                           @"product_id":@(product_id),
                           @"tableType":@"0",
                           @"browseTime":timeTitle,
                           @"type":@"1"
                           };
    //    __weak typeof(self) weakSelf = self;s
    
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(id obj) {
        
    }];
    
}

- (void)loadCollectDataWithProduct_id:(NSInteger)product_id{
    
    NSDictionary *dict = @{
                           @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                           @"state":@"1",
                           @"product_id":@(product_id),
                           @"findOne":@"1",
                           @"tableType":@"1",
                           @"type":@"1"
                           };
    [XPCollectBrowseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];
    
    
    __weak typeof(self) weakSelf = self;
    
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(id obj) {
        if (obj){
            weakSelf.collectBrowseModel = [XPCollectBrowseModel mj_objectWithKeyValues:obj];
            [weakSelf setCollectBtnTitle];
        }
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableViewAndWebView];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:self.shadowImage];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setHud];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewLoad) name:@"loadFinished" object:nil];
    
}

- (void)webViewLoad{
    
    [self setTableHeadViewAndFooterView];
    [self addAlphaView];
    [self addObserver];
    [self addBottomView];
    self.shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    //    self.navigationController.navigationBar.translucent =  YES;
    [self loadCommentDataWithProduct_id:self.supplyModel._id];
    self.hud.label.text = @"加载成功";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
        [self.coverView removeFromSuperview];
    });
    
    
}


- (void)setHud{
    UIView *coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor whiteColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.coverView = coverView;
    [window addSubview:coverView];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:coverView animated:YES];
    hud.label.text = @"正在加载中";
    hud.mode = MBProgressHUDModeIndeterminate;
    self.hud = hud;
}

- (void)addBigImageView{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    self.imageView = imageView;
    imageView.center = self.view.center;
    imageView.backgroundColor = [UIColor blackColor];
//    imageView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImageView)];
    //缩放手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [imageView addGestureRecognizer:pinch];
    
    //移动手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [imageView addGestureRecognizer:pan];
    
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    [bgView addGestureRecognizer:tap];
    [bgView addSubview:imageView];
    imageView.center = bgView.center;
    [imageView sizeToFit];
    imageView.bounds = CGRectMake(0, 0, XP_SCREEN_WIDTH, 300);
    self.bgView = bgView;
    [window addSubview:bgView];
}

-(void)pinchAction:(UIPinchGestureRecognizer *)sender{

    if (sender.state == UIGestureRecognizerStateBegan) {
        pinchChangeValue = 1;
        return;
    }
    CGFloat change = 1 - (pinchChangeValue - sender.scale);
    sender.view.transform = CGAffineTransformScale(sender.view.transform, change, change);
    pinchChangeValue = sender.scale;
}

-(void)panAction:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        panChangeValueOld = sender.view.center;
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        
        
        float newY = panChangeValueOld.y + translation.y;
        float newX = panChangeValueOld.x + translation.x;
        sender.view.center = CGPointMake(newX, newY);
    }
    
}


- (void)hideImageView{
    [UIView animateWithDuration:0.5 animations:^{
        
        
//        self.imageView.alpha = 0;
        self.bgView.alpha = 0;
//        self.imageView.center = self.view.center;
//        self.imageView.frame = CGRectZero;
    
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
    }];
    
    
}


- (void)addBottomView{
    CGFloat frameY = XP_SCREEN_HEIGHT - 60;
    if (IS_IPHONE_X){
        frameY-=XP_BottomBar_Height;
    }
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frameY, XP_SCREEN_WIDTH, 60)];
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
    self.collectBtn = collectBtn;
    
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

- (void)setCollectBtnTitle{
    NSString *title = nil;
    if (self.collectBrowseModel.state == 1){
        title = @"取消收藏";
    }else{
        title = @"添加收藏";
    }
    [self.collectBtn setTitle:title forState:UIControlStateNormal];
}

- (void)callBtnClick:(UIButton *)sender{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]){
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue];
        if (self.supplyModel.user_id != userId){
            [XPAlertTool callToUserWithPhone:self.supplyModel.user_phone toView:self.view];
        }else{
            [XPAlertTool showAlertWithSupeView:self.view andText:@"不能对自己收藏或者打电话"];
        }
        
        
    }else{
        [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:self andSelectedIndex:0];
//        [XPAlertTool showAlertWithSupeView:self.view andText:@"请先登录"];
    }
    
}

- (void)commentBtnClick:(UIButton *)sender{
    
    XPBuyCommentViewController *vc =[[XPBuyCommentViewController alloc]init];
    vc.commentDataArr = self.commentModelArr;
    vc.product_id = self.supplyModel._id;
    vc.isShowTextField = YES;
    [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:vc andSelectedIndex:0];
//    [self.navigationController pushViewController:vc animated:NO];
}

- (void)collectBtnClick:(UIButton *)sender{
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue];
    if (self.supplyModel.user_id != userId){
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]){
            if (self.collectBrowseModel.state == 1){//state为1表示已收藏，当前显示为取消收藏
                [sender setTitle:@"添加收藏" forState:UIControlStateNormal];
                [self CollectActionIsAdd:NO];
            }else{
                [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
                [self CollectActionIsAdd:YES];
            }
        }else{
            [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:self andSelectedIndex:0];
//            [XPAlertTool showAlertWithSupeView:self.view andText:@"请先登录"];
        }
    }else{
        [XPAlertTool showAlertWithSupeView:self.view andText:@"不能对自己收藏或者打电话"];
    }
}

- (void)CollectActionIsAdd:(BOOL)isAdd{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    NSString *title;
    if (isAdd){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        NSString *timeTitle = [dateFormatter stringFromDate:[NSDate new]];
        NSDictionary *dict = @{
                               @"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                               @"product_id":[NSString stringWithFormat:@"%ld",(long)self.supplyModel._id],
                               @"tableType":@"1",
                               @"browseTime":timeTitle,
                               @"state":@"1",
                               @"type":@"1"
                               };
        title = @"添加成功";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"supplyRefreshing" object:nil];
        [mDict addEntriesFromDictionary:dict];
    }else{
        NSDictionary *dict = @{
                               @"id":[NSString stringWithFormat:@"%ld",(long)self.collectBrowseModel._id],
                               @"tableType":@"1",
                               @"type":@"0"
                               
                               };
        [mDict addEntriesFromDictionary:dict];
        title = @"取消成功";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"supplyRefreshing" object:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:mDict andCallBack:^(NSDictionary *dict) {
        [XPAlertTool showAlertWithSupeView:weakSelf.view andText:title];
        if (![dict objectForKey:@"success"]){
            [XPCollectBrowseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"_id":@"id"
                         };
            }];
            weakSelf.collectBrowseModel =  [XPCollectBrowseModel mj_objectWithKeyValues:dict];
        }else{
            weakSelf.collectBrowseModel  = nil;
        }
        
    }];
    
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
    if (IS_IPHONE_X){
        webViewContentSizeHeight += 40;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, tableViewContentSizeHeight+webViewContentSizeHeight);
    self.tableViewContentSizeHeight = tableViewContentSizeHeight;
    self.webViewContentSizeHeight = webViewContentSizeHeight;

//        self.scrollView.contentSize = CGSizeMake(0, tableViewContentSizeHeight+webViewContentSizeHeight+(XP_SCREEN_HEIGHT));
//    NSLog(@"%f,%f",tableViewContentSizeHeight,webViewContentSizeHeight);
}

-(void)dealloc{
    NSLog(@"%s",__func__);
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)setTableHeadViewAndFooterView{
    
    XPBuyDetailHeadView *headView = [[XPBuyDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT/2) imageArr:self.supplyModel.images];
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
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT-50)];
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
    [scrollView addSubview:tableView];
    
    
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, XP_SCREEN_HEIGHT, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT)];
    
    [scrollView addSubview:webView];
    self.webView = webView;
    [self.view addSubview:scrollView];
    [WebViewJavascriptBridge enableLogging];

    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self setWebViewDataByData:self.supplyModel.images];
    [self showDetailImage];
    
    if iOS11_LATER{
        [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else if iOS7_LATER{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    tableView.scrollEnabled = NO;
    webView.scrollView.scrollEnabled = NO;

    
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
    }else
//        if (offsetY < self.tableViewContentSizeHeight + self.webViewContentSizeHeight-webViewHeight)
    {
        self.tableView.contentOffset = CGPointMake(0, self.tableViewContentSizeHeight-tableViewHeight);
        self.webView.y = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY-self.tableViewContentSizeHeight);
        
    }
//    else if (offsetY <= self.webViewContentSizeHeight+self.tableViewContentSizeHeight){
//        self.tableView.contentOffset = CGPointMake(0, self.tableViewContentSizeHeight-tableViewHeight);
//        self.webView.y = self.webViewContentSizeHeight+self.tableViewContentSizeHeight;
//        self.webView.scrollView.contentOffset = CGPointMake(0, self.webViewContentSizeHeight+self.tableViewContentSizeHeight);
//    }
    
}



#pragma mark - UITableView协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            XPBuyDetailProductInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productInfoCellID];
            cell.model = self.supplyModel;
            return cell;
            break;
        }
        case 1:{
            XPBuyDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellID];
            cell.model = self.supplyModel;
            return cell;
            break;
        }
        case 2:{
            if (self.commentModelArr.count==0){
                XPBuyNoCommentView *commentView = [[XPBuyNoCommentView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 125)];
                commentView.delegate = self;
                commentView.selectionStyle = UITableViewCellSelectionStyleNone;
                return commentView;
            }else{
                XPBuyDetailCommentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentInfoCellID];
                cell.model = self.commentModelArr[0];
                
                return cell;
            }
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
   
    if (indexPath.section == 1){
        XPMineUserCardViewController *vc = [[XPMineUserCardViewController alloc]initWithName:self.supplyModel.user_name andAvatar:self.supplyModel.user_avatar andUser_id:self.supplyModel.user_id];
        
        [self.navigationController pushViewController:vc animated:NO];
    }else if(indexPath.section==2){
        if (self.commentModelArr.count > 0){
            XPBuyCommentViewController *vc =[[XPBuyCommentViewController alloc]init];
            vc.commentDataArr = self.commentModelArr;
            vc.product_id = self.supplyModel._id;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}


#pragma mark - XPBuyDetailHeadViewDelegate
- (void)buyDetailHeadView:(XPBuyDetailHeadView *)headView{
    CGFloat y = self.tableViewContentSizeHeight-40-self.alphaView.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, y);
    }];
}

#pragma mark - WebViewJavascriptBridge

- (void)showDetailImage{
    [self.bridge registerHandler:@"showDetailImage" handler:^(id data, WVJBResponseCallback responseCallback) {
   
        [self addBigImageView];
        NSDictionary *dict = (NSDictionary *)data;
        NSString *imageUrl = dict[@"key"];
        imageUrl = [imageUrl substringFromIndex:7];
        NSLog(@"我帅%@",imageUrl);
//        [UIView animateWithDuration:1 animations:^{
//            CGRect rect = CGRectMake(0, XP_StatusBar_Height, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT-(XP_StatusBar_Height));
//
//            self.imageView.frame = self.view.bounds;
//            self.imageView.alpha = 1;
            self.imageView.image = [UIImage imageWithContentsOfFile:imageUrl];
//        }];
    }];
    
}

- (void)setWebViewDataByData:(NSArray *)images{
    NSMutableString *allStr = [NSMutableString stringWithString:@""];
    for (NSString *imageUrl in images) {
        CGFloat width = XP_SCREEN_WIDTH -20;
        CGFloat Height = width *1.2;
        NSString *imageStr = [NSString stringWithFormat:@"<img src = 'loading' id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace='5'><hr/>",[self replaceUrlSpecialString:imageUrl],width,Height];
        [allStr appendString:imageStr];
        
        
    }
    [self setImageFromDownloaderOrDiskByImageUrlArray:images];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"webViewHtml" ofType:@"html"];
    NSMutableString *htmlStr = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [htmlStr replaceOccurrencesOfString:@"<p>news</p>" withString:allStr options:NSCaseInsensitiveSearch range: [htmlStr rangeOfString:@"<p>news</p>"]];
    [self.webView loadHTMLString:htmlStr baseURL:nil];
    if (images.count == 1){
        self.webView.height = (XP_SCREEN_WIDTH-20)*1.3;
    }
    
}

- (void)setImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray{
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    for (NSString *imageUrl in imageArray) {
        NSString *cacheKey = [imageManager cacheKeyForURL:[NSURL URLWithString:[self replaceUrlSpecialString:imageUrl]]];
        NSString *imagePath = [imageManager.imageCache cachePathForKey:cacheKey inPath:filePath];
        if ([imageManager.imageCache diskImageDataExistsWithKey:cacheKey]){
            NSString *jsData =[NSString stringWithFormat:@"replaceImage%@,%@",[self replaceUrlSpecialString:imageUrl],imagePath];
            [self.bridge callHandler:@"showImage" data:jsData responseCallback:^(id responseData) {
//                NSLog(@"%@",responseData);
                
            }];
        }else{
            [imageManager.imageDownloader downloadImageWithURL:[NSURL URLWithString: imageUrl] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished){
                    [imageManager.imageCache storeImage:image forKey:[self replaceUrlSpecialString:imageUrl] completion:^{
                        NSString *jsData =[NSString stringWithFormat:@"replaceImage%@,%@",[self replaceUrlSpecialString:imageUrl],imagePath];
                        [self.bridge callHandler:@"showImage" data:jsData responseCallback:^(id responseData) {
//                            NSLog(@"%@",responseData);
                            
                        }];
                    }];
                }
            }];
            
        }
    }
}
- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

#pragma mark - XPBuyNoComentViewDelegate
- (void)buyNoCommentView:(XPBuyNoCommentView *)view commentBtnClick:(UIButton *)commentBtn{
    [self commentBtnClick:commentBtn];
}



@end
