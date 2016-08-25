//
//  ACRoom.h
//  ac-service-ios-Demo
//
//  Created by ablecloud on 16/2/1.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRoom : NSObject
@property (nonatomic, assign) NSInteger homeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger owner;
@property (nonatomic, assign) NSInteger roomId;
@end
