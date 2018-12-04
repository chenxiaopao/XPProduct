//
//  XPMineUserCardViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/7.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineUserCardViewController.h"
#import "XPPageView.h"
#import "UIImage+XPOriginImage.h"
#import "UIView+XPViewFrame.h"
#import "XPBaseCollectChildViewController.h"
#import "XPMineBuyOrSaleChildViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XPMineUserCardViewController ()
@property (nonatomic,weak) UIImageView *avatorView;
@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,assign) NSInteger user_id;

@end

@implementation XPMineUserCardViewController


- (instancetype)initWithName:(NSString *)name andAvatar:(NSString *)avatar andUser_id:(NSInteger)user_id{
    self = [super init];
    if (self) {
        self.user_id = user_id;
        self.name = name;
        self.avatar = avatar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //topView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 200)];
    imageView.image = [UIImage imageNamed:@"background_orange"];
    [self.view addSubview:imageView];
    
    UIImageView *avatorView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame)-30, 60, 60)];

    [avatorView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.avatorView = avatorView;
    avatorView.layer.masksToBounds = YES;
    avatorView.layer.cornerRadius = avatorView.width/2;
    [self.view addSubview:avatorView];
    
    //middleView
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), XP_SCREEN_WIDTH, 100)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 100, 30)];
    label.font = [UIFont systemFontOfSize:20];
    self.nameLabel = label;
    self.nameLabel.text = self.name;
    [middleView addSubview:label];

    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, middleView.height-1, middleView.width, 1)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [middleView addSubview:bottomLine];
    [self.view addSubview:middleView];
    
    CGFloat height = (XP_SCREEN_HEIGHT) -CGRectGetMaxY(middleView.frame);
   
    
    //bottomView
    NSArray *titleArr = @[@"采购",@"供应"];
    XPMineBuyOrSaleChildViewController *Vc1 = [[XPMineBuyOrSaleChildViewController alloc]initWithUser_Id:self.user_id andHeight:height];
    
    XPMineBuyOrSaleChildViewController *Vc2 = [[XPMineBuyOrSaleChildViewController alloc]initWithUser_Id:self.user_id andHeight:height];
    
    Vc1.type = XPMineBuyOrSaleCellTypeActive;
    Vc1.isBuy = YES;
    Vc1.view.backgroundColor = [UIColor whiteColor];
    
    Vc2.type = XPMineBuyOrSaleCellTypeActive;
    Vc2.isBuy = NO;
    Vc2.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *childVcs = @[Vc1,Vc2];
   
    
    XPPageView *pageView = [[XPPageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), XP_SCREEN_WIDTH, height) titleArr:titleArr childVcs:childVcs parentVc:self contentViewCanScroll:YES];
    [self.view addSubview:pageView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init] ];
    self.navigationController.navigationBar.translucent = YES;
}

@end
