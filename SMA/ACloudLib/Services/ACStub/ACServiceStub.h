//
//  ACServiceStub.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/15/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"

@protocol ACServiceStubDelegate <NSObject>

- (void)handleServiceMsg:(ACMsg *)req callback:(void (^)(ACMsg *responseObject, NSError *error))callback;

@end

@interface ACServiceStub : NSObject

+ (instancetype)sharedInstance;

+ (void)setServiceStub:(NSString *)serviceName delegate:(id<ACServiceStubDelegate>)delegate;
+ (id<ACServiceStubDelegate>)getServiceStubDelegate:(NSString *)serviceName;
+ (void)removeServiceStub:(NSString *)serviceName;
+ (BOOL)isServiceStub:(NSString *)serviceName;

@end
