//
//  ACFileManager.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/8/31.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ACFileInfo.h"
#import "ACObject.h"
#import "ACMsg.h"
#import "ACloudLib.h"
#import "ACServiceClient.h"

static  NSMutableDictionary * downloadCancelDictionary;
#define FILE_MANAGER_SERVICE @"zc-blobstore"

typedef enum : NSUInteger {
    FileInfoErrorNullInputData      =  1002,
    FileInfoErrorNotAvailableNetwork = 1003,
    FileInfoErrorWriteError          = 1004
}FileInfoError;

typedef double (^progress )();

@interface ACFileManager : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) progress progressCallback;
@property (unsafe_unretained,nonatomic) float progress;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, strong) NSError *error;


@property (nonatomic, strong) NSMutableDictionary *uploadCancelDictionary;
@property (nonatomic, strong) NSMutableDictionary *downloadCancelDictionary;

/**
 * //获取下载URL
 * @param file      文件信息对象
 * @param ExpireTime   url有效期（即多少秒） 若为0，则长期有效 
 * @param payloadCallback    返回结果的监听回调
 */
- (void)getDownloadUrlWithfile:(ACFileInfo *)fileInfo
                    ExpireTime:(long)expireTime
               payloadCallback:( void (^)(NSString * urlString,NSError * error))callback ;

/**
 * //session下载
 * @param urlString   获得的downURLString
 * @param callback    返回error信息的回调
 * @param CompleteCallback   返回完成的信息的回调
 */
- (void)downFileWithsession:(NSString * )urlString
                   checkSum:(NSInteger)checkSum
                   callBack:(void(^)(float progress ,NSError * error))callback
           CompleteCallback:(void (^)(NSString * filePath))completeCallback;

//取消下载
- (void)cancel;
//暂停下载
- (void)suspend;
//恢复下载
- (void)resume;

/**
 * 上传文件
 * @param fileInfo      文件信息
 * @param payloadCallback    返回进度的监听回调
 * @param voidCallback    返回结果的监听回调
 */
- (void)uploadFileWithfileInfo:(ACFileInfo *)fileInfo
              progressCallback:(void(^)(float progress))progressCallback
                  voidCallback:(void(^)(ACMsg *responseObject,NSError * error))voidCallback;

/**
 * //取消上传
 * @param subDomain     用户subDmomain
 * @param fileInfo      文件信息
 */
- (void)cancleUploadWithfileInfo:(ACFileInfo *)fileInfo;

@end
