//
//  SMAAccountTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMAUserInfo;
@interface SMAAccountTool : NSObject
//保存用户
+ (void)saveUser:(SMAUserInfo *)userInfo;
//获取用户
+ (SMAUserInfo *)userInfo;

@end
