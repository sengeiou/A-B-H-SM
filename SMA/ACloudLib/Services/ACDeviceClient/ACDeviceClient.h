//
//  ACDeviceClient.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 3/14/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACDeviceMsg.h"
#import "ACloudLibConst.h"

@interface ACDeviceClient : NSObject

- (void)sendToDevice:(NSInteger)subDomainId
                 msg:(ACDeviceMsg *)msg
    physicalDeviceId:(NSString *)physicalDeviceId
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;


#pragma mark - Deperated
- (void)sendToDevice:(NSInteger)subDomainId
                 msg:(ACDeviceMsg *)msg
            deviceId:(NSInteger)deviceId
             timeout:(NSTimeInterval)timeout
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback ACDeprecated("使用sendToDevice:msg:physicalDeviceId:timeout:callback");


@end
