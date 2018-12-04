//
//  QNYTool.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/11/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "QNYTool.h"

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "QNUrlSafeBase64.h"
#import "QN_GTM_Base64.h"
NSString *accessKey = @"VZP8UJoq4YcGQK0y9q4pyGpEdNhX9Fwe2kxMs8om";
NSString *secretKey = @"iL_v2CjjT_hX5z1XEVjCwVqFWrNW1C3aLPzH19OQ";
NSString *scope = @"xiaopao";
NSInteger liveTime = 1;


@implementation QNYTool

+ (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//AccessKey  以及SecretKey
+ (NSString *)token{
    
    return [QNYTool makeToken: accessKey secretKey:secretKey];
}

+ (NSString *) hmacSha1Key:(NSString*)key textData:(NSString*)text
{
    const char *cData  = [text cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [QNUrlSafeBase64 encodeData:HMAC];
    return hash;
}

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    //名字
    NSString *baseName = [self marshal];
    baseName = [baseName stringByReplacingOccurrencesOfString:@" " withString:@""];
    baseName = [baseName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSData   *baseNameData = [baseName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseNameBase64 = [QNUrlSafeBase64 encodeData:baseNameData];
    NSString *secretKeyBase64 =  [QNYTool hmacSha1Key:secretKey textData:baseNameBase64];
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, secretKeyBase64, baseNameBase64];
    
    return token;
}

+ (NSString *)marshal
{
    time_t deadline;
    time(&deadline);
    //"ceshi" 是我们七牛账号下创建的储存空间名字“可以自定义”
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:scope forKey:@"scope"];
    //3464706673 是token有效期
    NSNumber *escapeNumber = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] +  3600];
    [dic setObject:escapeNumber forKey:@"deadline"];
    NSString *json = [QNYTool dictionryToJSONString:dic];
    return json;
}


@end
