//
//  ACLocalDevice.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/18/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACLocalDevice : NSObject<NSCoding>

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, assign) NSInteger subDomainId;
@property (nonatomic, assign) NSInteger majorDomainId;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) NSInteger deviceVersion;

- (NSString *)getStaticAESKey;


@end
