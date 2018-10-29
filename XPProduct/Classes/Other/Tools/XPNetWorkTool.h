//
//  XPNetWorkTool.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class XPPurchaseModel;
@interface XPNetWorkTool : AFHTTPSessionManager
+ (instancetype)shareTool;
- (void)loadInfoDetailDataFinish:(void(^)(id result,NSError *error))finish;

- (void)getCaptchaWithPhone:(NSString *)phone andCaptcha:(NSString *)captcha andCallback:(void(^)(NSString *phone))callback;

- (void)loadUserInfoWithFullParam:(BOOL)isfullParam andIsAvatar:(BOOL)isAvatar CallBack:(void(^)(void))callback;

- (void)publishPurchaseInfoWithArr:(NSArray *)arr andModel:(XPPurchaseModel *)model andState:(NSString *)state andCallBack:(void(^)(BOOL tag))callBack;

- (void)loadPurchaseInfoWithUser_id:(NSString *)user_id andState:(NSString *)state andName:(NSString *)name CallBack: (void(^)(NSArray *modelArr,NSError *error))callBack;

- (void)searchPurchaseInfoWithName:(NSString *)name andAddress:(NSString *)address andSort:(NSString *)sort andCallBack:(void(^)(NSArray *modelArr))callback;
@end
