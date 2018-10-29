//
//  XPGraySearchView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/2.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XPViewFrame.h"
@protocol XPGraySearchViewDelegate <NSObject>
- (void)searchBarSearchBtnClick:(UISearchBar *)searchBar;
@end


@interface XPGraySearchView : UIView
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,weak) id<XPGraySearchViewDelegate> delegate;
- (void)resignResponder;
@end
