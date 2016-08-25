//
//  ACAccountManager.h
//  ACloudLib
//
//  Created by zhourx5211 on 14/12/8.
//  Copyright (c) 2014年 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"
#import "ACUserInfo.h"

#define USER_SERVICE @"zc-account"

// 第三方的登陆的provider
extern NSString *const ACAccountManagerLoginProviderQQ;
extern NSString *const ACAccountManagerLoginProviderWeibo;
extern NSString *const ACAccountManagerLoginProviderWechat;
extern NSString *const ACAccountManagerLoginProviderJingDong;
extern NSString *const ACAccountManagerLoginProviderFacebook;
extern NSString *const ACAccountManagerLoginProviderTwitter;
extern NSString *const ACAccountManagerLoginProviderInstagram;
extern NSString *const ACAccountManagerLoginProviderOther;

@interface ACAccountManager : NSObject

/**
 *  获取验证码
 */
+ (void)sendVerifyCodeWithAccount:(NSString *)account
                         template:(NSInteger)template
callback:(void (^)(NSError *error))callback;

/**
 *  验证验证码
 */
+ (void)checkVerifyCodeWithAccount:(NSString *)account
                        verifyCode:(NSString *)verifyCode
                          callback:(void (^)(BOOL valid,NSError *error))callback;

/**
 *  注册账号
 */
+ (void)registerWithPhone:(NSString *)phone
                    email:(NSString *)email
                 password:(NSString *)password
               verifyCode:(NSString *)verifyCode
                 callback:(void (^)(NSString *uid, NSError *error))callback;

/**
 * 指定昵称并返回更多基本信息
 */
+ (void)registerWithNickName:(NSString *)nickName
                       phone:(NSString *)phone
                       email:(NSString *)email
                    password:(NSString *)password
                  verifyCode:(NSString *)verifyCode
                    callback:(void (^)(ACUserInfo *user, NSError *error))callback;
/**
 *  登录
 */
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                callback:(void (^)(NSString *uid, NSError *error))callback;

/**
 * 登录返回更多基本信息
 */
+ (void)loginWithUserInfo:(NSString *)account
                 password:(NSString *)password
                 callback:(void (^)(ACUserInfo *user, NSError *error))callback;

/**
 * 绑定第三方账号
 *
 * @param provider      第三方类型（如QQ、微信、微博, Facebook, 京东, Twitter, Instagram）
 * @param openId        通过第三方登录获取的openId
 * @param accessToken   通过第三方登录获取的accessToken
 * @param callback      返回结果的监听回调
 */
+ (void)registerWithOpenId:(NSString *)openId
                  provider:(NSString *)provider
               accessToken:(NSString *)accessToken
                  callback:(void (^)(ACUserInfo *user, NSError *error))callback;

/**
 * 第三方账号登录
 *
 * @param openId        通过第三方登录获取的openId
 * @param provider      第三方类型（如QQ、微信、微博, Facebook, 京东, Twitter, Instagram）
 * @param accessToken   通过第三方登录获取的accessToken
 * @param callback      返回结果的监听回调
 */
+ (void)loginWithOpenId:(NSString *)openId
               provider:(NSString *)provider
            accessToken:(NSString *)accessToken
               callback:(void (^)(ACUserInfo *user, NSError *error))callback;
/**
 *  重置密码
 */
+ (void)resetPasswordWithAccount:(NSString *)account
                      verifyCode:(NSString *)verifyCode
                        password:(NSString *)password
                        callback:(void (^)(NSString *uid, NSError *error))callback;
/**
 *  重置密码返回更多基本信息
 */
+ (void)resetPasswordWithUserInfo:(NSString *)account
                       verifyCode:(NSString *)verifyCode
                         password:(NSString *)password
                         callback:(void (^)(ACUserInfo *user, NSError *error))callback;

/**
 *  修改密码
 */
+ (void)changePasswordWithOld:(NSString *)old
                          new:(NSString *)newPassword
                     callback:(void (^)(NSString *uid, NSError *error))callback;

/**
 * 修改昵称
 */
+ (void) changeNickName:(NSString *)nickName
               callback:(void (^) (NSError *error))callback;

/**
 * 修改帐号扩展属性
 */
+ (void) setUserProfile:(ACObject *)profile
               callback:(void (^) (NSError *error))callback;

/**
 * 获取帐号扩展属性
 */
+ (void) getUserProfile:(void (^) (ACObject*profile, NSError *error))callback;


/**
 *  更换手机号
 */
+ (void)changePhone:(NSString *)phone
           password:(NSString *)password
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(NSError *error)) callback;

/**
 *  更换邮箱
 */
+ (void)changeEmail:(NSString *)email
           password:(NSString *)password
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(NSError *error)) callback;

/**
 *  判断用户是否已经存在
 */
+ (void)checkExist:(NSString *)account
          callback:(void(^)(BOOL exist,NSError *error))callback;

/**
 *  判断用户是否已经在本机上过登陆
 */
+ (BOOL)isLogin;

/**
 *  注销当前用户
 */
+ (void)logout;

/// 更新用户的 accessToken
+ (void)updateAccessTokenCallback:(void (^)(BOOL success, NSError *error))callback;


@end
