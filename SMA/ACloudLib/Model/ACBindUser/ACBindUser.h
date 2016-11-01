//
//  ACBindUser.h
//  AbleCloudLib
//
//  Created by OK on 15/3/26.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户类型
typedef enum : NSUInteger {
    BindUserTypeCommon = 0,
    BindUserTypeAdmin = 1
} BindUserType;

@class ACObject;
@interface ACBindUser : NSObject
//用户ID
@property(nonatomic,assign) NSInteger userId;
//设备的逻辑ID
@property(nonatomic,assign) NSInteger deviceId;
// 用户类型
@property(nonatomic,assign) BindUserType userType;
//  用户昵称
@property(nonatomic,copy) NSString *nickName;
// 手机号码
@property(nonatomic,copy) NSString *phone;
// 电子邮件地址
@property(nonatomic,copy) NSString *email;
// Open ID
@property(nonatomic,copy) NSString *openId;
// Open ID类型
@property(nonatomic,assign) NSInteger openIdType;
// 用户拓展属性
@property (nonatomic, strong) ACObject *profile;

+ (instancetype)bindUserWithDict:(NSDictionary *)dict;

@end
