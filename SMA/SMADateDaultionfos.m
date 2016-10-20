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

+ (NSString *)minuteFormDate:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSInteger second = [date substringWithRange:NSMakeRange(8, 2)].integerValue * 60 + [date substringWithRange:NSMakeRange(10, 2)].integerValue;
    NSString *moment = [NSString stringWithFormat:@"%ld",second];
    return moment;
}

+ (NSString *)firstDayOfWeekToDate:(NSDate *)date{
    NSDate *now = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    // 得到星期几
    // 2(星期天) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六) 1(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    return [formater stringFromDate:firstDayOfWeek];
}

+ (NSString *)monAndDateStringFormDateStr:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:[formater dateFromString:dateString]];
    NSString *monAndDate = [NSString stringWithFormat:@"%ld.%ld",(long)[comp month],(long)[comp day]];
    return monAndDate;
}
@end
