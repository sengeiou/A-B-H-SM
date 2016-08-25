//
//  ACDeviceClient.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 3/14/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACDeviceMsg.h"

@interface ACDeviceClient : NSObject

//请使用ACBindManager中 sendToDeviceWithOption:msg:physicalDeviceId:timeout:callback 方法, 不要直接使用该方法
- (void)sendToDevice:(NSInteger)subDomainId
                 msg:(ACDeviceMsg *)msg
            deviceId:(NSInteger)deviceId
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;

//请使用ACBindManager中 sendToDeviceWithOption:msg:physicalDeviceId:timeout:callback 方法, 不要直接使用该方法
- (void)sendToDevice:(NSInteger)subDomainId
                 msg:(ACDeviceMsg *)msg
    physicalDeviceId:(NSString *)physicalDeviceId
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;


@end
