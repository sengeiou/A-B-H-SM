//
//  SMAWebDataHandleInfo.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/19.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAWebDataHandleInfo.h"

@implementation SMAWebDataHandleInfo

+ (ACObject *)heartRateSetObject{
    ACObject *HRObject = [[ACObject alloc] init];
    if (![SMAAccountTool HRHisInfo]) {
        return nil;
    }
    [HRObject putString:@"account" value:[SMAAccountTool userInfo].userID];
    [HRObject putInteger:@"start" value:[SMAAccountTool HRHisInfo].beginhour0.integerValue];
    [HRObject putInteger:@"end" value:[SMAAccountTool HRHisInfo].endhour0.integerValue];
    [HRObject putInteger:@"interval" value:[SMAAccountTool HRHisInfo].tagname.integerValue];
    [HRObject putInteger:@"enabled" value:[SMAAccountTool HRHisInfo].isopen0.integerValue];
    return HRObject;
}

+ (ACObject *)sedentarinessSetObject{
    ACObject *HRObject = [[ACObject alloc] init];
    if (![SMAAccountTool seatInfo]) {
        return nil;
    }
    [HRObject putString:@"account" value:[SMAAccountTool userInfo].userID];
    [HRObject putInteger:@"repeat" value:[SMAAccountTool seatInfo].repeatWeek.integerValue];
    [HRObject putInteger:@"start1" value:[SMAAccountTool seatInfo].beginTime0.integerValue];
    [HRObject putInteger:@"end1" value:[SMAAccountTool seatInfo].endTime0.integerValue];
    [HRObject putInteger:@"enabled1" value:[SMAAccountTool seatInfo].isOpen0.integerValue];
    [HRObject putInteger:@"start2" value:[SMAAccountTool seatInfo].beginTime1.integerValue];
    [HRObject putInteger:@"end2" value:[SMAAccountTool seatInfo].endTime1.integerValue];
    [HRObject putInteger:@"enabled2" value:[SMAAccountTool seatInfo].isOpen1.integerValue];
    [HRObject putInteger:@"interval" value:[SMAAccountTool seatInfo].seatValue.integerValue];
    [HRObject putInteger:@"threshold" value:[SMAAccountTool seatInfo].stepValue.integerValue];
    return HRObject;
}

+ (void)saveWebHeartRateSetObject:(ACObject *)object{
    SmaHRHisInfo *hrInfo = [[SmaHRHisInfo alloc] init];
    hrInfo.isopen = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"enabled"]];
    hrInfo.isopen0 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"enabled"]];
    hrInfo.dayFlags=@"127";//每天
    hrInfo.tagname = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"interval"]];
    hrInfo.beginhour0 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"start"]];
    hrInfo.tagname = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"end"]];
}

+ (void)saveWebSedentarinessSetObject:(ACObject *)object{
    SmaSeatInfo *seat = [[SmaSeatInfo alloc] init];
    seat.isOpen = @"1";
    seat.repeatWeek = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"repeat"]];
    seat.beginTime0 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"start1"]];
    seat.endTime0 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"end1"]];
    seat.isOpen0 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"enabled1"]];
    seat.beginTime1 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"start2"]];
    seat.endTime1 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"end2"]];
    seat.isOpen1 = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"enabled2"]];
    seat.seatValue = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"interval"]];
    seat.stepValue = [NSString stringWithFormat:@"%ld",(long)[object getInteger:@"threshold"]];
    [SMAAccountTool saveSeat:seat];
}

+ (void)updateSLData:(NSMutableArray *)slList finish:(void (^)(id finish)) callBack{
    NSMutableArray *slArr = [NSMutableArray array];
    for (int i = 0; i < slList.count; i ++) {
        NSDictionary *dic = [slList objectAtIndex:i];
        NSMutableDictionary *slDic = [NSMutableDictionary dictionary];
        NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[dic objectForKey:@"time"] doubleValue] withFormatStr:@"yyyyMMddHHmmss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [slDic setObject:date forKey:@"DATE"];
        [slDic setObject:[dic objectForKey:@"mode"] forKey:@"MODE"];
        [slDic setObject:[dic objectForKey:@"strong"] forKey:@"STRONG"];
        [slDic setObject:[dic objectForKey:@"soft"] forKey:@"SOFTLY"];
        [slDic setObject:[dic objectForKey:@"mode"] forKey:@"MODE"];
        [slDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] ? [SMADefaultinfos getValueforKey:BANDDEVELIVE]:@"SM07" forKey:@"INDEX"];
        [slDic setObject:@"1" forKey:@"WEB"];
        [slDic setObject:@"1" forKey:@"WEAR"];
        [slDic setObject:[[slList objectAtIndex:i] objectForKey:@"account"] forKey:@"USERID"];
        [slArr addObject:slDic];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        SMADatabase *dal = [[SMADatabase alloc] init];
        [dal insertSleepDataArr:slArr finish:^(id finish) {
            callBack(finish);
        }];
    });
}

