
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
        
        NSString *user_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        
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
                              @"user_phone":user_phone,
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

- (void)loadCollectBrowseInfoWithParam:(NSDictionary *)dict andCallBack:(void(^)(id obj))callback{
    NSString *url = [NSString stringWithFormat:@"%@responseCollectBrowseInfoServlet",BASE_URL];
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *mArr = [NSMutableArray array];
            NSArray *arr = responseObject;
            for (int i=0; i<arr.count; i++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: arr[i]];
                if ([dict objectForKey:@"images"]){
                    NSString *str = [dict objectForKey:@"images"];
                    if (![str isEqualToString: @""]){
                        NSArray  *imageArr = [self getArrayFromString:str];
                        if ([dict.allKeys containsObject:@"images"]){
                            [dict setValue:imageArr forKey:@"images"];
                        }
                    }
                    
                }
                [mArr addObject:dict];
            }
            callback(mArr);
        }else{
            callback(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)publishuSupplyInfoWithImage:(NSArray *)images andArr:(NSArray *)arr andCallBack:(void (^)(id))callback{

    NSDictionary *dict;
    if (arr.count > 0){
        NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        NSString *user_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        user_name = [user_name stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *user_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        
        NSString *name = [arr[0] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *standard = [arr[1] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *count = [arr[3] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *address = [arr[4] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *saleTime = [arr[5] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *descriptions = [arr[6] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
        NSString *publishTime = [dateFormatter stringFromDate:[NSDate new]];
        NSString *images = @"";
        if (arr.count == 8){
            images = arr[7];
        }
        dict =@{@"user_id":user_id,
                @"user_name":user_name,
                @"user_phone":user_phone,
                @"saleTime":saleTime,
                @"name":name,
                @"address":address,
                @"publishTime":publishTime,
                @"count":count,
                @"state":@"1",
                @"standard":standard,
                @"price":arr[2],
                @"descriptions":descriptions,
                @"images":images
                };
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@publishSupplyInfoServlet",BASE_URL];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [self POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (int i = 0; i < images.count; i ++) {
//            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//            formatter.dateFormat=@"yyyyMMddHHmmss";
//            NSString *str=[formatter stringFromDate:[NSDate date]];
//            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
//            UIImage *image = images[i];
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
//            [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:@"image/jpeg"];
//        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld,%lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure:%@",error.description);
    }];
}

- (void)uploadWithImage:(UIImage *)images WithCallBack:(void (^)(id obj))callback{
    __block  NSString *mStr = [NSMutableString string];
//    for (int i=0; i<images.count; i++) {
    
        [self POST:@"https://sm.ms/api/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
            dateformatter.dateFormat = @"yyMMddHHmmss";
            NSString *str = [dateformatter stringFromDate:[NSDate new]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            NSData *imageData = UIImageJPEGRepresentation(images, 0.28);
            
            [formData appendPartWithFileData:imageData name:@"smfile" fileName:fileName mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]){
                NSLog(@"%@",responseObject);
                NSDictionary *dict = [responseObject objectForKey:@"data"];
                NSString *url = [dict objectForKey:@"url"];
                mStr = [mStr stringByAppendingString:[NSString stringWithFormat:@"%@,",url]];
//                if (i == images.count - 1){
                    callback(mStr);
//                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
//    }
    
    
}

- (void)loadSupplyInfoWithId:(NSInteger)_id User_id:(NSString *)user_id andState:(NSString *)state  andCallBack:(void (^)(id obj,NSError *error))callBack{
    NSString *url = [NSString stringWithFormat:@"%@responseSupplyInfoServlet",BASE_URL];
    self.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/html", nil];
    NSDictionary *dict;
    if (_id == 0){
        dict = @{
                 @"user_id":user_id,
                 @"state":state,
                 @"_id":@(_id)
                 };
    }else{
        dict = @{
                 @"_id":@(_id)
                 };
    }
    
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *mArr = [NSMutableArray array];
            NSArray *arr = responseObject;
            for (int i=0; i<arr.count; i++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: arr[i]];
                NSString *str = [dict objectForKey:@"images"];
                NSArray  *imageArr = [self getArrayFromString:str];
                if ([dict.allKeys containsObject:@"images"]){
                    [dict setValue:imageArr forKey:@"images"];
                }

                [mArr addObject:dict];
            }
            callBack(mArr,nil);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}

- (void)searchSupplyInfoWithName:(NSString *)name andAddress:(NSString *)address andSort:(NSString *)sort andCallBack:(void(^)(NSArray *modelArr))callback{
    NSString *url = [NSString stringWithFormat:@"%@responseSupplyInfoServlet",BASE_URL];
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    address = [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    sort = [sort stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *param = @{
                            @"name":name,
                            @"address":address,
                            @"sort":sort
                            };
    
    [self POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSMutableArray *mArr = [NSMutableArray array];
            NSArray *arr = responseObject;
            for (int i=0; i<arr.count; i++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: arr[i]];
                NSString *str = [dict objectForKey:@"images"];
                NSArray  *imageArr = [self getArrayFromString:str];
                if ([dict.allKeys containsObject:@"images"]){
                    [dict setValue:imageArr forKey:@"images"];
                }
                
                [mArr addObject:dict];
            }
            callback(mArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)updateSupplyInfoWithState:(NSString *)state andId:(NSInteger )_id andCallBack:(void (^)(NSInteger obj))callBack{
    NSString *url = [NSString stringWithFormat:@"%@updateSupplyServlet",BASE_URL];
    NSDictionary *dict = @{
                           @"_id":@(_id),
                           @"state":state
                           };
    self.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];
    
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger tag = [[responseObject objectForKey:@"success"] integerValue];
        callBack(tag);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (NSMutableArray *)getArrayFromString:(NSString *)imageStr{
    NSMutableArray *arr =[NSMutableArray arrayWithArray: [imageStr componentsSeparatedByString:@","]];
    [arr removeLastObject];
    return arr;
}

- (void)loadCommentInfoWithProduct_Id:(NSInteger)product_id UserId:(NSInteger)user_id andCallback:(void (^)(NSArray *modelArr))callback{
    NSString *url = [NSString stringWithFormat:@"%@responseCommentInfoServlet",BASE_URL];
    NSDictionary *dict = @{
                           @"topic_id":@(product_id),
                           @"user_id":@(user_id)
                           };
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)insertCommentInfoWithProduct_id:(NSInteger)product_id WithContent:(NSString *)content andCallBack:(void (^)(NSInteger tag))callBack{
    NSString *url = [NSString stringWithFormat:@"%@insertCommentInfoServlet",BASE_URL];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *timeStr = [dateFormatter stringFromDate:date];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    userName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    content = [content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSDictionary *dict = @{
                           @"topic_id":@(product_id),
                           @"from_uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
//                           @"to_uid":@"",
                           @"content":content,
//                           @"avatar":@"",
                           @"time":timeStr,
                           @"user_name":userName
                           };
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack((NSInteger)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)loadCommentAndSupplyInfoIsDeleteAll:(BOOL)delete WithCallback:(void(^)(id obj))callback{
    NSString *url = [NSString stringWithFormat:@"%@reponseCommentAndSupplyInfoServlet",BASE_URL];
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *dict ;
    if (delete){
        dict = @{
                  @"user_id":user_id,
                  @"delete":@"yes"
                  };
    }else{
        dict = @{
                  @"user_id":user_id,
                  };
    }
    
    
    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
