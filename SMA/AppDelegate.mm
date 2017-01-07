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
#import "SMATabbarController.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WXApi.h"
#import "SMAthirdPartyLoginTool.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ACloudLib setMode:ACLoudLibModeRouter Region:ACLoudLibRegionChina];
    [ACloudLib setMajorDomain:@"lijunhu" majorDomainId:375]; //282
    
    [WXApi registerApp:@"wxdce35a17f98972c9" withDescription:@"demo 2.0"];
    
    [FBSDKLikeControl class];
    [FBSDKLoginButton class];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3736959518"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
    if (![SMADefaultinfos getValueforKey:FIRSTLUN]) {
        SMAFirstLunViewController *firstLunVC = [[SMAFirstLunViewController alloc] init];
        self.window.rootViewController = firstLunVC;
    }
    else if ([SMAAccountTool userInfo].userID && ![[SMAAccountTool userInfo].userID isEqualToString:@""]) {
        
        SMATabbarController* controller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
        controller.isLogin = YES;
        NSArray *arrControllers = controller.viewControllers;
        for (int i = 0; i < arrControllers.count; i ++) {
            SMANavViewController *nav = [arrControllers objectAtIndex:i];
            nav.tabBarItem.title = itemArr[i];
        }
        
//        SMANavViewController* controller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAGenderViewController"];
//        controller.leftItemHidden = YES;
//        [UIApplication sharedApplication].keyWindow.rootViewController=controller;
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
        [SMADefaultinfos putInt:CALLSET andValue:0];
        [SMADefaultinfos putInt:SMSSET andValue:0];
        [SMADefaultinfos putInt:SCREENSET andValue:1];
        [SMADefaultinfos putInt:ANTILOSTSET andValue:0];
        [SMADefaultinfos putInt:VIBRATIONSET andValue:2];
        [SMADefaultinfos putInt:BACKLIGHTSET andValue:2];
    }
    [SMADefaultinfos putKey:UPDATEDATE andValue:[NSDate date].yyyyMMddNoLineWithDate];
    //         真机测试时保存日志
    if ([[[UIDevice currentDevice] model] rangeOfString:@"simulator"].location) {
//     [self redirectNSLogToDocumentFolder];
    }
    return YES;
}

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
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
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [[SMAthirdPartyManager sharedManager] wbLoginFinishWithUserID:self.wbCurrentUserID accessToken:self.wbtoken];
//        if (wbtoken && wbCurrentUserID) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"［Weibo］" ,@"LOGINTYPE",wbCurrentUserID,@"OPENID",wbtoken,@"TOKEN", nil]];
//        }
//        else{
//             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［Weibo］" forKey:@"LOGINTYPE"]];
//        }
//        [MBProgressHUD showError:SMALocalizedString(@"")];
//        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
//        NSString *title = NSLocalizedString(@"邀请结果", nil);
//        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
//        [alert show];
    }
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
    else if ([urlString isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else if ([urlString isEqual:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
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
    else if ([urlString isEqual:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return 0;
}
@end
