//
//  SMADefaultinfos.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FIRSTLUN @"FIRSTLUN"//首次打开软件
#define SPORTGOAL @"SPORTGOAL" //运动目标
#define QUIETHEART @"QUIETHEART" //静息心率
#define SENDHEALTHSTEP @"SENDHEALTHSTEP"//上传苹果健康步数
#define HEALTHDAY @"HEALTHDAY"//上传苹果健康日期
#define ANTILOSTSET @"ANTILOSTSET" //防丢设置
#define NODISTRUBSET @"NODISTRUBSET" //勿扰设置
#define CALLSET @"CALLSET" //来电提醒
#define SMSSET  @"SMSSET"  //短信提醒
#define SCREENSET @"SCREENSET" //屏幕设置
#define SLEEPMONSET @"SLEEPMONSET" //心率测睡
#define VIBRATIONSET @"VIBRATIONSET" //震动设置
#define BACKLIGHTSET @"BACKLIGHTSET" //背光设置
#define BANDDEVELIVE @"BANDDEVELIVE" //所绑定的设备名
#define THIRDLOGIN @"THIRDLOGIN" //第三方登录
#define UPDATEDATE @"UPDATEDATE" //保存当天日期，以便判断跨天刷新数据判断
#define BRITISHSYSTEM @"BRITISHSYSTEM" //公英制设置
#define DEVICEMAC @"DEVICEMAC"//mac地址
#define RUNKSTEP @"RUNKSTEP"//排行榜信息
#define SMACUSTOM @"SMACUSTOM" //定制项目标志
@interface SMADefaultinfos : NSObject
+(void)putKey:(NSString *)key andValue:(NSObject *)value;
+(void)putInt:(NSString *)key andValue:(int)value;
+(id)getValueforKey:(NSString *)key;
+(int)getIntValueforKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;
@end
