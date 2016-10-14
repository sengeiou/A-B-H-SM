//
//  SMADateDaultionfos.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADateDaultionfos.h"

@implementation SMADateDaultionfos
+ (NSTimeInterval)msecIntervalSince1970WithHour:(NSString *)hour Minute:(NSString *)minute timeZone:(NSTimeZone *)zone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    if (zone) {
        NSTimeZone* GTMzone = zone;
        [formatter setTimeZone:GTMzone];
        [formatter1 setTimeZone:GTMzone];
    }
    NSTimeInterval timeIntervalSince1970 = [[formatter dateFromString:[NSString stringWithFormat:@"%@%@%@00",[formatter1 stringFromDate:[NSDate date]],hour.intValue < 10?[NSString stringWithFormat:@"0%@",hour]:hour,minute.intValue < 10?[NSString stringWithFormat:@"0%@",minute]:minute]] timeIntervalSince1970];
    return timeIntervalSince1970 * 1000;
}

+ (NSTimeInterval)msecIntervalSince1970Withdate:(NSString *)date timeZone:(NSTimeZone *)zone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    if (zone) {
        NSTimeZone* GTMzone = zone;
        [formatter setTimeZone:GTMzone];
        [formatter1 setTimeZone:GTMzone];
    }
    NSTimeInterval timeIntervalSince1970 = [[formatter dateFromString:date] timeIntervalSince1970];
    return timeIntervalSince1970 * 1000;
}

+ (NSString *)stringFormmsecIntervalSince1970:(NSTimeInterval)interval timeZone:(NSTimeZone *)zone{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    if (zone) {
        NSTimeZone* GTMzone = zone;
        [formatter setTimeZone:GTMzone];
    }
    NSString *nowDate = [formatter stringFromDate:date];
  return nowDate;
}
@end
