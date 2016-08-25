//
//  ACCache.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/17/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACCache : NSObject

+ (void)updateGroups:(NSArray *)groups;
+ (NSArray *)getGroupsCache;

+ (void)updateDevices:(NSArray *)devices;
+ (NSArray *)getDevicesCache;

+(void)cache:(NSArray *)array;
+(NSArray *)getCacheArrayWithKey:(NSString *)key;
@end
