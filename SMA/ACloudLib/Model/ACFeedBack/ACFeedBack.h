//
//  ACFeedBack.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/2/23.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACObject;
@interface ACFeedBack : NSObject
//子域
@property (nonatomic, copy) NSString *subDomain;
//预留字段, 可传nil
@property (nonatomic, copy) NSString *type;
//开发者自定义的扩展信息，与前端定义的字段一致
@property (nonatomic, strong) ACObject *extend;


///  添加意见反馈项
///  需跟控制台自定义参数对应
///
///  @param key   key
///  @param value value
- (void)addFeedBackWithKey:(NSString *)key value:(NSString *)value;

///  添加意见反馈图片
///
///  @param key   key
///  @param value 图片的url地址
- (void)addFeedBackPictureWithKey:(NSString *)key value:(NSString *)value;
@end

