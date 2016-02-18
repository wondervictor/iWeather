//
//  AppDelegate.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//
#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    application.applicationIconBadgeNumber = 0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSThread sleepForTimeInterval:2.0f];
    
    UIMutableUserNotificationAction *action_1 = [UIMutableUserNotificationAction new];
    action_1.identifier = @"ACTION_1";
    action_1.title = @"打开应用";
    action_1.activationMode = UIUserNotificationActivationModeForeground;
    action_1.authenticationRequired = YES;
    action_1.destructive = NO;
    
    UIMutableUserNotificationAction *action_2 = [UIMutableUserNotificationAction new];
    action_2.identifier = @"ACTION_2";
    action_2.title = @"我知道了";
    action_2.activationMode = UIUserNotificationActivationModeBackground;
    action_2.authenticationRequired = NO;
    action_2.destructive = YES;
    
    
    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
    category.identifier = @"CATEGORY";
    [category setActions:@[action_2,action_1] forContext:UIUserNotificationActionContextDefault];
    NSSet *categories = [NSSet setWithObjects:category, nil];
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:categories];
    [application registerUserNotificationSettings:setting];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"received   Notification");
}


@end
