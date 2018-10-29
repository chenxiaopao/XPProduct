//
//  dropMenuView.h
//  asd
//
//  Created by 陈思斌 on 2018/9/21.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPCategoryView;
@protocol XPCategoryViewDelagete <NSObject>
- (void)XPCategoryView:(XPCategoryView *)categoryView didSelectedTitleArr:(NSArray *)titleArr;
@optional
- (NSInteger)didSelectedLeftRowInXPCategoryView:(XPCategoryView *)categoryView;
@end

@interface XPCategoryView : UIView
@property (nonatomic,weak) id<XPCategoryViewDelagete> delegate;
- (instancetype)initWithFrame:(CGRect)frame categoryData:(NSDictionary *)data;
- (void)hide;
- (void)show;

@end
