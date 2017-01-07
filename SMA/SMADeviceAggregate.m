//
//  SMADeviceAggregate.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADeviceAggregate.h"

@interface SMADeviceAggregate ()
@property (nonatomic, assign) BOOL aggregate;
@property (nonatomic, strong) NSDate *aggWeekDate;
@property (nonatomic, strong) NSDate *aggMonthDate;
@property (nonatomic, strong) SMADatabase *dal;
@end


@implementation SMADeviceAggregate
// 用来保存唯一的单例对象
static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)deviceAggregateTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
//        [_instace initilizeWithWeek];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)initilizeWithWeek
{
    _aggWeekDate = [[NSDate date] timeDifferenceWithNumbers:28];//由于当天位于视图中央，因此获取数据应从当天的下一周开始
    NSDate *lastdate = [NSDate date];
    for (int i = 0; i < 4; i ++ ) {
        NSDate *nextDate = lastdate;
        lastdate = [nextDate dayOfMonthToDateIndex:32];
        lastdate = [lastdate timeDifferenceWithNumbers:1];
        if (i == 3) {
            _aggMonthDate = lastdate; //由于当天位于视图中央，因此获取数据应从当天的四个月之后开始
        }
    }
    if (self.aggregateTimer) {
        [self.aggregateTimer invalidate];
        self.aggregateTimer = nil;
    }
    _aggregateSlWeekData = [NSMutableArray array];
    _aggregateSpWeekData = [NSMutableArray array];
    _aggregateSpMonthData = [NSMutableArray array];
    _aggregate = YES;
    self.aggregateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(aggregateWeekData) userInfo:nil repeats:YES];
}

- (void)stopLoading{
   [self.aggregateTimer setFireDate:[NSDate distantFuture]];
}
- (void)startLoading{
   [self.aggregateTimer setFireDate:[NSDate date]];
}

- (void)aggregateWeekData{
//        NSLog(@"W23FGT2T-T35Y54Y45***********************");
    if (_aggregate) {
        _aggregate = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            //            [formate setDateFormat:@"yyyyMMdd"];
            //            NSDate *date= [formate dateFromString:@"20000108"];
            _aggWeekDate = [_aggWeekDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            NSMutableArray *SLlDataArr = [self getSleepWeekDetalilDataWithNowDate:_aggWeekDate month:NO];
            NSMutableArray *SPlDataArr = [self getSPDetalilDataWithNowDate:_aggWeekDate month:NO];
            _aggWeekDate = [_aggWeekDate timeDifferenceWithNumbers:-28];
            [_aggregateSlWeekData insertObject:SLlDataArr atIndex:0];
            [_aggregateSpWeekData insertObject:SPlDataArr atIndex:0];
            
            NSMutableArray *SPmDataArr = [self getSPDetalilDataWithNowDate:_aggMonthDate month:YES];
            NSDate *firstdate = _aggMonthDate;
            for (int i = 0; i < 4; i ++ ) {
                NSDate *nextDate = firstdate;
                firstdate = [nextDate dayOfMonthToDateIndex:0];
                firstdate = firstdate.yesterday;
                if (i == 3) {
                    _aggMonthDate = firstdate; //由于当天位于视图中央，因此获取数据应从当天的四个月之后开始
                }
            }
            [_aggregateSpMonthData insertObject:SPmDataArr atIndex:0];
            _aggregate= YES;
            if (_aggregateSlWeekData.count > 200) {
                [self.aggregateTimer invalidate];
                self.aggregateTimer = nil;
            }
//            NSLog(@"W23FGT2T-T35Y54Y4++++++++++++++++++++++ %d",_aggregateSlWeekData.count);
        });
    }
}

