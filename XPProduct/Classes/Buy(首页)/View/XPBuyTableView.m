//
//  XPBuyTableView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyTableView.h"
#import "XPBuyInfoTableViewCell.h"
#import "XPConst.h"
@interface XPBuyTableView () <UITableViewDataSource,UITableViewDelegate,XPBuyCollectionViewDelegate>
@property (nonatomic,strong) NSArray *categoryData;

@property (nonatomic,weak) XPBuyColletionView *collectionView;
@end

int firstColletionViewH =80;

int recommendLabelH = 40;
@implementation XPBuyTableView
static NSString *buyRecommendID = @"buyRecommendID";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style categoryData:(NSArray *)data {
    self = [super initWithFrame:frame style:style];
    if (self){
        
        self.delegate = self;
        self.dataSource = self;
        self.categoryData = data;
        
        [self registerNib:[UINib nibWithNibName:@"XPBuyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:buyRecommendID];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (void)setSupplyArr:(NSArray *)supplyArr{
    _supplyArr = supplyArr;
    
    [self reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.buyDelegate respondsToSelector:@selector(buyTableViewDidScroll:)]){
        [self.buyDelegate buyTableViewDidScroll:self];
    }
}


#pragma mark - UITableViewDataSource UITableViewDelagete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static CGFloat width;
    static CGFloat height;
    if(indexPath.section == 0){
        NSArray *dataArr = self.categoryData[indexPath.row];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if (indexPath.row == 0){
            width = (XP_SCREEN_WIDTH-140)/(dataArr.count);
            height = firstColletionViewH;
            layout.sectionInset = UIEdgeInsetsMake(0, 50, 0, 0);
            
        }else{
            width = ((XP_SCREEN_WIDTH-20)/(dataArr.count+1));
            height = 70;
        }
        static  NSString *buyCategoryID = @"buyCategoryID";
        layout.itemSize = CGSizeMake(width, height);
        
        UITableViewCell *cell =  [self dequeueReusableCellWithIdentifier:buyCategoryID];
        if (cell==nil){
            cell = [[UITableViewCell alloc]init];
            for (UIView *subView in cell.contentView.subviews) {
                [subView removeFromSuperview];
            }
            XPBuyColletionView *collectionView = [[XPBuyColletionView alloc]initWithFrame:CGRectMake(10, 0, XP_SCREEN_WIDTH-20, firstColletionViewH) collectionViewLayout:layout categoryData:dataArr];
            collectionView.collDelegate = self;
            [cell.contentView addSubview: collectionView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.collectionView = collectionView;
        }
        
        return cell;
    }else{
        
        XPBuyInfoTableViewCell *cell =  [self dequeueReusableCellWithIdentifier:buyRecommendID];
        cell.model = self.supplyArr[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 ){
        NSLog(@"3");
    }else{
        if ([self.buyDelegate respondsToSelector:@selector(buyTableView:didSelectedIndexPath:)]) {
            [self.buyDelegate buyTableView:self didSelectedIndexPath:indexPath];
        }
             
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return self.categoryData.count;
    }else{
        return self.supplyArr.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0){
        return firstColletionViewH;
    }else{
        return 120;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return  nil;

    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, recommendLabelH)];
        label.text = @"推荐货品";
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        return  label;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
//        return  200;
        return 0;
    }
    return recommendLabelH;
}


#pragma mark - XPBuyCollectionViewDelegate
- (void)buyCollectionView:(XPBuyColletionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath title:(NSString *)title isFirstCollectionView:(BOOL)isFirstCollectionView{
    if ([self.buyDelegate respondsToSelector:@selector(buyTableView:buyCollectionViewDidselected:didSelectdIndexPath:title:isFirstCollectionView:)]){
        [self.buyDelegate buyTableView:self buyCollectionViewDidselected:(XPBuyColletionView*)collectionView didSelectdIndexPath:indexPath title:title isFirstCollectionView:isFirstCollectionView];
         
    }
}
@end
