//
//  ACAccountManager.h
//  ACloudLib
//
//  Created by zhourx5211 on 14/12/8.
//  Copyright (c) 2014年 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACloudLibConst.h"
#import "ACMsg.h"


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

@class ACUserInfo, ACMsg;
@interface ACAccountManager : NSObject

#pragma mark - 验证码
/// 发送验证码
/// @param template     发送短信模板, 使用前需要在控制台定义
+ (void)sendVerifyCodeWithAccount:(NSString *)account
                         template:(NSInteger)template
                         callback:(void (^)(NSError *error))callback;

/// 验证验证码是否可用
+ (void)checkVerifyCodeWithAccount:(NSString *)account
                        verifyCode:(NSString *)verifyCode
                          callback:(void (^)(BOOL valid,NSError *error))callback;

#pragma mark - 注册
/// 注册账号
/// `phone`和`email`二选其一, 如果两个参数同时传入, 那么验证码默认以手机请求的验证码为主
+ (void)registerWithPhone:(NSString *)phone
                    email:(NSString *)email
                 password:(NSString *)password
               verifyCode:(NSString *)verifyCode
                 callback:(void (^)(NSString *uid, NSError *error))callback;

#pragma mark - 登陆
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                callback:(void (^)(NSString *uid, NSError *error))callback;

/// 登陆成功之后返回用户的默认属性对象
+ (void)loginWithUserInfo:(NSString *)account
                 password:(NSString *)password
                 callback:(void (^)(ACUserInfo *user, NSError *error))callback;

#pragma mark - 第三方账号
/// 第三方账号登录
///
/// @param openId        通过第三方登录获取的openId
/// @param provider      第三方类型（如QQ、微信、微博, Facebook, 京东, Twitter, Instagram）
/// @param accessToken   通过第三方登录获取的accessToken
+ (void)loginWithOpenId:(NSString *)openId
               provider:(NSString *)provider
            accessToken:(NSString *)accessToken
               callback:(void (^)(ACUserInfo *user, NSError *error))callback;

/// 绑定第三方账号
///
/// @param openId        通过第三方登录获取的openId
/// @param provider      第三方类型（如QQ、微信、微博、FaceBook等）
/// @param accessToken   通过第三方登录获取的accessToken
+ (void)bindWithOpenId:(NSString *)openId
              provider:(NSString *)provider
           accessToken:(NSString *)acccessToken
              callback:(void(^)(NSError *error))callback;

#pragma mark - 修改密码/昵称/扩展属性
/// 修改密码
+ (void)changePasswordWithOld:(NSString *)old
                          new:(NSString *)newPassword
                     callback:(void (^)(NSString *uid, NSError *error))callback;

/// 重置密码
+ (void)resetPasswordWithAccount:(NSString *)account
                      verifyCode:(NSString *)verifyCode
                        password:(NSString *)password
                        callback:(void (^)(NSString *uid, NSError *error))callback;

/// 更换手机号
/// @param phone    新手机号
+ (void)changePhone:(NSString *)phone
           password:(NSString *)password
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(NSError *error))callback;

/// 更换邮箱
/// @param email    新邮箱
+ (void)changeEmail:(NSString *)email
           password:(NSString *)password
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(NSError *error))callback;

#pragma mark - 扩展属性
/// 根据用户的uid 获取该用户的公有属性
+ (void)getPublicProfilesByUserList:(NSArray *)userList
                           callback:(void(^)(NSArray<ACObject *> *userList, NSError *error))callback;

/// 设置当前用户的头像
+ (void)setAvatar:(UIImage *)image
         callback:(void(^)(NSString *avatarUrl, NSError *error))callback;

/// 修改昵称
+ (void)changeNickName:(NSString *)nickName
              callback:(void (^) (NSError *error))callback;

/// 获取帐号扩展属性
+ (void)getUserProfile:(void (^)(ACObject *profile, NSError *error))callback;

/// 修改帐号扩展属性
+ (void)setUserProfile:(ACObject *)profile
              callback:(void (^)(NSError *error))callback;

#pragma mark - 状态管理
/// 判断用户是否已经存在
+ (void)checkExist:(NSString *)account
          callback:(void(^)(BOOL exist,NSError *error))callback;

/// 判断用户是否已经在本机上过登陆
+ (BOOL)isLogin;

/// 注销当前用户(退出登录)
+ (void)logout;

/// 更新用户的 accessToken
+ (void)updateAccessTokenCallback:(void (^)(BOOL success, NSError *error))callback;

#pragma mark - Deprecated
/// 重置密码返回更多基本信息
+ (void)resetPasswordWithUserInfo:(NSString *)account
                       verifyCode:(NSString *)verifyCode
                         password:(NSString *)password
                         callback:(void (^)(ACUserInfo *user, NSError *error))callback ACDeprecated("过期");

/// 指定昵称注册
/// `phone`和`email`二选其一, 如果两个参数同时传入, 那么验证码默认以手机请求的验证码为主
+ (void)registerWithNickName:(NSString *)nickName
                       phone:(NSString *)phone
                       email:(NSString *)email
                    password:(NSString *)password
                  verifyCode:(NSString *)verifyCode
                    callback:(void (^)(ACUserInfo *user, NSError *error))callback ACDeprecated("过期");


@end