- (id)getSPDatasModeContinueForOneDay:(NSMutableArray *)spDatas{
    NSMutableArray *detailArr = [NSMutableArray array];
    int sitAmount=0;//静坐时长
    int walkAmount=0;//步行时长
    int runAmount=0;//跑步时长
    NSString * prevMode;//上一类型
    NSString *prevTime;//上一时间点
    int atTypeTime = 0;//相同状态下起始时间
    int prevTypeTime=0;//运动状态下持续时长
    /* 	16-17 静坐开始到步行开始---静坐时间
     *  16-18 静坐开始到跑步开始---静坐时间
     *  17-16 步行开始到静坐开始---步行时间
     *  17-18 步行开始到跑步开始---步行时间
     *  18-16 跑步开始到静坐开始---跑步时间
     *  18-17 跑步开始到步行开始---跑步时间
     */
    if (spDatas.count > 0) {
        NSMutableArray *detail = spDatas;
        for (int i = 0; i < detail.count; i ++) {
            NSDictionary *dic = detail[i];
            NSString *atTime = dic[@"TIME"];
            NSString *atMode = dic[@"MODE"];
            int amount = atTime.intValue - prevTime.intValue;
            if (i == 0) {
                amount = 0;
            }
            else{
                if (atMode.intValue != 0) {
                    if (prevMode.intValue == 16) {
                        sitAmount = sitAmount + amount;
                    }
                    else if (prevMode.intValue == 17){
                        walkAmount = walkAmount + amount;
                    }
                    else if (prevMode.intValue == 18){
                        runAmount = runAmount + amount;
                    }
                    if (prevMode) {
                        if (prevMode.intValue == atMode.intValue) {
                            if (prevTypeTime == 0) {
                                atTypeTime = prevTime.intValue;
                            }
                            prevTypeTime = prevTypeTime + amount;
                            if (i == detail.count - 1) {
                                //                        prevTypeTime = prevTypeTime + amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                        }
                        else{
                            if (prevTypeTime != 0) {
                                prevTypeTime = prevTypeTime + amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                            else{
                                prevTypeTime =  amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime.intValue]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                        }
                        if (![prevMode isEqualToString:atMode]) {
                            prevTypeTime = 0;
                        }
                    }
                    prevMode = dic[@"MODE"];
                    prevTime = dic[@"TIME"] ;
                }
            }
        }
    }
  /*********************************补全一天数据（24条）
//    NSMutableArray *fullDatas = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 24; i ++) {
//        BOOL found = NO;
//        int time = -1 ;
//        if (spDatas.count > 0) {
//            for (NSDictionary *dic in [spDatas lastObject]) {
//                if ([[dic objectForKey:@"TIME"] intValue]/60 == i) {
//                    if (time == i) {
//                        [fullDatas removeLastObject];
//                    }
//                    time = i;
//                    [fullDatas addObject:dic];
//                    found = YES;
//                }
//                else{
//                    if (!found) {
//                        if (time == i) {
//                            [fullDatas removeLastObject];
//                        }
//                        time = i;
//                        [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[[spDatas lastObject] lastObject] objectForKey:@"DATE"],@"DATE", nil]];
//                    }
//                }
//            }
//        }
//        else{
//            [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[[spDatas lastObject] lastObject] objectForKey:@"DATE"],@"DATE", nil]];
//        }
//    }
//    
//    NSMutableArray *xText = [NSMutableArray array];
//    NSMutableArray *yValue = [NSMutableArray array];
//    NSMutableArray *yBaesValues = [NSMutableArray array];
//    for (int i = 0; i < 24; i ++) {
//        if (i == 0 || i == 12 || i == 23) {
//            [xText addObject:[NSString stringWithFormat:@"%@%d:00",i<10?@"":@"",i]];
//        }
//        else{
//            [xText addObject:@""];
//        }
//    }
//    for (int i = 0; i < 25; i ++) {
//        if (i == 0) {
//            [yValue addObject:@"0"];
//        }
//        else if(i == 25){
//            [yValue addObject:[NSString stringWithFormat:@"%d",[[yValue valueForKeyPath:@"@max.intValue"] intValue] + 10]];
//        }
//        else{
//            NSDictionary *dic = [fullDatas objectAtIndex:i-1];
//            [yValue addObject:[dic objectForKey:@"STEP"]];
//        }
//        [yBaesValues addObject:@"0"];
//    }
//    [dayAlldata addObject:xText];       //图像底部坐标
//    [dayAlldata addObject:yBaesValues]; //图像底部起始点（柱状图）
//    [dayAlldata addObject:yValue];      //图像每个轴高度
   *************************************************************/
    NSDictionary *modeDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:sitAmount],@"SIT",[NSNumber numberWithInt:walkAmount],@"WALK",[NSNumber numberWithInt:runAmount],@"RUN", nil];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    [dayAlldata addObject:modeDic];
    [dayAlldata addObject:detailArr];   //运动数据详情（用于显示cell）
    return dayAlldata;
}

- (NSMutableArray *)getSPDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month{
    NSDate *firstdate = date;
    NSMutableArray *weekDate = [NSMutableArray array];
    NSMutableArray *modeDate = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        NSDate *lastdate;
        int step = 0;
        int dataNum = 0;
        int sitTimeNum = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
            NSUInteger monthNum = [firstdate numberOfDaysInMonth];
                for (int j = 0; j < monthNum; j ++) {
                    NSDate *detailDate = [firstdate timeDifferenceWithNumbers:j];
                    NSMutableArray *detailArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:detailDate.yyyyMMddNoLineWithDate toDate:detailDate.yyyyMMddNoLineWithDate]];
                    sitTimeNum = sitTimeNum + [[[detailArr firstObject] objectForKey:@"SIT"] intValue];
                    if (j == monthNum - 1) {
                        [modeDate addObject:[NSNumber numberWithInt:sitTimeNum]];
                    }
                }
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            lastdate = [nextDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            for (int j = 0; j < 7; j ++) {
                NSDate *detailDate = [firstdate timeDifferenceWithNumbers:j];
                NSMutableArray *detailArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:detailDate.yyyyMMddNoLineWithDate toDate:detailDate.yyyyMMddNoLineWithDate]];
                sitTimeNum = sitTimeNum + [[[detailArr firstObject] objectForKey:@"SIT"] intValue];
                if (j == 6) {
                    [modeDate addObject:[NSNumber numberWithInt:sitTimeNum]];
                }
            }
        }
        NSMutableArray *weekData = [self.dal readSportDataWithDate:firstdate.yyyyMMddNoLineWithDate toDate:nextDate.yyyyMMddNoLineWithDate];
        //        NSString * prevMode;//上一类型
        //        NSString *prevTime;//上一时间点
        //        int atTypeTime = 0;//相同状态下起始时间
        //        int prevTypeTime=0;//运动状态下持续时长
        if (weekData.count > 0) {
            for (int i = 0; i < (int)weekData.count; i ++) {
                dataNum ++;
                step = [[weekData[i] objectForKey:@"STEP"] intValue] + step;
                if (i == weekData.count - 1) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step/dataNum],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],lastdate ? [SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"] : @""],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
                    [weekDate addObject:dic];
                }
            }
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],lastdate?[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"] : @""],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
            [weekDate addObject:dic];
        }
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *alldataArr = [NSMutableArray array];
    NSMutableArray *numArr = [NSMutableArray array];
    NSMutableArray *modeArr = [NSMutableArray array];
    int showDataIndex = 0;
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
            [numArr addObject:@"0"];
            [modeArr addObject:[NSNumber numberWithInt:0]];
        }
        else{
            [xText addObject:month?[self getMonthText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]:[self getWeekText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"]];
            if ([[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"] intValue] > 0) {
                showDataIndex = i;
            }
            [numArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"NUM"]];
            [modeArr addObject:[modeDate objectAtIndex:4 - i]];
        }
    }
    [alldataArr addObject:xText];        //图像底部坐标
    [alldataArr addObject:yBaesValues];  //图像底部起始点（柱状图）
    [alldataArr addObject:yValue];       //图像每个轴高度
    [alldataArr addObject:numArr];       //图像所包含数据量（含多少天数据，用于计算平均值）
    [alldataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)(showDataIndex == 0 ? 4 : showDataIndex)]];  //图像（周）最后一第含有数据的项（若没有，默认为最后一项）
    [alldataArr addObject:modeArr];
    showDataIndex = 0;
    return alldataArr;
}

