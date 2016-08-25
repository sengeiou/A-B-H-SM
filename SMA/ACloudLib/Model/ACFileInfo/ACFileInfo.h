//
//  ACFileInfo.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/8/31.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACACL.h"

@interface ACFileInfo : NSObject
//上传文件名字
@property (nonatomic, copy) NSString *name;

//上传小型文件，直接上传数据 不支持断点续传
@property (unsafe_unretained, nonatomic) Byte *data;

//上传文件路径，支持断点续传
@property (copy,nonatomic) NSString *filePath;

//文件访问权限 如果不设置 则默认
@property (nonatomic, strong) ACACL *acl;

//文件存储的空间   用户自定义   如名字为Image或者text的文件夹下
@property (nonatomic, copy) NSString *bucket;

//crc校验使用
@property (nonatomic, unsafe_unretained) NSInteger checksum;

//文件是否公开 ———— 两个选择  私有文件类型private  公开文件类型public
//@property (copy,nonatomic) NSString * bucketType;

-(id)initWithName:(NSString *)name bucket:(NSString *)bucket;

-(id)initWithName:(NSString *)name bucket:(NSString *)bucket Checksum:(NSInteger )checksum;
+(instancetype)fileInfoWithName:(NSString *)name bucket:(NSString *)bucket CheckSum:(NSInteger )checksum;
-(BOOL)isCrc;

@end
