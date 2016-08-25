//
//  ACKLVMessage.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKLVHead.h"

@interface ACKLVMessage : NSObject

+ (NSData *)getDataWithKey:(u_int16_t)key type:(ACKLVType)type;
+ (NSData *)getDataWithKey:(u_int16_t)key type:(ACKLVType)type length:(NSInteger)length;
+ (ACKLVHead *)getHeadWithData:(NSData *)data;

@end
