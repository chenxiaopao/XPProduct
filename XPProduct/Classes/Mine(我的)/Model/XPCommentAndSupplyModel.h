//
//  XPCommentAndSupplyModel.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/17.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XPCommentAndSupplyModel : NSObject

@property (nonatomic,assign) NSInteger topic_id;
@property (nonatomic,strong)  NSString *time;
@property (nonatomic,strong)  NSString *content;
@property (nonatomic,strong)  NSString *user_name;
@property (nonatomic,strong)  NSString *avatar;
@property (nonatomic,strong)  NSString *product_name;
@property (nonatomic,strong)  NSString *images;
@property (nonatomic,assign) CGFloat height;

@end