+ (void)updateSPData:(NSMutableArray *)spList finish:(void (^)(id finish)) callBack{
    NSMutableArray *spArr = [NSMutableArray array];
    for (int i = 0; i < spList.count; i ++) {
        NSDictionary *dic = [spList objectAtIndex:i];
        NSMutableDictionary *spDic = [NSMutableDictionary dictionary];
        NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[dic objectForKey:@"time"] doubleValue] withFormatStr:@"yyyyMMddHHmmss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [spDic setObject:date forKey:@"DATE"];
        [spDic setObject:[dic objectForKey:@"mode"] forKey:@"MODE"];
        [spDic setObject:[dic objectForKey:@"step"] forKey:@"STEP"];
        [spDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] ? [SMADefaultinfos getValueforKey:BANDDEVELIVE]:@"SM07" forKey:@"INDEX"];
        [spDic setObject:@"1" forKey:@"WEB"];
        [spDic setObject:[[spList objectAtIndex:i] objectForKey:@"account"] forKey:@"USERID"];
        [spArr addObject:spDic];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        SMADatabase *dal = [[SMADatabase alloc] init];
        [dal insertSportDataArr:spArr finish:^(id finish) {
            callBack(finish);
        }];
    });
}

+ (void)updateHRData:(NSMutableArray *)hrList finish:(void (^)(id finish)) callBack{
    NSMutableArray *hrArr = [NSMutableArray array];
    for (int i = 0; i < hrList.count; i ++) {
        NSDictionary *dic = [hrList objectAtIndex:i];
        NSMutableDictionary *hrDic = [NSMutableDictionary dictionary];
        NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[dic objectForKey:@"time"] doubleValue] withFormatStr:@"yyyyMMddHHmmss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [hrDic setObject:date forKey:@"DATE"];
        [hrDic setObject:[dic objectForKey:@"type"] forKey:@"HRMODE"];
        [hrDic setObject:[dic objectForKey:@"value"] forKey:@"HEART"];
        //        [hrDic setObject:@"0" forKey:@"HRMODE"];
        [hrDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] ? [SMADefaultinfos getValueforKey:BANDDEVELIVE]:@"SM07" forKey:@"INDEX"];
        [hrDic setObject:@"1" forKey:@"WEB"];
        [hrDic setObject:[[hrList objectAtIndex:i] objectForKey:@"account"] forKey:@"USERID"];
        [hrArr addObject:hrDic];
    }
    SMADatabase *dal = [[SMADatabase alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [dal insertHRDataArr:hrArr finish:^(id finish) {
            callBack(finish);
        }];
    });
}

+ (void)updateALData:(NSMutableArray *)alList finish:(void (^)(id finish)) callBack{
    SMADatabase *dal = [[SMADatabase alloc] init];
    [dal deleteAllClockCallback:^(BOOL result) {
        
    }];
    __block int saveAccount = 0;
    for (int i = 0; i < alList.count; i ++) {
        NSDictionary *dic = [alList objectAtIndex:i];
        NSString *dateStr = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[dic objectForKey:@"time"] doubleValue] withFormatStr:@"yyyyMMddHHmmss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
        info.dayFlags = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"repeat"] intValue]];
        info.minute = [dateStr substringWithRange:NSMakeRange(10, 2)];
        info.hour = [dateStr substringWithRange:NSMakeRange(8, 2)];
        info.day = [dateStr substringWithRange:NSMakeRange(6, 2)];
        info.mounth = [dateStr substringWithRange:NSMakeRange(4, 2)];
        info.year = [dateStr substringWithRange:NSMakeRange(0, 4)];
        info.tagname = [dic objectForKey:@"tag"];
        info.isOpen = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"isopen"] intValue]];
        info.isWeb = @"1";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [dal insertClockInfo:info account:[[alList objectAtIndex:i] objectForKey:@"account"] callback:^(BOOL result) {
                saveAccount ++;
                if (saveAccount == alList.count) {
                    callBack([NSString stringWithFormat:@"%d",result]);
                }
            }];
        });
    }
}
@end
