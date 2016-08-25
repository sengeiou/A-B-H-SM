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

@interface SMADefaultinfos : NSObject
+(void)putKey:(NSString *)key andValue:(NSObject *)value;
+(void)putInt:(NSString *)key andValue:(int)value;
+(id)getValueforKey:(NSString *)key;
+(int)getIntValueforKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;
@end
