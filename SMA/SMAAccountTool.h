//
//  SMAAccountTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMAUserInfo;
@class SmaHRHisInfo;
@class SmaSeatInfo;
@interface SMAAccountTool : NSObject
//保存用户
+ (void)saveUser:(SMAUserInfo *)userInfo;
//获取用户
+ (SMAUserInfo *)userInfo;
//保存心率设置
+ (void)saveHRHis:(SmaHRHisInfo *)HRHisInfo;
//获取心率设置
+ (SmaHRHisInfo *)HRHisInfo;
//久坐设置
+ (void)saveSeat:(SmaSeatInfo *)seatInfo;
+ (SmaSeatInfo *)seatInfo;
@end
