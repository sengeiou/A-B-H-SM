//
//  SMAthirdPartyManager.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/25.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAthirdPartyManager.h"
#import "SMAthirdPartyLoginTool.h"
@implementation SMAthirdPartyManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SMAthirdPartyManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SMAthirdPartyManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    //    self.delegate = nil;
    //    [super dealloc];
}

#pragma mark *****TencentLoginDelegate（QQ登录反馈）
- (void)tencentDidLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"［QQ］" ,@"LOGINTYPE",[[[SMAthirdPartyLoginTool getinstance] oauth] openId],@"OPENID",[[[SMAthirdPartyLoginTool getinstance] oauth] accessToken],@"TOKEN", nil]];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCancelled object:self userInfo:[NSDictionary dictionaryWithObject:@"［QQ］" forKey:@"LOGINTYPE"]];
}

- (void)tencentDidNotNetWork
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［QQ］" forKey:@"LOGINTYPE"]];
}

- (void)wbLoginFinishWithUserID:(NSString *)userid accessToken:(NSString *)token{
    if (userid && token) {
         [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"［Weibo］" ,@"LOGINTYPE",userid,@"OPENID",token,@"TOKEN", nil]];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［Weibo］" forKey:@"LOGINTYPE"]];
    }

}

#pragma mark - WXApiDelegate (微信登录反馈)
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {

    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (!resp.errCode) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdce35a17f98972c9&secret=ab98e83eef1721bb2ff9be7f333082fe&code=%@&grant_type=authorization_code",authResp.code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"［WX］" ,@"LOGINTYPE",[responseObject objectForKey:@"openid"],@"OPENID",[responseObject objectForKey:@"access_token"],@"TOKEN", nil]];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［WX］" forKey:@"LOGINTYPE"]];
            }];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［WX］" forKey:@"LOGINTYPE"]];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {

    }
}
@end
