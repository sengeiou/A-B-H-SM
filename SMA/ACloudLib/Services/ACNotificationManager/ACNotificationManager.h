//
//  ACNotificationManager.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 7/21/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

@interface ACNotificationManager : NSObject

/** 绑定App的appKey和启动参数，启动消息参数用于处理用户通过消息打开应用相关信息
 @param appKey      主站生成appKey
 @param launchOptions 启动参数
 */
+ (void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions;

/** 注册RemoteNotification的类型
 @brief 开启消息推送，实际调用：[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
 @warning 此接口只针对 iOS 7及其以下的版本，iOS 8 请使用 `registerRemoteNotificationAndUserNotificationSettings`
 @param types 消息类型，参见`UIRemoteNotificationType`
 */
+ (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types NS_DEPRECATED_IOS(3_0, 8_0, "Please use registerRemoteNotificationAndUserNotificationSettings instead");

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
/** 注册RemoteNotification的类型
 @brief 开启消息推送，实际调用：[[UIApplication sharedApplication] registerForRemoteNotifications]和registerUserNotificationSettings;
 @warning 此接口只针对 iOS 8及其以上的版本，iOS 7 请使用 `registerForRemoteNotificationTypes`
 @param types 消息类型，参见`UIRemoteNotificationType`
 */
+ (void)registerRemoteNotificationAndUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0);
#endif

/** 解除RemoteNotification的注册（关闭消息推送，实际调用：[[UIApplication sharedApplication] unregisterForRemoteNotifications]）
 @param types 消息类型，参见`UIRemoteNotificationType`
 */
+ (void)unregisterForRemoteNotifications;

/** 向友盟注册该设备的deviceToken，便于发送Push消息
 @param deviceToken APNs返回的deviceToken
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/** 应用处于运行时（前台、后台）的消息处理
 @param userInfo 消息参数
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/** 为某个消息发送点击事件
 @warning 请注意不要对同一个消息重复调用此方法，可能导致你的消息打开率飚升，此方法只在需要定制 Alert 框时调用
 @param userInfo 消息体的NSDictionary，此Dictionary是
 (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo中的userInfo
 */
+ (void)setNotificationClickForRemoteNotification:(NSDictionary *)userInfo;

/**
 * 添加推送别名
 *
 * @param userId   用户ID
 * @param callback 返回结果的监听回调
 */
+ (void)addAliasWithUserId:(NSInteger)userId callback:(void (^)(NSError *error))callback;

/**
 * 若要使用新的别名，请先调用removeAlias接口移除掉旧的别名
 *
 * @param userId   用户ID
 * @param callback 返回结果的监听回调
 */
+ (void)removeAliasWithUserId:(NSInteger)userId callback:(void (^)(NSError *error))callback;

@end
