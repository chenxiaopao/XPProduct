//
//  dropMenuView.m
//  asd
//
//  Created by 陈思斌 on 2018/9/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPCategoryView.h"
#import "XPBaseCategoryLeftCell.h"
#import "XPBaseCategoryRightCell.h"
#import "UIView+XPViewFrame.h"
@interface XPCategoryView () <UITableViewDataSource,UITableViewDelegate,XPBaseCategoryRightCellDelagate>
@property (nonatomic,weak) UITableView *rightTableView;
@property (nonatomic,weak) UITableView *leftTableView;
@property (nonatomic,strong) NSArray *leftArr;
@property (nonatomic,strong) NSDictionary *categoryData;
@property (nonatomic,strong) NSDictionary *rightDicData;
@property (nonatomic,strong) NSMutableArray *titleArr;
@end

@implementation XPCategoryView
static NSString *const categoryRightCellID = @"categoryRightCellID";
static NSString *const categoryLeftCellID = @"categoryLeftCellID";
- (instancetype)initWithFrame:(CGRect)frame categoryData:(NSDictionary *)data{
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryData = data;
        self.leftArr = self.categoryData.allKeys;
        self.titleArr = [NSMutableArray array];
    }
    return self;
}
- (void)hide{
    [self removeFromSuperview];
}

- (void)show{
    [self setTableView];
    if ([self.delegate respondsToSelector:@selector(didSelectedLeftRowInXPCategoryView:)]){
        NSInteger row =  [self.delegate didSelectedLeftRowInXPCategoryView:self];
        [self leftTableViewselectRow:row];
    }else{
        [self leftTableViewselectRow:0];
    }
}

- (void)leftTableViewselectRow:(NSInteger )row{
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self reloadRightTableView:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (void)setTableView{
  
    UITableView *leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.x, 0, 100, self.height)];
    [leftTableView registerClass:[XPBaseCategoryLeftCell class] forCellReuseIdentifier:categoryLeftCellID];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.tag = 10000;
    leftTableView.backgroundColor = [UIColor colorWithDisplayP3Red:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    self.leftTableView = leftTableView;
    [self addSubview:leftTableView];
    
    UITableView *rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(100, 0, XP_SCREEN_WIDTH-100, self.height)];
    rightTableView.delegate = self;
    rightTableView.tag = 10001;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView = rightTableView;
    [rightTableView registerClass:[XPBaseCategoryRightCell class] forCellReuseIdentifier:categoryRightCellID];
    [self addSubview:rightTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10000){
        return 1;
    }else{
        return self.rightDicData.allKeys.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10000){
        return self.categoryData.allKeys.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10000){
        XPBaseCategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryLeftCellID forIndexPath:indexPath];
        cell.title = self.leftArr[indexPath.row];
        return cell;
    }else{
        XPBaseCategoryRightCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryRightCellID forIndexPath:indexPath];
        NSArray *allkeys = self.rightDicData.allKeys;
        NSArray *data = [self.rightDicData objectForKey: [allkeys objectAtIndex:indexPath.section]];
        cell.rightCellData = data;
        cell.delegate =self;
        return cell;
    }
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 10000){
        [self reloadRightTableView:indexPath];
    }
}

- (void)reloadRightTableView:(NSIndexPath *)indexPath{
    NSString *title = [self.leftArr objectAtIndex:indexPath.row];
    NSDictionary *dict = [self.categoryData objectForKey:title];
    self.rightDicData = dict;
    [self.rightTableView reloadData];
    [self.titleArr removeAllObjects];
    [self.titleArr addObject:title];
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10000){
        return [UIView new];
    }else{
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
        bgView.backgroundColor=[UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width-10, 60)];
        label.text = [self.rightDicData.allKeys objectAtIndex:section];
        [bgView addSubview:label];
        return bgView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 10000){
        return 0;
    }else{
        if (section == 0){
            return 30;
        }
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10000){
        return 40;
    }else{
        NSArray *data = [self.rightDicData objectForKey: [self.rightDicData.allKeys objectAtIndex:indexPath.section]];
        CGFloat height = data.count%3 == 0 ? (data.count/3)*(50+10):(data.count/3+1)*(50+10);
        return height;
    }
   
}

#pragma mark - XPBaseCategoryRightCellDelagate
- (void)baseCategoryRightCell:(XPBaseCategoryRightCell *)cell didselectedTitle:(NSString *)title{
    if ([self.delegate respondsToSelector:@selector(XPCategoryView:didSelectedTitleArr:)]){
        if (![title isEqualToString:@"全部"]){
            [self.titleArr addObject:title];
        }
        [self.delegate XPCategoryView:self didSelectedTitleArr:self.titleArr];
    }
}
@end
