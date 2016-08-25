//
//  ACloudLib.h
//  ACloudLib
//
//  Created by zhourx5211 on 14/12/8.
//  Copyright (c) 2014年 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kACloudLibVersion @"1.3.0"

//********MODE*******
//测试环境
extern NSString *const ACLoudLibModeTest;
//正式环境
extern NSString *const ACloudLibModeRouter;
//*******REGION******
//中国
extern NSString *const ACLoudLibRegionChina;
//东南亚
extern NSString *const ACLoudLibRegionSouthEastAsia;
//欧洲
extern NSString *const ACLoudLibRegionCentralEurope;
//美洲
extern NSString *const ACLoudLibRegionNorthAmerica;

@class ACMsg, ACDeviceMsg;
@interface ACloudLib : NSObject

+ (NSString *)getVersion;

//手动修改RouterAddress方法
+ (void)setRouterAddress:(NSString*)router;

+ (void)setMode:(NSString *)mode Region:(NSString *)region;

+ (NSString *)getHost;
+ (NSString *)getHttpsHost;
+ (NSString *)getPushHost;

+ (void)setMajorDomain:(NSString *)majorDomain majorDomainId:(NSInteger)majorDomainId;
+ (NSString *)getMajorDomain;
+ (NSInteger)getMajorDomainId;

+ (void)setHttpRequestTimeout:(NSString *)timeout;
+ (NSString *)getHttpRequestTimeout;

+ (void)sendToService:(NSString *)subDomain
          serviceName:(NSString *)name
              version:(NSInteger)version
                  msg:(ACMsg *)msg
             callback:(void (^)(ACMsg *responseMsg, NSError *error))callback;

+ (void)sendToLocalDevice:(NSTimeInterval)timeout
                 deviceId:(NSInteger)deviceId
                      msg:(ACDeviceMsg *)msg
                 callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;


///  局域网给设备发消息, 针对于 deviceVersion == 2使用
+ (void)sendToLocalDevice:(NSTimeInterval)timeout
         physicalDeviceId:(NSString *)physicalDeviceId
                      msg:(ACDeviceMsg *)msg
                 callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;

/**
 *  局域网发现设备
 *
 *  @param timeout     超时时间
 *  @param subDomainId 子域id
 *  @param callback    返回结果的回调
 */
-(void)findDeviceTimeout:(NSInteger )timeout
             SudDomainId:(NSInteger)subDomainId
                callback:(void(^)(NSArray * localDeviceList))callback;


//***********urlString***********
//测试环境
extern NSString *const ACLoudLibBaseUrlString;
//中国(北京)
extern NSString *const ACLoudLibChinaUrlString;
//东南亚
extern NSString *const ACLoudLibSouthEastUrlString;
//欧洲正式环境
extern NSString *const ACLoudLibCentralEuropeUrlString;
//美洲正式环境
extern NSString *const ACLoudLibNorthAmericaUrlString;


@end
