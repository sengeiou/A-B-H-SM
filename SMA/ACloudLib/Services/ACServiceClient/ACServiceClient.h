//
//  ACServiceClient.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/11/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"

@interface ACServiceClient : NSObject

@property (readonly, nonatomic, copy) NSString *host;
@property (readonly, nonatomic, copy) NSString *service;
@property (readonly, nonatomic, assign) NSInteger serviceVersion;

- (id)initWithHost:(NSString *)host service:(NSString *)service version:(NSInteger)version;

+ (instancetype)serviceClientWithHost:(NSString *)host service:(NSString *)service version:(NSInteger)version;

- (void)sendToService:(ACMsg *)req callback:(void (^)(ACMsg *responseObject, NSError *error))callback;

- (BOOL)ac_isValidRefreshToken;

/**
 * 往某一服务发送命令/消息(匿名)
 *
 * @param subDomain      子域2
 * @param serviceName    服务名
 * @param ServiceVersion 服务版本
 * @param req            具体的消息内容
 * @callback             服务端相应的消息
 */
+ (void)sendToServiceWithoutSignWithSubDomain:(NSString *)subDomain
                                  ServiceName:(NSString *)serviceName
                               ServiceVersion:(NSInteger)serviceVersion
                                          Req:(ACMsg *)req
                                     Callback:(void(^)(ACMsg * responseMsg,NSError *error))callback;

@end
