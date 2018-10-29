//
//  AppDelegate.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/22.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "AppDelegate.h"
#import "XPTabBarController.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    XPTabBarController *tabBarVC = [[XPTabBarController alloc]init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
