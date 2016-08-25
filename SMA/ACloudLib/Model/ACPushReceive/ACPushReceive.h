//
//  ACPushReceive.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/10/12.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACObject;
@interface ACPushReceive : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic,unsafe_unretained) long opType;
@property (nonatomic,strong) ACObject *payload;


@end
