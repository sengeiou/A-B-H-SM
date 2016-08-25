//
//  ACKLVObject.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKLVValue.h"

@interface ACKLVObject : NSObject

/**
 * 获取一个参数值
 * @param name	参数名
 * @return		参数值
 */
- (ACKLVValue *)getValueForKey:(u_int16_t)key;
- (NSNull *)get:(u_int16_t)key;
- (BOOL)getBool:(u_int16_t)key;
- (Byte)getByte:(u_int16_t)key;
- (short)getShort:(u_int16_t)key;
- (int)getInt:(u_int16_t)key;
- (long)getLong:(u_int16_t)key;
- (float)getFloat:(u_int16_t)key;
- (double)getDouble:(u_int16_t)key;
- (NSString *)getString:(u_int16_t)key;
- (NSData *)getData:(u_int16_t)key;

/**
 * 设置一个参数
 * @param name	参数名
 * @param value	参数值
 * @return
 */
- (void)put:(u_int16_t)key;
- (void)putBool:(u_int16_t)key value:(BOOL)value;
- (void)putByte:(u_int16_t)key value:(Byte)value;
- (void)putShort:(u_int16_t)key value:(short)value;
- (void)putInt:(u_int16_t)key value:(int)value;
- (void)putLong:(u_int16_t)key value:(long)value;
- (void)putFloat:(u_int16_t)key value:(float)value;
- (void)putDouble:(u_int16_t)key value:(double)value;
- (void)putString:(u_int16_t)key value:(NSString *)value;
- (void)putData:(u_int16_t)key value:(NSData *)value;

- (BOOL)contains:(u_int16_t)key;
- (NSIndexSet *)getKeys;

- (BOOL)hasObjectData;
- (NSDictionary *)getObjectData;
- (void)setObjectData:(NSDictionary *)data;

@end
