//
//  XPClearCacheTool.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/24.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPClearCacheTool : NSObject
+ (NSString *)getSizeWithPath:(NSString *)cachePath;
+ (BOOL)clearCacheWithPath:(NSString *)cachePath;
@end
