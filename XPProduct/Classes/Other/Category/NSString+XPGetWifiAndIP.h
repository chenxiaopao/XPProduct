//
//  NSString+XPGetWifiAndIP.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/30.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XPGetWifiAndIP)
+ (nullable NSString*)getCurrentLocalIP;
+ (nullable NSString *)getCurreWiFiSsid;
+(NSString *)getWiFiIPAddress;
@end
