//
//  ACHome.h
//  ac-service-ios-Demo
//
//  Created by ablecloud on 16/2/1.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACHome : NSObject

@property (nonatomic, assign) NSInteger homeId;
//home管理员的userId
@property (nonatomic, assign) NSInteger owner;
//home名字
@property (nonatomic, copy) NSString *name;

@end
