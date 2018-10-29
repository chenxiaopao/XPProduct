//
//  XPSaleDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/29.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSaleDetailViewController.h"
#import "XPSaleDetailUserTableViewCell.h"
#import "XPSaleDetailNormalTableViewCell.h"
#import "MJExtension.h"
#import "XPPurchaseModel.h"
@interface XPSaleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *nameArr;
@property (nonatomic,weak) UITableView *tableView;

@end

static NSString *const saleDetailUserTableViewCellID =  @"saleDetailUserTableViewCellID";
static NSString *const saleDetailNormalCellID = @"saleDetailNormalCellID";

@implementation XPSaleDetailViewController
- (instancetype)initWithModel:(XPPurchaseModel *)purchaseModel{
    if (self = [super init]){
        self.purchaseModel = purchaseModel;
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObject:purchaseModel.name];
        [mArr addObject:purchaseModel.count];
        [mArr addObject:purchaseModel.address];
        [mArr addObject:purchaseModel.descriptions];
        [mArr addObject:purchaseModel.publishTime];
        self.nameArr = mArr;
    }
    return self;
    
}
- (NSArray *)titleArr{
    if (_titleArr == nil){
        _titleArr = @[@"货品名称:",@"采购数量:",@"期望货源地:",@"规格品质:",@"更新时间:"];
    }
    return _titleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"采购详情";
    [self setTableView];
    [self setBottomBtn];
}

- (void)setBottomBtn{
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,XP_SCREEN_HEIGHT-50, (XP_SCREEN_WIDTH-20)/2, 40)];
    NSString *title = @"添加收藏";
    [self setBtnPropertyWithBtn:collectBtn andTitle:title andBackgroundColor:[UIColor blueColor]];
    
    [self setBtnRadiusWithBtn:collectBtn androundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [self.view addSubview:collectBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(collectBtn.frame), XP_SCREEN_HEIGHT-50, (XP_SCREEN_WIDTH-20)/2, 40)];
    UIColor *rightColor =  [UIColor colorWithRed:255/255.0 green:120/255.0 blue:17/255.0 alpha:1];
    NSString *rightTitle = @"打电话";
    [self setBtnPropertyWithBtn:rightBtn andTitle:rightTitle andBackgroundColor:rightColor];
    [self setBtnRadiusWithBtn:rightBtn androundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight];
    [self.view addSubview:rightBtn];
}

- (void)setBtnPropertyWithBtn:(UIButton *)btn andTitle:(NSString *)title andBackgroundColor:(UIColor *)color{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBtnRadiusWithBtn:(UIButton *)btn androundingCorners:(UIRectCorner )corner{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners: corner cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = btn.bounds;
    layer.path = bezierPath.CGPath;
    btn.layer.mask = layer;
}

- (void)bottomBtnClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"打电话"]){
        
    }else{
        sender.selected = !sender.selected;
        if (sender.selected){
            [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
        }else{
            [sender setTitle:@"添加收藏" forState:UIControlStateNormal];
        }
    }
}

- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XPSaleDetailUserTableViewCell" bundle:nil]  forCellReuseIdentifier:saleDetailUserTableViewCellID];
     [tableView registerNib:[UINib nibWithNibName:@"XPSaleDetailNormalTableViewCell" bundle:nil]  forCellReuseIdentifier:saleDetailNormalCellID];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        XPSaleDetailUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:saleDetailUserTableViewCellID forIndexPath:indexPath];
        cell.purchaseModel = self.purchaseModel;
        return cell;
        
    }else{
       
        XPSaleDetailNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:saleDetailNormalCellID];
        cell.userInteractionEnabled = NO;
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.nameLabel.text = self.nameArr[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 100 : 60;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"1");
}

@end
