//
//  ACDeviceMsg.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/25/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//


#import <Foundation/Foundation.h>

//设备通讯的安全性设置
typedef NS_ENUM(NSUInteger, ACDeviceSecurityMode) {
    //不加密
    ACDeviceSecurityModeNone,
    //静态加密, 即使用默认秘钥
    ACDeviceSecurityModeStatic,
    //动态加密,使用云端分配的秘钥
    ACDeviceSecurityModeDynamic,
};

@class ACObject;
@interface ACDeviceMsg : NSObject
@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) NSInteger msgCode;
@property (nonatomic, strong) NSData *payload;
@property (nonatomic, strong) NSArray *optArray;
@property (nonatomic, copy) NSString *describe;
/// 用来区分设备固件版本, 开发者不需要使用
@property (nonatomic, assign) NSInteger deviceVersion;

/// 与设备通讯的安全性级别, 默认是动态加密
@property (nonatomic, assign, readonly) ACDeviceSecurityMode securePolicy;
/// 设置局域网通讯安全模式
/// 如果不设置, 默认为动态加密
- (void)setSecurityMode:(ACDeviceSecurityMode)mode;


#pragma mark - 初始化器
//json格式
- (instancetype)initWithCode:(NSInteger)code ACObject:(ACObject *)ACObject;
- (ACObject *)getACObject;

//二进制格式
- (instancetype)initWithCode:(NSInteger)code binaryData:(NSData *)binaryData;
- (NSData *)getBinaryData;

#pragma mark - 解析器
+ (instancetype)unmarshalWithData:(NSData *)data;
+ (instancetype)unmarshalWithData:(NSData *)data AESKey:(NSData *)AESKey;
- (NSData *)marshal;
- (NSData *)marshalWithAESKey:(NSData *)AESKey;

@end