- (NSMutableArray *)getSleepWeekDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month{
    NSDate *firstdate = date;
    NSMutableArray *weekDataArr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        NSDate *lastdate;
        int sleepHourSum = 0;
        int deepSleepAmountSum = 0;
        int simpleSleepAmountSum = 0;
        int soberAmountSum = 0;
        int account = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            lastdate = [nextDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        for (int j = 0; j < 7; j ++) {
            
            NSMutableArray *weekData =  [self screeningSleepNowData:[self.dal readSleepDataWithDate:[firstdate timeDifferenceWithNumbers:j].yyyyMMddNoLineWithDate]];
            if ([[[weekData lastObject] objectAtIndex:0] intValue] != 0) {
                account ++;
                sleepHourSum = [[[weekData lastObject] objectAtIndex:0] intValue] + sleepHourSum;
                deepSleepAmountSum = [[[weekData lastObject] objectAtIndex:1] intValue] + deepSleepAmountSum;
                simpleSleepAmountSum = [[[weekData lastObject] objectAtIndex:2] intValue] + simpleSleepAmountSum;
                soberAmountSum = [[[weekData lastObject] objectAtIndex:3] intValue] + soberAmountSum;
            }
            if (j == 6) {
                NSString *date;
                if ([firstdate.yyyyMMddNoLineWithDate isEqualToString:[[NSDate date] firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSString class]]]) {
                    date = SMALocalizedString(@"device_SL_thisWeek");
                }
                else{
                    date = [NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]];
                }
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",sleepHourSum/account],@"sleepHour",[NSString stringWithFormat:@"%d",deepSleepAmountSum/account],@"deepSleep",[NSString stringWithFormat:@"%d",simpleSleepAmountSum/account],@"simpleSleep",[NSString stringWithFormat:@"%d",soberAmountSum/account],@"soberSleep",date,@"DATE",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
                [weekDataArr addObject:dic];
            }
            
        }
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *alldataArr = [NSMutableArray array];
    int showDataIndex = 0;
    NSMutableArray * dataArr = [[[weekDataArr reverseObjectEnumerator] allObjects] mutableCopy];
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
        }
        else{
            [xText addObject:[self getWeekText:[[weekDataArr objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDataArr objectAtIndex:4 - i] objectForKey:@"YEAR"]]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDataArr objectAtIndex:4 - i] objectForKey:@"sleepHour"]];
            if ([[[weekDataArr objectAtIndex:4 - i] objectForKey:@"sleepHour"] intValue]) {
                showDataIndex = i;
            }
        }
    }
    [alldataArr addObject:xText];
    [alldataArr addObject:yBaesValues];
    [alldataArr addObject:yValue];
    [alldataArr addObject:dataArr];
    [alldataArr addObject:[NSString stringWithFormat:@"%d",showDataIndex == 0 ? 4 : showDataIndex]];  //图像（周）最后一第含有数据的项（若没有，默认为最后一项）
    showDataIndex = 0;
    return alldataArr;
}

