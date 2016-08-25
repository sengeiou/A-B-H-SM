//
//  ACUserDevice.h
//  AbleCloudLib
//
//  Created by OK on 15/3/24.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ACUserDevice : NSObject<NSCoding>
//设备逻辑ID
@property (nonatomic, assign) NSInteger deviceId;
//设备管理员ID
@property (nonatomic, assign) NSInteger ownerId;
//设备名称
@property (nonatomic, copy) NSString *deviceName;
//子域ID
@property (nonatomic, assign) NSInteger subDomainId;
//子域名称
@property (nonatomic, copy) NSString *subDomain;
//局域网访问key
@property (nonatomic, strong) NSData *AESkey;
//设备物理ID
@property (nonatomic, copy) NSString *physicalDeviceId;
//设备网关ID
@property (nonatomic, assign) NSInteger gatewayDeviceId;
//设备根分组ID
@property (nonatomic, assign) NSInteger rootId;
//设备状态
@property (nonatomic, assign) NSInteger status;


+ (instancetype)userDeviceWithDict:(NSDictionary *)dict;

@end
