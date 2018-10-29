//
//  XPInfoDetailModel.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XPImageModel;
@interface XPInfoDetailModel : NSObject
@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSMutableArray *img;
@property (nonatomic,strong) NSString *ptime;
@property (nonatomic,strong) NSString *title;
@end
