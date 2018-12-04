//
//  UIImage+XPOriginImage.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "UIImage+XPOriginImage.h"
#import "XPNetWorkTool.h"
@implementation UIImage (XPOriginImage)

+ (instancetype)xp_originImageNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *originImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return originImage;
}
- (instancetype)xp_imageWithColor:(UIColor *)color{
  
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color set];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)saveImageWithImage:(UIImage *)image andName:(NSString *)name{
    NSData *imageData =  UIImagePNGRepresentation(image);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingPathComponent:name];
//    //保存到内存
//    [imageData writeToFile:fullPath atomically:NO];
//    
//    //保存到userdefaults
//    [[NSUserDefaults standardUserDefaults] setObject:fullPath forKey:name];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //上传到服务器
    
    [[XPNetWorkTool shareTool]upLoadToQNYWithImages:image addSeconds:1 WithCallBack:^(id obj) {
        NSString *url = obj;
        NSLog(@"%@",url);
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    return fullPath;
}

+ (UIImage *)getImageWithName:(NSString *)name{
    UIImage *image = nil;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:name]){
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullPath = [path stringByAppendingPathComponent:name];
        image = [UIImage imageWithContentsOfFile:fullPath];
    }else{
        image = [UIImage imageNamed:@"avatar_user"];
    }
    return image;
}

@end