- (NSMutableArray *)screeningSleepNowData:(NSMutableArray *)sleepData{
    NSArray * arr = [sleepData sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        if ([obj1[@"TIME"] intValue]<[obj2[@"TIME"] intValue]) {
            return NSOrderedAscending;
        }
        
        else if ([obj1[@"TIME"] intValue]==[obj2[@"TIME"] intValue])
            
            return NSOrderedSame;
        
        else
            
            return NSOrderedDescending;
        
    }];

    NSMutableArray *sortArr = [arr mutableCopy];
    if (sortArr.count > 2) {//筛选同一状态数据
        for (int i = 0; i< sortArr.count-1; i++) {
            NSDictionary *obj1 = [sortArr objectAtIndex:i];
            NSDictionary *obj2 = [sortArr objectAtIndex:i+1];
            if ([obj1[@"TYPE"] intValue] == [obj2[@"TYPE"] intValue]) {
                [sortArr removeObjectAtIndex:i+1];
                i--;
            }
        }
    }
    
    if (sortArr.count > 2) {//筛选同一时间数据
        for (int i = 0; i< sortArr.count-1; i++) {
            NSDictionary *obj1 = [sortArr objectAtIndex:i];
            NSDictionary *obj2 = [sortArr objectAtIndex:i+1];
            if ([obj1[@"TIME"] intValue] == [obj2[@"TIME"] intValue]) {
                [sortArr removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    int soberAmount=0;//清醒时间
    int simpleSleepAmount=0;//浅睡眠时长
    int deepSleepAmount=0;//深睡时长
    int prevType=2;//上一类型
    int prevTime=0;//上一时间点
    int atTypeTime = 0;//相同状态下起始时间
    int prevTypeTime=0;//睡眠状态下持续时长
    /* 	1-3深睡到未睡---深睡时间
     *   2-1清醒到深睡---浅睡时间
     *   2-3清醒到未睡---浅睡时间
     *   3-2未睡到清醒---清醒时间
     */
    NSMutableArray *detailDataArr = [NSMutableArray array];
    NSMutableArray *detailSLArr = [NSMutableArray array];
    NSMutableArray *alldataArr = [NSMutableArray array];
    for (int i = 0; i < sortArr.count; i ++) {
        NSDictionary *dic = sortArr[i];
        int atTime= [dic[@"TIME"] intValue];
        int atType = [dic[@"TYPE"] intValue];
        int amount=atTime-prevTime;
        if (i == 0) {
            amount = 0;
        }
        if (prevType == 2) {
            simpleSleepAmount = simpleSleepAmount + amount;
        }
        else if (prevType == 1){
            deepSleepAmount = deepSleepAmount + amount;
        }
        else{
            soberAmount = soberAmount + amount;
        }
        if (i == 0) {
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"device_SL_fallTime")}];
        }
        else if (i == sortArr.count - 1){
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"device_SL_wakeTime")}];
        }
        else{
            [detailSLArr addObject:@{@"TIME":[NSString stringWithFormat:@"%d",prevTime<600?(prevTime+120):(prevTime - 1320)],@"QUALITY":[NSString stringWithFormat:@"%d",prevType],@"SLEEPTIME":[NSString stringWithFormat:@"%d",amount]}];
            //筛选相同睡眠状态数据整合成一条
            if (prevType == atType) {
                if (prevTypeTime == 0) {
                    atTypeTime = prevTime;
                }
                prevTypeTime = prevTypeTime + amount;
            }
            else{
                if (prevTypeTime != 0) {
                    prevTypeTime = prevTypeTime + amount;
                    [detailDataArr addObject:@{@"TIME":[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:dic[@"TIME"]]],@"TYPE":[self sleepType:prevType],@"LAST":[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",prevTypeTime/60],@"h",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"] fontArr:@[FontGothamLight(19),FontGothamLight(15)]]}];
                    prevTypeTime = 0;
                }
                else{
                    prevTypeTime =  amount;
                    [detailDataArr addObject:@{@"TIME":[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime]],[self getHourAndMin:dic[@"TIME"]]],@"TYPE":[self sleepType:prevType],@"LAST":[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",prevTypeTime/60],@"h",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"] fontArr:@[FontGothamLight(19),FontGothamLight(15)]]}];
                    prevTypeTime = 0;
                }
            }
            if (prevType != atType) {
                prevTypeTime = 0;
            }
        }
        prevType = [dic[@"TYPE"] intValue];
        prevTime = [dic[@"TIME"] intValue];
    }
    NSArray *orderArr = [[[detailDataArr reverseObjectEnumerator] allObjects] mutableCopy];
    
    int sleepHour = soberAmount + simpleSleepAmount + deepSleepAmount;
    NSMutableArray *sleep = [NSMutableArray array];
    [sleep addObject:[NSString stringWithFormat:@"%d",sleepHour]];
    [sleep addObject:[NSString stringWithFormat:@"%d",deepSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",simpleSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",soberAmount]];
    [alldataArr addObject:detailSLArr];
    [alldataArr addObject:orderArr];
    [alldataArr addObject:sleep];
    return alldataArr;
}

