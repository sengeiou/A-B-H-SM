//
//  SMADefaultinfos.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADefaultinfos.h"

@implementation SMADefaultinfos
+(void)putKey:(NSString *)key andValue:(NSObject *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(void)putInt:(NSString *)key andValue:(int)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}


+(id)getValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result = [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

+(int)getIntValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int result = (int)[defaults integerForKey:key];
    return result;
}

+ (void)removeValueForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}
@end
