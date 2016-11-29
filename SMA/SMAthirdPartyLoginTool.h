//
//  SMAthirdPartyLoginTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/24.
//  Copyright © 2016年 SMA. All rights reserved.1105309779 1105552981
//
#define __TencentDemoAppid_  @"1105552981"
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
@interface SMAthirdPartyLoginTool : NSObject
@property (nonatomic, retain)TencentOAuth *oauth;
+ (SMAthirdPartyLoginTool *)getinstance;
+ (void)resetSDK;
- (BOOL)QQlogin;
- (BOOL)iphoneQQInstalled;
- (BOOL)WeChatLoginController:(UIViewController *)viewController;
- (BOOL)isWXAppInstalled;
@end
