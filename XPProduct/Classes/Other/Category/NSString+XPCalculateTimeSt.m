//
//  NSString+XPCalculateTimeSt.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "NSString+XPCalculateTimeSt.h"

@implementation NSString (XPCalculateTimeSt)

+ (NSString *)timeStringWithDateStr:(NSString *)preDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    NSDate *preDate =  [dateFormatter dateFromString:preDateStr];
    NSDate *nowDate = [NSDate new];
    NSTimeInterval value = [nowDate timeIntervalSinceDate:preDate];
    
    //    int second = (int)value % 60;
    int minute = (int)value/60%60;
    int hour = (int)value/(24*3600)%3600;
    int day = (int)value/(24*3600);
    if (day >1){
        return [NSString stringWithFormat:@"%d天前",day];
    }else if(hour>1){
        return [NSString stringWithFormat:@"%d小时前",hour];
    }else if(minute>1){
        return [NSString stringWithFormat:@"%d分钟前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}
@end
