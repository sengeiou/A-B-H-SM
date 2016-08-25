//
//  ACConnectManager.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/24/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ACDeviceMsg.h"

@class ACConnectManager;

@protocol ACConnectDelegate <NSObject>

@optional
- (void)didConnectWithManager:(ACConnectManager *)manager;
- (void)didDisconnectWithManager:(ACConnectManager *)manager error:(NSError *)err;
- (void)didReceiveSocketMsg:(ACDeviceMsg *)msg;

@end

@interface ACConnectManager : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSData *AESKey;

@property (nonatomic, weak) id<ACConnectDelegate> delegate;

- (void)connectToDeviceTimeout:(NSTimeInterval)timeout;
- (void)sendSocketMsg:(ACDeviceMsg *)msg timeout:(NSTimeInterval)timeout;

@end
