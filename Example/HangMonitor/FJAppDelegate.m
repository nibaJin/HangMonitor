//
//  FJAppDelegate.m
//  HangMonitor
//
//  Created by jin fu on 09/21/2022.
//  Copyright (c) 2022 jin fu. All rights reserved.
//

#import "FJAppDelegate.h"
#import "BGHangMonitor.h"

@implementation FJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Start Monitor
    BGHangMonitor.shareInstance.hangBlock = ^(NSString * _Nonnull vcClassName, double hangT) {
        NSLog(@"------%@发现卡顿,卡顿时长%fs-----", vcClassName, hangT);
    };
    BGHangMonitor.shareInstance.deadBlock = ^(NSString * _Nonnull vcClassName) {
        NSLog(@"------%@发现卡死,主线程无响应时长>5s-----", vcClassName);
    };
    // 默认80ms
    BGHangMonitor.shareInstance.hangT = 80;
    // 默认5s
    BGHangMonitor.shareInstance.deadT = 5;
    [BGHangMonitor.shareInstance beginMonitor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
