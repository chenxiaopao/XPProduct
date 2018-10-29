//
//  XPWeakProxy.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/10.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface XPWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;
+ (instancetype)proxyWithTarget:(id)target;
@end
NS_ASSUME_NONNULL_END
