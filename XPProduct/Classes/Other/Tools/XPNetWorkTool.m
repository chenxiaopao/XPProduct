
//
//  XPNetWorkTool.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPNetWorkTool.h"
#import "XPConst.h"
#import "XPPurchaseModel.h"
@implementation XPNetWorkTool
+ (instancetype)shareTool{
    static XPNetWorkTool *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc]initWithBaseURL:nil];
    });
    return share;
}
- (void)loadInfoDetailDataFinish:(void(^)(id result,NSError *error))finish{
    NSString *url = @"http://c.3g.163.com/nc/article/AQ72N9QG00051CA1/full.html";
    
    
    [self POST:url parameters:nil  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(nil,error);
    }];
}

- (void)getCaptchaWithPhone:(NSString *)phone andCaptcha:(NSString *)captcha andCallback:(void(^)(NSString *phone))callback{

    NSString *url = CAPTCHA_URL;
    NSDictionary *param = @{@"app":@"sms.send",
                       @"tempid":@"51429",
                       @"param":captcha,
                       @"phone":phone,
                       @"appkey":@"26850",
                       @"sign":@"bdef778250161def11212dde65962641",
                            @"format":@"json"};
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"success"] isEqualToString:@"1"]){
            NSDictionary *dic = [dict objectForKey:@"result"];
            NSString *phoneNumber = [dic objectForKey:@"phone"];
            callback(phoneNumber);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

- (void)loadUserInfoWithFullParam:(BOOL)isfullParam andIsAvatar:(BOOL)isAvatar CallBack:(void(^)(void))callback{
    NSString *url = [NSString stringWithFormat:@"%@reponseUserInfoServlet",BASE_URL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *avatar = @"";
    if ([defaults objectForKey:@"avatar"]){
        avatar = [defaults objectForKey:@"avatar"];
    }
    NSString *userName = [defaults objectForKey:@"userName"];
    //utf-8解码
    userName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *phone = [defaults objectForKey:@"phone"];
    NSDictionary *param;
    if (isfullParam){
        param = @{@"userName":userName,
                           @"avatar":avatar,
                           @"phone":phone
                           };
    }else if(isAvatar){
        param = @{
                  @"avatar":avatar,
                  @"phone":phone
                  };
    }else{
        param =@{
                 @"userName":userName,
                 @"phone":phone
                 };
    }

    [self POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil){
            NSDictionary *dict = responseObject;
            [defaults setObject:dict[@"userName"] forKey:@"userName"];
            if (![[dict objectForKey:@"avatar"] isEqualToString:@""]){
                [defaults setObject:dict[@"avatar"] forKey:@"avatar"];
            }
            [defaults setObject:dict[@"user_id"] forKey:@"user_id"];
//            [defaults setInteger:[[dict objectForKey:@"user_id"] integerValue] forKey:@"user_id"];
            [defaults setObject:dict[@"phone"] forKey:@"phone"];
            
            
            [defaults synchronize];
        }

        callback();

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
 
}

- (void)publishPurchaseInfoWithArr:(NSArray *)arr andModel:(XPPurchaseModel *)model andState:(NSString *)state andCallBack:(void(^)(BOOL tag))callBack{
    NSString *url = [NSString stringWithFormat:@"%@publishPurchaseInfoServlet",BASE_URL];
    NSDictionary *dict;
    if (arr.count > 0){
        NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        NSString *user_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        user_name = [user_name stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        
        NSString *timeStr = [dateFormatter stringFromDate:date];
        NSString *name = [arr[0] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *count = [arr[1] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *address = [arr[3] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *descriptions = [arr[4] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        dict =@{@"user_id":user_id,
                              @"user_name":user_name,
                              @"publishTime":timeStr,
                              @"name":name,
                              @"address":address,
                              @"count":count,
                              @"state":@"1",
                              @"price":arr[2],
                              @"descriptions":descriptions
                              };
    }else{
        dict = @{@"user_id": [NSString stringWithFormat:@"%ld",(long)model.user_id ],
                 @"state":state,
                 @"id":[NSString stringWithFormat:@"%ld",(long)model._id ],
                 };
    }
    
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            NSDictionary *dict = responseObject;
            NSString *tag  = [dict objectForKey:@"success"];
            
            callBack(tag.boolValue);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
    
}


- (void)loadPurchaseInfoWithUser_id:(NSString *)user_id andState:(NSString *)state andName:(NSString *)name CallBack: (void(^)(NSArray *modelArr,NSError *error))callBack{
    NSString *url = [NSString stringWithFormat:@"%@responsePurchaseInfoServlet",BASE_URL];
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *param;
    if (name == nil){
        param = @{
                  @"user_id":user_id,
                  @"state":state
                  };
    }else{
        param = @{@"name":name};
    }
    
    [self POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject){
            
            callBack(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error){
            callBack(nil,error);
        }
        
    }];
}

- (void)searchPurchaseInfoWithName:(NSString *)name andAddress:(NSString *)address andSort:(NSString *)sort andCallBack:(void(^)(NSArray *modelArr))callback{
    NSString *url = [NSString stringWithFormat:@"%@responsePurchaseInfoServlet",BASE_URL];
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    address = [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    sort = [sort stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *param = @{
                            @"name":name,
                            @"address":address,
                            @"sort":sort
                            };
    
    [self POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject){
            
            callback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
