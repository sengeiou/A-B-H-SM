//
//  ACDeviceMsg.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/25/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//


#import <Foundation/Foundation.h>


//设备通讯的安全性设置
typedef enum: NSInteger {
    //不加密
    ACDeviceSecurityModeNone,
    //静态加密, 即使用默认秘钥.
    ACDeviceSecurityModeStatic,
    //动态加密,使用云端分配的秘钥,要求提前调用接口listDevice/listDeviceWithStatus
    ACDeviceSecurityModeDynamic,

} ACDeviceSecurityMode;

//设备通讯的优先性设置
typedef enum: NSUInteger {
    ACDeviceCommunicationOptionOnlyLocal = 1,  //仅通过局域网
    ACDeviceCommunicationOptionOnlyCloud,      //仅通过云端
    ACDeviceCommunicationOptionCloudFirst,     //云端优先
    ACDeviceCommunicationOptionLocalFirst,     //局域网优先
} ACDeviceCommunicationOption;


@class ACKLVObject, ACObject;
@interface ACDeviceMsg : NSObject
@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) NSInteger msgCode;
@property (nonatomic, strong) NSData *payload;
@property (nonatomic, strong) NSArray *optArray;
@property (nonatomic, copy) NSString *describe;
//用来区分设备固件版本, 开发者不需要使用
@property (nonatomic, assign) NSInteger deviceVersion;
// 与设备通讯的安全性级别, 默认是动态加密
@property (nonatomic, assign, readonly) ACDeviceSecurityMode securePolicy;

///  设置局域网通讯安全模式, 如果不设置, 默认为动态加密
///
///  @param mode 加密方式, 详见ACDeviceSecurityMode枚举
- (void)setSecurityMode:(ACDeviceSecurityMode)mode;
#pragma mark - 初始化器
//json格式
- (instancetype)initWithCode:(NSInteger)code ACObject:(ACObject *)ACObject;
- (ACObject *)getACObject;

//二进制格式
- (instancetype)initWithCode:(NSInteger)code binaryData:(NSData *)binaryData;
- (NSData *)getBinaryData;

//KLV格式
- (instancetype)initWithCode:(NSInteger)code KLVObject:(ACKLVObject *)KLVObject;
- (ACKLVObject *)getKLVObject;

#pragma mark - 解析器
+ (instancetype)unmarshalWithData:(NSData *)data;
+ (instancetype)unmarshalWithData:(NSData *)data AESKey:(NSData *)AESKey;
- (NSData *)marshal;
- (NSData *)marshalWithAESKey:(NSData *)AESKey;

@end
