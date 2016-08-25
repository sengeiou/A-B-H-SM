//
//  ACGroupManager.h
//  ac-service-ios-Demo
//
//  Created by ablecloud on 16/2/1.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GROUP_SERVICE @"zc-bind"


@class ACHome, ACRoom;
@interface ACGroupManager : NSObject
/**
 * 创建家庭，任何人可创建
 *
 * @param name     家庭名字
 * @param callback 返回结果的监听回调
 */
+ (void)createHomeWithName:(NSString *)name callback:(void (^)(ACHome *home, NSError *error))callback;

/**
 * 删除家庭，只有组的管理员可删除。删除家庭，家庭内所有的设备和设备的绑定关系删除。普通用户调用该接口相当于退出家庭
 *
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)deleteHomeWithHomeId:(NSInteger)homeId callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 创建房间，只有home的管理员可以创建。room从属于home。
 *
 * @param homeId   家庭id
 * @param name     房间名字
 * @param callback 返回结果的监听回调
 */
+ (void)createRoomWithHomeId:(NSInteger)homeId name:(NSString *)name callback:(void(^)(ACRoom *room, NSError *error))callback;

/**
 * 只有home的管理员可以删除。Room删除后，原来在room下面的设备自动划转到home下
 *
 * @param homeId   家庭id
 * @param roomId   房间id
 * @param callback 返回结果的监听回调
 */
+ (void)deleteRoomWithHomeId:(NSInteger)homeId roomId:(NSInteger)roomId callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 设备是新设备
 * 将设备添加到家庭。返回设备对象。所有对家庭有控制权的用户都对该设备有使用权
 * 当添加的设备为网关时，网关下面的子设备全部添加到家庭
 * 给网关添加子设备仍然调用addSubDevice接口，添加到网关的子设备需要再次调用此接口添加到home
 *
 * @param subDomain        子域名，如djj（豆浆机）
 * @param physicalDeviceId 设备id（制造商提供的）
 * @param homeId           家庭id
 * @param name             设备名字
 * @param callback         返回结果的监听回调
 */
+ (void)addDeviceToHomeWithSubDomain:(NSString *)subDomian physicalDeviceId:(NSString *)physicalDeviceId homeId:(NSInteger)homeId name:(NSString *)name callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 设备不是新设备
 * 将设备添加到家庭。返回设备对象。所有对家庭有控制权的用户都对该设备有使用权
 * 当添加的设备为网关时，网关下面的子设备全部添加到家庭。
 * 给网关添加子设备仍然调用addSubDevice接口，添加到网关的子设备需要再次调用此接口添加到home。
 *
 * @param subDomain 子域名，如djj（豆浆机）
 * @param deviceId  设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param homeId    家庭id
 * @param name      设备名字
 * @param callback  返回结果的监听回调
 */
 + (void)addDeviceToHomeWithSubDomain:(NSString *)subDomian deviceId:(NSInteger)deviceId homeId:(NSInteger)homeId name:(NSString *)name callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 从家庭里删除设备，设备变为新的设备，所有绑定权限失效。删除网关时，网关和下面所有子设备一起删除。删除子设备时，子设备和网关的绑定关系同时解除
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)deleteDeviceFromHomeWithDeviceId:(NSInteger)deviceId homeId:(NSInteger)homeId callback:(void(^)(BOOL isSuccess, NSError *error))callback ;

/**
 * 将设备移动到房间中，要求设备和room在同一个home下才可以。当设备为网关时，网关下面的子设备原位置不变
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param homeId   家庭id
 * @param roomId   房间id
 * @param callback 返回结果的监听回调
 */
+ (void)moveDeviceToRoomWithDeviceId:(NSInteger)deviceId homeId:(NSInteger)homeId roomId:(NSInteger)roomId callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 将设备从房间中移除。从房间中移除的设备移动到家庭下
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param homeId   家庭id
 * @param roomId   房间id
 * @param callback 返回结果的监听回调
 */
+ (void)removeDeviceFromRoomWithDeviceId:(NSInteger)deviceId homeId:(NSInteger)homeId roomId:(NSInteger)roomId callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 获取家庭的分享码（只有管理员可以获取 ）
 *
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)getHomeShareCodeWithHomeId:(NSInteger)homeId callback:(void(^)(NSString *shareCode, NSError *error))callback;

/**
 * 普通用户通过管理员分享的二维码加入家庭
 *
 * @param shareCode 分享码
 * @param callback 返回结果的监听回调
 */
+ (void)joinHomeWithShareCode:(NSString *)shareCode callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 管理员直接将某人加入到家庭
 *
 * @param homeId   家庭id
 * @param account  手机号或者email
 * @param callback 返回结果的监听回调
 */
+ (void)addUserToHomeWithHomeId:(NSInteger)homeId account:(NSString *)account callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 管理员直接将某人从家中移除
 *
 * @param homeId   家庭id
 * @param userId   被移除用户的userId
 * @param callback 返回结果的监听回调
 */
+ (void)removeUserFromHomeWithHomeId:(NSInteger)homeId userId:(NSInteger)userId callback:(void(^)(BOOL isSuccess, NSError *error))callback;

/**
 * 列出某个用户有使用权的所有家庭
 *
 * @param callback 返回结果的监听回调
 */
+ (void)listHomes:(void(^)(NSArray *homeList, NSError *error))callback;

/**
 * 获取某个home下面的所有room
 *
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)listRoomsWithHomeId:(NSInteger)homeId callback:(void(^)(NSArray *roomList, NSError *error))callback;

/**
 * 列出家庭下的所有设备
 *
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)listHomeDevicesWithHomeId:(NSInteger)homeId callback:(void(^)(NSArray *devices,NSError *error))callback;

/**
 * 列出房间里的所有设备
 *
 * @param homeId   家庭id
 * @param roomId   房间id
 * @param callback 返回结果的监听回调
 */
+ (void)listRoomDevicesWithHomeId:(NSInteger)homeId roomId:(NSInteger)roomId callback:(void(^)(NSArray *devices,NSError *error))callback;

/**
 * 列出家庭成员
 *
 * @param homeId   家庭id
 * @param callback 返回结果的监听回调
 */
+ (void)listHomeUsersWithHomeId:(NSInteger)homeId callback:(void(^)(NSArray *users, NSError *error))callback;

/**
 * 更改家庭名称，普通用户和管理员均有权限更改。App端可以自己设定普通用户是否有权限更改。
 *
 * @param homeId   家庭id
 * @param name     家庭名字
 * @param callback 返回结果的监听回调
 */
+ (void)changeHomeNameWithHomeId:(NSInteger)homeId name:(NSString *)name callback:(void(^)(BOOL isSuccess, NSError *error))callback;
/**
 * 更改room名称，普通用户和管理员均有权限更改。App端可以自己设定普通用户是否有权限更改。
 *
 * @param homeId   家庭id
 * @param roomId   房间id
 * @param name     房间名字
 * @param callback 返回结果的监听回调
 */
+ (void)changeRoomNameWithHomeId:(NSInteger)homeId roomId:(NSInteger)roomId name:(NSString *)name callback:(void(^)(BOOL isSuccess, NSError *error))callback;

@end
