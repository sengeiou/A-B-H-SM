//
//  ACDeviceStub.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/15/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACDeviceMsg.h"

@protocol ACDeviceStubDelegate <NSObject>

- (void)handleDeviceMsg:(ACDeviceMsg *)req callback:(void (^)(ACDeviceMsg *responseObject, NSError *error))callback;

@end

@interface ACDeviceStub : NSObject

+ (instancetype)sharedInstance;

+ (void)setDeviceStub:(NSString *)subDomain delegate:(id<ACDeviceStubDelegate>)delegate;
+ (id<ACDeviceStubDelegate>)getDeviceStubDelegate:(NSString *)subDomain;
+ (void)removeDeviceStub:(NSString *)subDomain;
+ (BOOL)isDeviceStub:(NSString *)subDomain;

@end
