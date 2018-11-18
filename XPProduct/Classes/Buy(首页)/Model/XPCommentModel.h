//
//  XPCommentModel.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPCommentModel : NSObject
@property (nonatomic,assign) int topic_id ;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) int from_uid ;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,assign) int to_uid;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSArray *subModel;
@property (nonatomic,assign) float height;
@end
