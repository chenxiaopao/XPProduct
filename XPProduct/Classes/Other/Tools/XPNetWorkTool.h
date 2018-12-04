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
- (void)loadInfoDetailWithPage:(NSInteger)page DataFinish:(void(^)(id result,NSError *error))finish;

- (void)getCaptchaWithPhone:(NSString *)phone andCaptcha:(NSString *)captcha andCallback:(void(^)(NSString *phone))callback;

- (void)loadUserInfoWithFullParam:(BOOL)isfullParam andIsAvatar:(BOOL)isAvatar CallBack:(void(^)(void))callback;

- (void)publishPurchaseInfoWithArr:(NSArray *)arr andModel:(XPPurchaseModel *)model andState:(NSString *)state andCallBack:(void(^)(BOOL tag))callBack;

- (void)loadPurchaseInfoWithUser_id:(NSString *)user_id andState:(NSString *)state andName:(NSString *)name CallBack: (void(^)(NSArray *modelArr,NSError *error))callBack;

- (void)searchPurchaseInfoWithName:(NSString *)name andAddress:(NSString *)address andSort:(NSString *)sort andCallBack:(void(^)(NSArray *modelArr))callback;

- (void)loadCollectBrowseInfoWithParam:(NSDictionary *)dict andCallBack:(void(^)(id obj))callback;

- (void)publishuSupplyInfoWithImage:(NSArray *)images andArr:(NSArray *)arr andCallBack:(void(^)(id obj))callback;

- (void)uploadWithImage:(NSArray *)images WithCallBack:(void (^)(id obj))callback;

- (void)searchSupplyInfoWithName:(NSString *)name andAddress:(NSString *)address andSort:(NSString *)sort andCallBack:(void(^)(NSArray *modelArr))callback;

- (void)loadSupplyInfoWithId:(NSInteger)_id User_id:(NSString *)user_id andState:(NSString *)state  andCallBack:(void (^)(id obj,NSError *error))callBack;

- (void)updateSupplyInfoWithState:(NSString *)state andId:(NSInteger)_id andCallBack:(void(^)(NSInteger obj))callBack;

- (void)loadCommentInfoWithProduct_Id:(NSInteger)product_id UserId:(NSInteger)user_id andCallback:(void(^)(NSArray *modelArr))callback;

- (void)insertCommentInfoWithProduct_id:(NSInteger)product_id WithContent:(NSString *)content andCallBack:(void (^)(NSInteger tag))callBack;

- (void)loadCommentAndSupplyInfoIsDeleteAll:(BOOL)delete WithCallback:(void(^)(id obj))callback;

- (void)upLoadToQNYWithImages:(UIImage *)images addSeconds:(NSInteger)seconds WithCallBack:(void (^)(id obj))callback;

- (void)postFeedbackInfo:(NSString *)info andCallBack:(void (^)(NSInteger tag))callback;
@end

