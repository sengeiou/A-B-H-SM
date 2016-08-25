//
//  ACKLVDeviceMsgMarshaller.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//
//  KLV格式序列化器


#import <Foundation/Foundation.h>


@class ACKLVObject;
@interface ACKLVDeviceMsgMarshaller : NSObject

+ (NSData *)marshalWithKLVObject:(ACKLVObject *)object;
+ (ACKLVObject *)unmarshalWithData:(NSData *)data;

@end
