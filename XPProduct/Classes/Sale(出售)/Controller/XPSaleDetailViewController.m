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
#import "XPScreeningResultViewController.h"
#import "MJExtension.h"
#import "XPPurchaseModel.h"
#import "XPAlertTool.h"
#import "XPCollectBrowseModel.h"
#import "XPNetWorkTool.h"
#import "XPConst.h"
#import "XPMineUserCardViewController.h"
@interface XPSaleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *nameArr;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIButton *collectBtn;
@property (nonatomic,strong) XPCollectBrowseModel *collectBrowseModel;

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
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]){
            [self loadCollectDataWithProduct_id:purchaseModel._id];
            [self loadHistoryDataWithProduct_id:purchaseModel._id];
        }
    }
    return self;
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
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
                           @"type":@"0"
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
                   @"type":@"0"
                   };
    [XPCollectBrowseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"_id":@"id"
                 };
    }];

   
    __weak typeof(self) weakSelf = self;
    
    [[XPNetWorkTool shareTool] loadCollectBrowseInfoWithParam:dict andCallBack:^(NSDictionary *dic) {
        if (dic){
            weakSelf.collectBrowseModel = [XPCollectBrowseModel mj_objectWithKeyValues:dic];
            [weakSelf setBottomBtnTitle];
        }
    }];
    
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

- (void)setBottomBtnTitle{
    NSString *title = nil;
    if (self.collectBrowseModel.state == 1){
        title = @"取消收藏";
    }else{
        title = @"添加收藏";
    }
    [self setBtnPropertyWithBtn:self.collectBtn andTitle:title andBackgroundColor:[UIColor blueColor]];
}
- (void)setBottomBtn{
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,XP_SCREEN_HEIGHT-50, (XP_SCREEN_WIDTH-20)/2, 40)];
    if (self.collectBrowseModel==nil){
        [self setBtnPropertyWithBtn:collectBtn andTitle:@"添加收藏" andBackgroundColor:[UIColor blueColor]];
    }
    self.collectBtn = collectBtn;
    
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
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue];
    if (self.purchaseModel.user_id != userId){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]){
            if ([sender.titleLabel.text isEqualToString:@"打电话"]){
                [XPAlertTool callToUserWithPhone:self.purchaseModel.user_phone toView:self.view];
            }else{
                
                if (self.collectBrowseModel.state == 1){//state为1表示已收藏，当前显示为取消收藏
                    [sender setTitle:@"添加收藏" forState:UIControlStateNormal];
                    [self CollectActionIsAdd:NO];
                }else{
                    [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
                    [self CollectActionIsAdd:YES];
                }
            }
        }else{
            XPScreeningResultViewController *vc = [[XPScreeningResultViewController alloc]init];
            vc.categoryTitleArr = @[@"分类"];
            vc.isSale = YES;
            [XPAlertTool showLoginViewControllerWithVc:self orOtherVc:vc andSelectedIndex:1];
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
                               @"product_id":[NSString stringWithFormat:@"%ld",(long)self.purchaseModel._id],
                               @"tableType":@"1",
                               @"browseTime":timeTitle,
                               @"state":@"1",
                               @"type":@"0"
                               };
        title = @"添加成功";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshing" object:nil];
        [mDict addEntriesFromDictionary:dict];
    }else{
        NSDictionary *dict = @{
                               @"id":[NSString stringWithFormat:@"%ld",(long)self.collectBrowseModel._id],
                               @"tableType":@"1",
                               @"type":@"0"
                               
                               };
        [mDict addEntriesFromDictionary:dict];
        title = @"取消成功";
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshing" object:nil];
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
    
    XPMineUserCardViewController *vc = [[XPMineUserCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
