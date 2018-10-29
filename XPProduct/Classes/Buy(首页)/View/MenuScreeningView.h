//
//  MenuScreeningView.h
//  LinkageMenu
//
//  Created by mango on 2017/3/4.
//  Copyright © 2017年 mango. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuScreeningView;
@protocol MenuScreeningViewDelegate <NSObject>
- (void)menuScreeningView:(MenuScreeningView *)menuView didSeletedAddressTitle:(NSString *)addressTitle fullAddressTitle:(NSString *)fullAddressTitle sortTitle:(NSString *)sortTitle isRefresh:(BOOL)isRefresh;
@end

@interface MenuScreeningView : UIView
@property (nonatomic,weak) id<MenuScreeningViewDelegate> delegate;
-(void)menuScreeningViewDismiss;

@end
