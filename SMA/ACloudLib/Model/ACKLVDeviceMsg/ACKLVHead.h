//
//  ACKLVHead.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKLVValue.h"

@interface ACKLVHead : NSObject

@property (assign, nonatomic) u_int16_t key;
@property (assign, nonatomic) ACKLVType type;

@end
