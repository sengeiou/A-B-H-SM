//
//  ACKLVValue.h
//  test
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 zrx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ACKLVTypeNull = 0x00,
    ACKLVTypeBool = 0x01,
    ACKLVTypeByte = 0x02,
    ACKLVTypeShort = 0x03,
    ACKLVTypeInt = 0x04,
    ACKLVTypeLong = 0x05,
    ACKLVTypeFloat = 0x06,
    ACKLVTypeDouble = 0x07,
    ACKLVTypeString = 0x08,
    ACKLVTypeData = 0x09,
    ACKLVTypeKLVObject = 0xA0,
} ACKLVType;

@interface ACKLVValue : NSObject

@property (assign, nonatomic) ACKLVType type;
@property (strong, nonatomic) id value;

- (id)initWithValue:(id)value type:(ACKLVType)type;

@end
