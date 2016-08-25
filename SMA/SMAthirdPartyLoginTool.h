//
//  SMAthirdPartyLoginTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/24.
//  Copyright © 2016年 SMA. All rights reserved.
//
#define __TencentDemoAppid_  @"222222"
//login
#define kLoginSuccessed @"loginSuccessed"
#define kLoginFailed    @"loginFailed"
#define kLoginCancelled @"loginCancelled"

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface SMAthirdPartyLoginTool : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>
@property (nonatomic, retain)TencentOAuth *oauth;
+ (SMAthirdPartyLoginTool *)getinstance;
+ (void)resetSDK;
- (void)QQlogin;
@end
