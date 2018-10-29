//
//  XPBuyPickView.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPBuyPickView;
@protocol XPBuyPickViewDelegate <NSObject>
- (void)XPBuyPickView:(XPBuyPickView *)pickView addressName:(NSString *)addressName;
@end

@interface XPBuyPickView : UIPickerView
@property (nonatomic,weak) id<XPBuyPickViewDelegate> buyPickViewDelegate;
@end
