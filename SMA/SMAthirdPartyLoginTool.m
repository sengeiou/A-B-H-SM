//
//  SMAthirdPartyLoginTool.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAthirdPartyLoginTool.h"

static SMAthirdPartyLoginTool *g_instance = nil;
@interface SMAthirdPartyLoginTool ()

@end
@implementation SMAthirdPartyLoginTool
@synthesize oauth = _oauth;

+ (SMAthirdPartyLoginTool *)getinstance
{
    @synchronized(self)
    {
        if (nil == g_instance)
        {
            //g_instance = [[sdkCall alloc] init];
            g_instance = [[super allocWithZone:nil] init];
//            [g_instance setPhotos:[NSMutableArray arrayWithCapacity:1]];
//            [g_instance setThumbPhotos:[NSMutableArray arrayWithCapacity:1]];
        }
    }
    
    return g_instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getinstance];
}

- (id)init
{
    NSString *appid = __TencentDemoAppid_;
    _oauth = [[TencentOAuth alloc] initWithAppId:appid
                                     andDelegate:[SMAthirdPartyManager sharedManager]];
    
    return self;
}

+ (void)resetSDK
{
    g_instance = nil;
}

- (BOOL)QQlogin{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
   return [_oauth authorize:permissions];
}

- (BOOL)WeChatLoginController:(UIViewController *)viewController{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = WXauthScope;
    req.state = WXauthState;
    req.openID = WXauthOpenId;
    return [WXApi sendAuthReq:req viewController:viewController delegate:[SMAthirdPartyManager sharedManager]];
}


@end
