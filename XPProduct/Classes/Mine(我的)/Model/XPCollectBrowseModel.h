//
//  XPCollectBrowseModel.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/6.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPCollectBrowseModel : NSObject

@property (nonatomic,assign) NSInteger _id;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,assign) NSInteger product_id;
@property (nonatomic,assign) NSInteger tableType;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *browseTime;
@end
