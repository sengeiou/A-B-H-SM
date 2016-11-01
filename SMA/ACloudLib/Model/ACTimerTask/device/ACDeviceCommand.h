//
//  ACDeviceCommand.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/7/16.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDeviceCommand : NSObject
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSData *binaryData;
@property (nonatomic, copy, readonly) NSString *binary;

///  生成一条发给设备的任务指令
///  注: 设备指令只能用于创建设备任务组
///
///  @param code       消息代码
///  @param binaryData 消息数据
///
///  @return 任务指令实例
- (instancetype)initWithCode:(NSString *)code binaryData:(NSData *)binaryData;

+ (instancetype)deviceCommandWithDict:(NSDictionary *)dict;

@end
