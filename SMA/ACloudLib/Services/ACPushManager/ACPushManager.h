//
//  ACPushManager.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/10/12.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPushTable.h"
#import "ACPushReceive.h"
#import "AFNetworking.h"

@interface ACPushManager : NSObject

//建立与服务器的连接
-(void)connectWithCallback:(void(^)(NSError * error))callback;
//订阅实时数据
-(void)watchWithTable:(ACPushTable *)table Callback:(void(^)(NSError * error))callback;
//接受已经订阅的实时数据
-(void)onReceiveWithCallback:(void(^)(ACPushReceive * pushReceive ,NSError * error))callback;
//取消已经订阅的实时数据
-(void)unWatchWithPushTable:(ACPushTable *)table Callback:(void(^)(NSError * error))callback;

@end
