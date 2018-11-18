//
//  XPConst.h
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/23.
//  Copyright © 2018年 陈思斌. All rights reserved.
//
#define iOS7_LATER  ([[UIDevice currentDevice].systemVersion floatValue] >=7.0)
#define iOS8_LATER  ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)
#define iOS9_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >=9.0)
#define iOS11_LATER          ([[UIDevice currentDevice].systemVersion floatValue] >=11.0)
static const int recommendLabelTag = 1000;
static const int historyLabelTag = 2000;
static NSString * const CAPTCHA_URL = @"https://sapi.k780.com/?";
static NSString * removoTimerNotification = @"removoTimerNotification";
static NSString * const BASE_URL =@"http://192.168.0.100:8080/product/";

typedef NS_ENUM(NSInteger,XPMineItemType){
    XPMineItemTypeCollect=1,
    XPMineItemTypeHistory=0
};

typedef NS_ENUM(NSInteger,XPMineBuyOrSaleCellType){
    XPMineBuyOrSaleCellTypeActive=1,
    XPMineBuyOrSaleCellTypeInactive=0,
    XPMineBuyOrSaleCellTypeDisabled=-1
};
