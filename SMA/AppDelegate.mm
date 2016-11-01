//
//  AppDelegate.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "AppDelegate.h"
#import "ACloudLib.h"
#import "SMANavViewController.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WXApi.h"
#import "SMAthirdPartyLoginTool.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ACloudLib setMode:ACLoudLibModeTest Region:ACLoudLibRegionChina];
    [ACloudLib setMajorDomain:@"lijunhu" majorDomainId:282];
    [WXApi registerApp:@"wxdce35a17f98972c9" withDescription:@"demo 2.0"];
    NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"排行"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"我的")];
    
    if ([SMAAccountTool userInfo].userID && ![[SMAAccountTool userInfo].userID isEqualToString:@""]) {
        UITabBarController* controller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
        NSArray *arrControllers = controller.viewControllers;
        for (int i = 0; i < arrControllers.count; i ++) {
            SMANavViewController *nav = [arrControllers objectAtIndex:i];
            nav.tabBarItem.title = itemArr[i];
        }
        self.window.rootViewController = controller;
    }
    SMAUserInfo *info =[SMAAccountTool userInfo];
    info.watchUUID = nil;
//    [SMAAccountTool saveUser:info];
    [SmaBleMgr reunitonPeripheral:YES];//开启重连机制
    //首次打开APP，默认部分设置
    if (![SMADefaultinfos getValueforKey:FIRSTLUN]) {
        [SMADefaultinfos putKey:FIRSTLUN andValue:FIRSTLUN];
        [SMADefaultinfos putInt:SLEEPMONSET andValue:1];
        [SMADefaultinfos putInt:CALLSET andValue:1];
        [SMADefaultinfos putInt:SMSSET andValue:1];
        [SMADefaultinfos putInt:SCREENSET andValue:1];
        [SMADefaultinfos putInt:VIBRATIONSET andValue:2];
        [SMADefaultinfos putInt:BACKLIGHTSET andValue:2];
    }
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
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString=[[url absoluteString] substringToIndex:2];
    if ([urlString isEqual:@"te"]) {
     return [TencentOAuth HandleOpenURL:url];
    }
    else if ([urlString isEqual:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:[SMAthirdPartyManager sharedManager]];
    }
    return 0;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlString=[[url absoluteString] substringToIndex:2];
    if ([urlString isEqual:@"te"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([urlString isEqual:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:[SMAthirdPartyManager sharedManager]];
    }
    return 0;
}
@end
