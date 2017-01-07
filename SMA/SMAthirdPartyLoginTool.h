//
//  SMAthirdPartyLoginTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/24.
//  Copyright © 2016年 SMA. All rights reserved.1105309779 1105552981
//
#define __TencentDemoAppid_  @"1105916662"
//login
#define kLoginSuccessed @"loginSuccessed"
#define kLoginFailed    @"loginFailed"
#define kLoginCancelled @"loginCancelled"
#define WXauthScope @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
#define WXauthOpenId @"ab98e83eef1721bb2ff9be7f333082fe";
#define WXauthState @"xxx";
#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "SMAthirdPartyManager.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "WeiboSDK.h"
@interface SMAthirdPartyLoginTool : NSObject<FBSDKSharingDelegate>
@property (nonatomic, strong)  UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, retain)TencentOAuth *oauth;
+ (SMAthirdPartyLoginTool *)getinstance;
+ (void)resetSDK;
- (BOOL)QQlogin;
- (BOOL)iphoneQQInstalled;
- (void)shareToQQShareImage:(UIImage *)image;
- (void)shareToQZoneShareImage:(UIImage *)image;
- (BOOL)WeChatLoginController:(UIViewController *)viewController;
- (BOOL)isWXAppInstalled;
- (BOOL)shareToWeChatScene:(int)scene shareImage:(UIImage *)image;
- (BOOL)isWBAppInstalled;
- (BOOL)WeiboLogin;
- (BOOL)shareToWBWithShareImage:(UIImage *)image;
- (void)shareToTwitterWithShareImage:(UIImage *)image;
- (void)shareToTwitterWithShareImage:(UIImage *)image controller:(UIViewController *)vc;
- (void)shareToFacebookWithShareImage:(UIImage *)image controller:(UIViewController *)vc;
- (void)shareToInstagramWithShareImage:(UIImage *)image controller:(UIViewController *)vc;
@end
