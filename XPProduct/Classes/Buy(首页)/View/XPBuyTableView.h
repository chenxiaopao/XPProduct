//
//  XPBuyTableView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XPBuyColletionView.h"

@class XPBuyTableView ,XPBuyColletionView;

@protocol XPBuyTableViewDelegate <NSObject>
- (void)buyTableView:(XPBuyTableView *)tableView didSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)buyTableView:(XPBuyTableView *)tableView buyCollectionViewDidselected:(XPBuyColletionView *)collectionView didSelectdIndexPath:(NSIndexPath *)indexPath title:(NSString *)title isFirstCollectionView:(BOOL)isFirstCollectionView;

- (void)buyTableViewDidScroll:(XPBuyTableView *)tableView;

@end

@interface XPBuyTableView : UITableView
@property (nonatomic,strong) NSArray *supplyArr;
@property (nonatomic,weak) id<XPBuyTableViewDelegate> buyDelegate;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style categoryData:(NSArray *)data;

@end