- (NSString *)getHourAndMin:(NSString *)time{
    if (time.intValue > 1440) {
        time = [NSString stringWithFormat:@"%d",time.intValue - 1440];
    }
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr fontArr:(NSArray *)fontArr{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:fontArr[0]};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:fontArr[1]};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}

- (NSString *)sportMode:(int)mode{
    NSString *modeStr;
    switch (mode) {
        case 16:
            modeStr = SMALocalizedString(@"device_SP_sit");
            break;
        case 17:
            modeStr = SMALocalizedString(@"device_SP_walking");
            break;
        default:
            modeStr = SMALocalizedString(@"device_SP_running");
            break;
    }
    return modeStr;
}

- (NSString *)sleepType:(int)type{
    NSString *typeStr;
    switch (type) {
        case 1:
            typeStr = SMALocalizedString(@"device_SL_deep");
            break;
        case 2:
            typeStr = SMALocalizedString(@"device_SL_light");
            break;
        default:
            typeStr = SMALocalizedString(@"device_SL_awake");
            break;
    }
    return typeStr;
}

- (NSMutableAttributedString *)sleepTimeWithFall:(NSString *)fall wakeUp:(NSString *)wake{
    int fallTime = [[[fall componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[fall componentsSeparatedByString:@":"] lastObject] intValue];
    int wakeTime = [[[wake componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[wake componentsSeparatedByString:@":"] lastObject] intValue];
    int sleepTime = wakeTime - fallTime;
    return [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",sleepTime/60],@"h",[NSString stringWithFormat:@"%d",sleepTime%60],@"m"] fontArr:@[FontGothamLight(20),FontGothamLight(15)]];
}

- (NSString *)getWeekText:(NSString *)str year:(NSString *)year{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *weekArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    NSArray *weekArr1 = [[dayArr lastObject] componentsSeparatedByString:@"."];
    NSString *weekStr;
    weekStr = str;
//    if ([[weekArr firstObject] intValue] == 12 && [[weekArr1 firstObject] intValue] == 1) {
//        weekStr = [NSString stringWithFormat:@"%@ %@ - %@ %@",year,[dayArr firstObject],[NSString stringWithFormat:@"%d",year.intValue + 1],[dayArr lastObject]];
//    }
    weekStr = [NSString stringWithFormat:@"%@ %@ - %@",year,[dayArr firstObject],[dayArr lastObject]];
    //本周第一天
    NSString *nowFirstDate = [[NSDate date] firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSString class]];
    NSString *monDayStr = [SMADateDaultionfos monAndDateStringFormDateStr:nowFirstDate format:@"yyyyMMdd"];
    if ([[dayArr firstObject] isEqualToString:monDayStr] ||
        [[dayArr firstObject] isEqualToString:SMALocalizedString(@"device_SL_thisWeek")]) {
        weekStr = SMALocalizedString(@"device_SL_thisWeek");
    }
    return weekStr;
}

- (NSString *)getMonthText:(NSString *)str year:(NSString *)year{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *monArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    NSString *monStr;
//    monStr = [NSString stringWithFormat:@"%@%@",[monArr firstObject],SMALocalizedString(@"device_SP_month")];
//    if ([[monArr firstObject] intValue] == 1) {
        monStr = [NSString stringWithFormat:@"%@ %@",year,SMALocalizedString([NSString stringWithFormat:@"month%d",[[monArr firstObject] intValue]])];
//    }
    if ([[monArr firstObject] intValue] == [[[[NSDate date] yyyyMMddNoLineWithDate] substringWithRange:NSMakeRange(4, 2)] intValue] && [year isEqualToString:[[[NSDate date] yyyyMMddNoLineWithDate] substringToIndex:4]]) {
        monStr = SMALocalizedString(@"device_SL_thisMonth");
    }
    return monStr;
}

@end
