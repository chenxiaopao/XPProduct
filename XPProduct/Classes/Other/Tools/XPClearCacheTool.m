//
//  XPClearCacheTool.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/24.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPClearCacheTool.h"

@implementation XPClearCacheTool

+ (NSString *)getSizeWithPath:(NSString *)cachePath{
    NSInteger totalSize = 0;
    NSString * filePath = nil;
    NSArray *pathsArr = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    for (NSString *fileName in pathsArr){
        filePath = [cachePath stringByAppendingPathComponent:fileName];
        //文件是否目录 默认不是
//        NSLog(@"%@",filePath);
        BOOL isDirectory = NO;
        //判断文件是否存在，通过isDirectory 返回是否是目录
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        //如果是目录 或者 不存在这样的目录或文件 或者是隐藏文件 继续执行
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            continue;
        }
//        NSLog(@"%@",fileName);
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil];
//        NSLog(@"%llu",[attributes fileSize]);
        totalSize += [attributes fileSize];
    }
    NSString *sizeStr = @"";
    if (totalSize >1024*1024){
        sizeStr = [NSString stringWithFormat:@"%.1fM",(float)totalSize/1024/1024];
    }else {
        sizeStr = [NSString stringWithFormat:@"%.1fKB",(float)totalSize/1024];
    }
    return sizeStr;
}
+ (BOOL)clearCacheWithPath:(NSString *)cachePath{
    
    NSArray *pathsArr = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *fileName in pathsArr){
        filePath = [cachePath stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
    }
    return YES;
    
}
@end
