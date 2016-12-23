//
//  ACFindDevicesManager.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/9/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACLocalDevice.h"

@class ACConnectManager;

@protocol ACFindDevicesDelegate <NSObject>

@optional

- (void)ac_findDevices:(NSArray<ACLocalDevice *> *)devices;

@end

@interface ACFindDevicesManager : NSObject

@property (nonatomic, weak) id<ACFindDevicesDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *devices;

- (void)findDevicesWithSubDomainId:(NSInteger)subDomainId
                           timeout:(NSTimeInterval)timeout;


@end
