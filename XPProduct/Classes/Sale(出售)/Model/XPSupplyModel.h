//
//  XPSupplyModel.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XPSupplyModel : NSObject

@property (nonatomic,assign) NSInteger _id;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,strong) NSString *user_phone;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *publishTime;
@property (nonatomic,strong) NSString *saleTime;
@property (nonatomic,strong) NSString *descriptions;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSString *standard;

@end
