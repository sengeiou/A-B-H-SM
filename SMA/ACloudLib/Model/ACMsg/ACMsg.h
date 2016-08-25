//
//  ACMsg.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/10/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACObject.h"
#import "ACContext.h"

@interface ACMsg : ACObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) ACContext *context;
@property (nonatomic, copy) NSString *payloadFormat;
@property (nonatomic, assign) NSUInteger payloadSize;
@property (nonatomic, strong) NSData *payload;
@property (nonatomic, strong, readonly) NSData *streamPayload;

/**
 *  生成带签名信息的ACMsg实例,默认`subDomain`为`nil`
 */
+ (instancetype)msgWithName:(NSString *)name;

/**
 *  生成带签名信息的ACMsg实例, subDomain需要自己传入
 */
+ (instancetype)msgWithName:(NSString *)name subDomain:(NSString *)subDomain;

/**
 * 设置二进制负载
 * 通过put/add方式设置的负载要么框架将其序列化为json，
 * 要么解析后作为url的参数传输。
 * 通过该函数可以设置额外的负载数据。
 * @param payload
 * @param format
 */
- (void)setPayload:(NSData *)payload format:(NSString *)format;
/**
 * 设置流式负载，主要用于较大的数据传输，如上传文件等。
 * @param payload   负载内容
 * @param size      负载大小
 */
- (void)setStreamPayload:(NSData *)streamPayload size:(NSInteger)size;
/**
 * 设置错误信息。在服务端处理错误时，需要显示的调用该结果设置错误信息
 * @param errCode   错误码
 * @param errMsg    错误信息
 */
- (void)setErr:(NSInteger)errCode errMsg:(NSString *)errMsg;
/**
 * 判断服务端响应的处理结果是否有错
 * @return  YES-处理有错，NO-处理成功
 */
- (BOOL)isErr;
- (NSInteger)getErrCode;
- (NSString *)getErrMsg;
- (void)setAck;

extern NSString *const ACMsgObjectPayload;
extern NSString *const ACMsgJsonPayload;
extern NSString *const ACMsgStreamPayload;
extern NSString *const ACMsgMsgNameHeader;
extern NSString *const ACMsgAckMSG;
extern NSString *const ACMsgErrMSG;

@end
