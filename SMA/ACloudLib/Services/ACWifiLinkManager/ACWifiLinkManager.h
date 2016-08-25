//
//  ACWifiLinkManager.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/9/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACWifiLinkManager : NSObject

- (id)initWithLinkerName:(NSString *)linkerName;

+ (NSString *)getCurrentSSID;

- (void)sendWifiInfo:(NSString *)ssid
            password:(NSString *)password
    physicalDeviceId:(NSString *)physicalDeviceId
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(NSString *deviceId, NSString *bindCode, NSError *error))callback;

- (void)sendWifiInfo:(NSString *)ssid
            password:(NSString *)password
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(NSArray *localDevices, NSError *error))callback;

-(void)stopWifiLink;

@end
