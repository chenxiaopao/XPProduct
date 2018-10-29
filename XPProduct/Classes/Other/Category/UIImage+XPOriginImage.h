//
//  UIImage+XPOriginImage.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XPOriginImage)
+ (instancetype)xp_originImageNamed:(NSString *)imageName;
- (instancetype)xp_imageWithColor:(UIColor *)color;
+ (NSString *)saveImageWithImage:(UIImage *)image andName:(NSString *)name;
+ (UIImage *)getImageWithName:(NSString *)name;
@end
