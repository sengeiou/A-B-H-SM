//
//  SMADatabase.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADatabase.h"
@implementation SMADatabase
- (FMDatabaseQueue *)createDataBase{
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SMAwatch.sqlite"];
    // 1.创建数据库队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    // 2.创表
    if(!_queue){
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result;
            
            result = [db executeUpdate:@"create table if not exists tb_clock (clock_id integer primary key autoincrement,user_id varchar(30),dayFlags text, aid text,timeInterval text,isopen integer,tagname text,clock_web integer);"];
            
            //运动数据
            result = [db executeUpdate:@"create table if not exists tb_CuffSport (id INTEGER PRIMARY KEY AUTOINCREMENT,user_id varchar(30), Cuff_id varchar(30), date varchar(30),time integer, step TEXT,ident TEXT,sp_mode integer,sp_web integer);"];
            
            //心率
            result = [db executeUpdate:@"create table if not exists tb_HRate ( _id INTEGER PRIMARY KEY ASC AUTOINCREMENT,user_id varchar(30),HR_id varchar(30),HR_date varchar(30), HR_time integer,HR_real integer,hr_mode integer,hr_quiet integer,HR_ident TEXT,HR_web integer);"];
            
            //静息心率
            result = [db executeUpdate:@"create table if not exists tb_Quiet ( _id INTEGER PRIMARY KEY ASC AUTOINCREMENT,user_id varchar(30),HR_id varchar(30),HR_date varchar(30), HR_time integer,HR_real integer,HR_web integer);"];
            
            //睡眠
            result = [db executeUpdate:@"create table if not exists tb_sleep ( id INTEGER PRIMARY KEY ASC AUTOINCREMENT ,user_id varchar(30),sleep_id varchar(30),sleep_date varchar(30),sleep_time integer,sleep_mode integer,softly_action integer,strong_action integer,sleep_ident TEXT,sleep_waer integer,sleep_web integer);"];
            NSLog(@"创表 %d",result);
        }];
    }
    return queue;
}

//懒加载
- (FMDatabaseQueue *)queue
{
    if(!_queue)
    {
        _queue= [self createDataBase];
    }
    return _queue;
}

//插入闹钟
- (void)insertClockInfo:(SmaAlarmInfo *)clockInfo callback:(void (^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        SmaAlarmInfo *info=clockInfo;
        BOOL result;
        NSString *date;
        if (info.aid) {
            date = [NSString stringWithFormat:@"%@%@%@%@%@00",info.year,info.mounth,info.day,info.hour,info.minute];
            NSTimeInterval timeInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:date timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set dayFlags='%@',aid=%d,timeInterval='%@',isopen=%d,tagname='%@',clock_web=%d where user_id=\'%@\' and clock_id=%d",info.dayFlags,[info.aid intValue],[NSString stringWithFormat:@"%f",timeInterval],[info.isOpen intValue],info.tagname,[info.isWeb intValue],[SMAAccountTool userInfo].userID,info.aid.intValue];
            result = [db executeUpdate:updatesql];
            NSLog(@"修改闹钟 == %d",result);
        }
        else{
            date = [NSString stringWithFormat:@"%@%@%@%@%@00",info.year,info.mounth,info.day,info.hour,info.minute];
            NSTimeInterval timeInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:date timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            result = [db executeUpdate:@"INSERT INTO tb_clock (user_id,dayFlags,aid,timeInterval,isopen,tagname,clock_web) VALUES (?,?,?,?,?,?,?);",[SMAAccountTool userInfo].userID,info.dayFlags,info.aid,[NSString stringWithFormat:@"%f",timeInterval],info.isOpen,info.tagname,info.isWeb];
            NSLog(@"插入闹钟 == %d",result);
        }
        [db commit];
        callBack (result);
    }];
}

//获取闹钟列表
-(NSMutableArray *)selectClockList
{
    NSMutableArray *arr=[NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        int limit = 8;
        NSString *sql=[NSString stringWithFormat:@"select * from tb_clock where user_id=\'%@\' order by clock_id DESC limit %d",[SMAAccountTool userInfo].userID,limit];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
            NSTimeInterval timeInterval = [[rs stringForColumn:@"timeInterval"] doubleValue];
            NSString *dateStr = [SMADateDaultionfos stringFormmsecIntervalSince1970:timeInterval timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            info.aid=[rs stringForColumn:@"clock_id"];
            info.dayFlags=[rs stringForColumn:@"dayFlags"];
            info.minute=[dateStr substringWithRange:NSMakeRange(10, 2)];
            info.hour=[dateStr substringWithRange:NSMakeRange(8, 2)];
            info.day=[dateStr substringWithRange:NSMakeRange(6, 2)];
            info.mounth=[dateStr substringWithRange:NSMakeRange(4, 2)];
            info.year=[dateStr substringWithRange:NSMakeRange(0, 4)];
            info.tagname=[rs stringForColumn:@"tagname"];
            info.isOpen=[rs stringForColumn:@"isopen"];
            [arr addObject:info];
        }
    }];
    return arr;
}

//删除闹钟
- (void)deleteClockInfo:(NSString *)clockId callback:(void (^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        NSString *updatesql=[NSString stringWithFormat:@"delete from tb_clock where clock_id=%d",[clockId intValue]];
        BOOL result = [db executeUpdate:updatesql];
        NSLog(@"删除 %d",result);
        [db commit];
        callBack(result);
    }];
}

//插入运动数据
- (void)insertSportDataArr:(NSMutableArray *)sportData finish:(void (^)(id finish)) success {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL result = false;
        for (int i = 0; i < sportData.count; i ++) {
            
            NSDictionary *spDic = (NSDictionary *)[sportData objectAtIndex:i];
            NSString *spID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[spDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]*1000];
            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:spID.doubleValue/1000 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date=\'%@\' and time=%d and user_id=\'%@\'",YTD,moment.intValue,[spDic objectForKey:@"USERID"]];
            NSString *sportStep;
            FMResultSet *rs = [db executeQuery:sql];
            while (rs.next) {
                sportStep = [rs stringForColumn:@"time"];
            }
            if (sportStep && ![sportStep isEqualToString:@""]) {
                result =   [db executeUpdate:@"update tb_CuffSport set Cuff_id=?, step=?, sp_mode=?, sp_web=? where Cuff_id=? and user_id=\'%@\'",spID,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"SPMODE"],[spDic objectForKey:@"WEB"],spID,[spDic objectForKey:@"USERID"]];
                NSLog(@"步数更新  %d  步数  %@  ",result,[spDic objectForKey:@"STEP"]);
            }
            else{
                result =   [db executeUpdate:@"insert into tb_CuffSport (user_id,Cuff_id,date,time,step,ident,sp_mode,sp_web) values(?,?,?,?,?,?,?,?)",[SMAAccountTool userInfo].userID,spID,YTD,moment,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"INDEX"],[spDic objectForKey:@"SPMODE"],[spDic objectForKey:@"WEB"]];
                NSLog(@"步数插入  %d  步数  %@  ",result,[spDic objectForKey:@"STEP"]);
            }
        }
        [db commit];
        success ([NSString stringWithFormat:@"%d",result]);
    }];
}

//获取运动数据
- (NSMutableArray *)readSportDataWithDate:(NSString *)date toDate:(NSString *)todate lastData:(BOOL)last{
    NSMutableArray *spArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        if (last) {
            NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date >=\'%@\' and date <=\'%@\' and user_id = \'%@\' group by date",date,todate,[SMAAccountTool userInfo].userID];
            FMResultSet *rs = [db executeQuery:sql];
            NSString *sportT;
            NSString *sportD;
            NSString *sportS;
            while (rs.next) {
                sportT = [rs stringForColumn:@"time"];
                sportD = [rs stringForColumn:@"date"];
                sportS = [rs stringForColumn:@"step"];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sportT,@"TIME",sportD,@"DATE",sportS,@"STEP", nil];
                [spArr addObject:dic];
            }
        }
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date >=\'%@\' and date <=\'%@\' and user_id = \'%@\' group by time",date,todate,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *spDetailArr = [NSMutableArray array];
        NSString *sportT;
        NSString *sportD;
        NSString *sportS;
        while (rs.next) {
            sportT = [rs stringForColumn:@"time"];
            sportD = [rs stringForColumn:@"date"];
            sportS = [rs stringForColumn:@"step"];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sportT,@"TIME",sportD,@"DATE",sportS,@"STEP", nil];
            [spDetailArr addObject:dic];
        }
        if (spDetailArr.count > 0) {
            [spArr addObject:spDetailArr];
        }
    }];
    return spArr;
}

- (NSString *)readFirstSportdata{
   __block NSString *sportD;
      [self.queue inDatabase:^(FMDatabase *db) {
    NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where user_id = \'%@\' order by id DESC limit 1",[SMAAccountTool userInfo].userID];
    FMResultSet *rs = [db executeQuery:sql];
          while (rs.next) {
            sportD = [rs stringForColumn:@"date"];
          }
    }];
    return sportD;
}

//插入睡眠数据
-(void)insertSleepDataArr:(NSMutableArray *)sleepData finish:(void (^)(id finish)) success
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL result = false;
        for (int i=0; i<sleepData.count; i++) {
            NSMutableDictionary *slDic=(NSMutableDictionary *)sleepData[i];
            NSString *spID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[slDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]*1000];
            NSString *date = [slDic objectForKey:@"DATE"];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *sql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time=%d and user_id=\'%@\'",YTD,moment.intValue,[slDic objectForKey:@"USERID"]];
            NSString *sleepTime;
            FMResultSet *rs = [db executeQuery:sql];
            while (rs.next) {
                sleepTime = [rs stringForColumn:@"sleep_id"];
            }
            if (sleepTime && ![sleepTime isEqualToString:@""]) {
                NSString *updatesql=[NSString stringWithFormat:@"update tb_sleep set sleep_id='%@', sleep_mode=%d,softly_action=%d,strong_action=%d,sleep_ident='%@',sleep_waer=%d,sleep_web=%d where sleep_id ='%@' and user_id=\'%@\';",spID,[[slDic objectForKey:@"MODE"] intValue],[[slDic objectForKey:@"SOFTLY"] intValue],[[slDic objectForKey:@"STRONG"] intValue],[slDic objectForKey:@"INDEX"],[[slDic objectForKey:@"WEAR"] intValue],[[slDic objectForKey:@"WEB"] intValue],sleepTime,[slDic objectForKey:@"USERID"]];
                result = [db executeUpdate:updatesql];
                NSLog(@"睡眠更新  %d",result);
            }
            else{
                result=  [db executeUpdate:@"INSERT INTO tb_sleep (user_id,sleep_id,sleep_date,sleep_time,sleep_mode,softly_action,strong_action,sleep_ident,sleep_waer,sleep_web) VALUES (?,?,?,?,?,?,?,?,?,?);",[slDic objectForKey:@"USERID"],spID,YTD,moment,[slDic objectForKey:@"MODE"],[slDic objectForKey:@"SOFTLY"],[slDic objectForKey:@"STRONG"],[slDic objectForKey:@"INDEX"],[slDic objectForKey:@"WEAR"],[slDic objectForKey:@"WEB"]];
                NSLog(@"插入睡眠数据 %d",result);
            }
            
        }
        [db commit];
        success ([NSString stringWithFormat:@"%d",result]);
    }];
}

//读取睡眠数据
- (NSMutableArray *)readSleepDataWithDate:(NSString *)date{
    NSLog(@"wefwefw000==%@ ",[date substringWithRange:NSMakeRange(4, 2)]);
    NSMutableArray *sleepData = [NSMutableArray array];
    NSDate *yestaday = [[NSDate dateWithYear:[[date substringToIndex:4] integerValue] month:[[date substringWithRange:NSMakeRange(4, 2)] integerValue] day:[[date substringWithRange:NSMakeRange(6, 2)] integerValue]] yesterday];
    [self.queue inDatabase:^(FMDatabase *db) {
        //寻找当天六点前入睡时间
        NSString *strDate;
        NSString *strTime;
        NSString *startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time <=360 and sleep_mode=17 and user_id=\'%@\' group by sleep_date",date,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:startSql];
        while (rs.next) {
            strDate = [rs stringForColumn:@"sleep_date"];
            strTime = [rs stringForColumn:@"sleep_time"];
        }
        if (!strDate || [strDate isEqualToString:@""]) {//寻找前一天十点后入睡时间
            startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=1080 and sleep_mode=17 and user_id=\'%@\' group by sleep_date",yestaday.yyyyMMddNoLineWithDate,[SMAAccountTool userInfo].userID];
            rs = [db executeQuery:startSql];
            while (rs.next) {
                strDate = [rs stringForColumn:@"sleep_date"];
                strTime = [rs stringForColumn:@"sleep_time"];
                if (strTime.intValue < 1320) {
                    strTime = @"1320";
                }
            }
        }
        if (strTime && ![strTime isEqualToString:@""]) {//保证有入睡时间
            NSDictionary *starDic = [NSDictionary dictionaryWithObjectsAndKeys:strDate,@"DATE",strTime,@"TIME",@"2",@"TYPE", nil];
            [sleepData addObject:starDic];
            //寻找当天本来时间（18点前）
            NSString *endDate;
            NSString *endTime;
            startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time <1080 and sleep_mode=34 and user_id=\'%@\' group by sleep_date",date,[SMAAccountTool userInfo].userID];
            rs = [db executeQuery:startSql];
            while (rs.next) {
                endDate = [rs stringForColumn:@"sleep_date"];
                endTime = [rs stringForColumn:@"sleep_time"];
                if (endTime.intValue > 600) {
                    endTime = @"600";
                }
            }
            if (!endDate || [endDate isEqualToString:@""]) {//寻找前一天十点后醒来时间
                startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >1320 and sleep_time >%d and sleep_mode=34 and user_id=\'%@\' group by sleep_date",yestaday.yyyyMMddNoLineWithDate,strTime.intValue,[SMAAccountTool userInfo].userID];
                rs = [db executeQuery:startSql];
                while (rs.next) {
                    endDate = [rs stringForColumn:@"sleep_date"];
                    endTime = [rs stringForColumn:@"sleep_time"];
//                    if (endTime.intValue > 600) {
//                        endTime = @"600";
//                    }
                }
            }
            if (!endDate || [endDate isEqualToString:@""]) {
                endTime = [SMADateDaultionfos minuteFormDate:[NSDate date].yyyyMMddHHmmSSNoLineWithDate];
                endDate = [NSDate date].yyyyMMddNoLineWithDate;
                if (endTime.intValue > 600) {
                    endTime = @"600";
                }
            }
            
            if (endTime.intValue >= 1320) {//醒来时间为前一天晚上十点后数据
                startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=%d and sleep_time <=%d and user_id=\'%@\' and sleep_mode < 15 group by sleep_time",yestaday.yyyyMMddNoLineWithDate,strTime.intValue,endTime.intValue,[SMAAccountTool userInfo].userID];
                rs = [db executeQuery:startSql];
                while (rs.next) {
                    NSString *date = [rs stringForColumn:@"sleep_date"];
                    NSString *sleepType;
                    int sleep_type;
                    if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                        if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                            NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                            NSString *type = @"3";
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                            [sleepData addObject:dic];
                            sleep_type = 2;
                        }
                        else{
                            if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
                                NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                NSString *type = @"2";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 1;
                            }
                            else{
                                sleep_type = 1;
                            }
                        }
                        sleepType = [NSString stringWithFormat:@"%d",sleep_type];
                    }
                    else{
                        sleepType = [rs stringForColumn:@"sleep_mode"];
                    }
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",[rs stringForColumn:@"sleep_time"],@"TIME",sleepType,@"TYPE", nil];
                    [sleepData addObject:dic];
                }
                NSDictionary *endDic = [NSDictionary dictionaryWithObjectsAndKeys:endDate,@"DATE",endTime,@"TIME",@"3",@"TYPE", nil];
                [sleepData addObject:endDic];
            }
            else{//醒来为当天十点前
                if (strTime.intValue >= 1320) {//获取二十二点后睡眠数据
                    startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=%d and sleep_time <=1440 and user_id=\'%@\' and sleep_mode < 15 group by sleep_time",yestaday.yyyyMMddNoLineWithDate,strTime.intValue,[SMAAccountTool userInfo].userID];
                    rs = [db executeQuery:startSql];
                    while (rs.next) {
                        NSString *date = [rs stringForColumn:@"sleep_date"];
                        NSString *sleepType;
                        int sleep_type;
                        if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                            if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                                NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                NSString *type = @"3";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 2;
                            }
                            else{
                                if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
                                    NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                    NSString *type = @"2";
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                    [sleepData addObject:dic];
                                    sleep_type = 1;
                                }
                                else{
                                    sleep_type = 1;
                                }
                            }
                            sleepType = [NSString stringWithFormat:@"%d",sleep_type];
                        }
                        else{
                            sleepType = [rs stringForColumn:@"sleep_mode"];
                        }
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",[rs stringForColumn:@"sleep_time"],@"TIME",sleepType,@"TYPE", nil];
                        [sleepData addObject:dic];
                    }
                    //获取当天十点前睡眠数据
                    startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=0 and sleep_time <=%d and user_id=\'%@\' and sleep_mode < 15 group by sleep_time",date,endTime.intValue,[SMAAccountTool userInfo].userID];
                    rs = [db executeQuery:startSql];
                    while (rs.next) {
                        NSString *date = [rs stringForColumn:@"sleep_date"];
                        NSString *sleepType;
                        int sleep_type;
                        if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                            if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                                NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                NSString *type = @"3";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 2;
                            }
                            else{
                                if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
                                    NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                    NSString *type = @"2";
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                    [sleepData addObject:dic];
                                    sleep_type = 1;
                                }
                                else{
                                    sleep_type = 1;
                                }
                            }
                            sleepType = [NSString stringWithFormat:@"%d",sleep_type];
                        }
                        else{
                            sleepType = [rs stringForColumn:@"sleep_mode"];
                        }
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",[rs stringForColumn:@"sleep_time"],@"TIME",sleepType,@"TYPE", nil];
                        [sleepData addObject:dic];
                    }
                }
                else{//入睡时间为当天，十点前睡眠数据
                    startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=%d and sleep_time <=%d and user_id=\'%@\' and sleep_mode < 15 group by sleep_time",date,strTime.intValue,endTime.intValue,[SMAAccountTool userInfo].userID];
                    rs = [db executeQuery:startSql];
                    while (rs.next) {
                        NSString *date = [rs stringForColumn:@"sleep_date"];
                        NSString *sleepType;
                        int sleep_type;
                        if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                            if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                                NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                NSString *type = @"3";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 2;
                            }
                            else{
                                if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
//                                    NSLog(@"thetime = %@",[rs stringForColumn:@"sleep_time"]);
                                    NSString *time = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue - 15];
                                    NSString *type = @"2";
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                    [sleepData addObject:dic];
                                    sleep_type = 1;
                                }
                                else{
                                    sleep_type = 1;
                                }
                            }
                            sleepType = [NSString stringWithFormat:@"%d",sleep_type];
                        }
                        else{
                            sleepType = [rs stringForColumn:@"sleep_mode"];
                        }
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",[rs stringForColumn:@"sleep_time"],@"TIME",sleepType,@"TYPE", nil];
                        [sleepData addObject:dic];
                    }
                }
                NSDictionary *endDic = [NSDictionary dictionaryWithObjectsAndKeys:endDate,@"DATE",endTime,@"TIME",@"3",@"TYPE", nil];
                [sleepData addObject:endDic];
            }
        }
    }];
    return sleepData;
}

//插入心率数据
- (void)insertHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (int i = 0; i < HRarr.count; i ++) {
            NSMutableDictionary *hrDic=(NSMutableDictionary *)HRarr[i];
            NSString *hrID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[hrDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]*1000];
            NSString *date = [hrDic objectForKey:@"DATE"];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *quiet;
            NSString *HR_id;
            FMResultSet *rs = [db executeQuery:@"select * from tb_HRate where HR_date =? and HR_time=? and user_id=?",YTD,moment,[hrDic objectForKey:@"USERID"]];
            while ([rs next]) {
                quiet = [rs stringForColumn:@"hr_quiet"];
                HR_id = [rs stringForColumn:@"HR_id"];
            }
            if (quiet && ![quiet isEqualToString:@""] && [quiet isEqualToString:[hrDic objectForKey:@"QUIET"]]) {
                BOOL result = [db executeUpdate:@"update tb_HRate set HR_id=?, HR_real=?,hr_mode=?,hr_quiet=?,HR_web=? where HR_id=? and user_id",hrID,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"QUIET"],[hrDic objectForKey:@"WEB"],HR_id,[hrDic objectForKey:@"USERID"]];
                NSLog(@"更新心率数据 %d  %@",result,HRarr);
            }
            else{
                BOOL result = [db executeUpdate:@"insert into tb_HRate(user_id,HR_id,HR_date,HR_time,HR_real,hr_mode,hr_quiet,HR_ident,HR_web) values(?,?,?,?,?,?,?,?,?)",[hrDic objectForKey:@"USERID"],hrID,YTD,moment,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"QUIET"],[hrDic objectForKey:@"INDEX"],[hrDic objectForKey:@"WEB"]];
                NSLog(@"插入心率数据 %d",result);
            }
        }
        [db commit];
    }];
}

//读取心率数据
- (NSMutableArray *)readHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart =nil;
        if (!detail) {
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_quiet=0 and user_id=? group by HR_date",date,toDate,[SMAAccountTool userInfo].userID];
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *date = [rsChart stringForColumn:@"HR_date"];
                NSString *time = [rsChart stringForColumn:@"HR_time"];
                NSString *HR_real = [rsChart stringForColumn:@"HR_real"];
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"DATE",time,@"TIME",HR_real,@"REAT", nil];
                [hrArr addObject:dict];
            }
            
            rsChart = [db executeQuery:@"select max(HR_real) as maxHR,min(HR_real) as minHR,avg(HR_real) as avgHR from tb_HRate where HR_date>=? and HR_date<=? and hr_quiet=0 and user_id=? group by HR_date",date,toDate,[SMAAccountTool userInfo].userID];
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *max = [rsChart stringForColumn:@"maxHR"];
                NSString *min = [rsChart stringForColumn:@"minHR"];
                NSString *avg = [rsChart stringForColumn:@"avgHR"];
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:max,@"maxHR",min,@"minHR",avg,@"avgHR", nil];
                [hrArr addObject:dict];
            }
        }
        else{
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_quiet=0 and user_id=? group by HR_time",date,toDate,[SMAAccountTool userInfo].userID];
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *date = [rsChart stringForColumn:@"HR_date"];
                NSString *time = [rsChart stringForColumn:@"HR_time"];
                NSString *HR_real = [rsChart stringForColumn:@"HR_real"];
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"DATE",time,@"TIME",HR_real,@"REAT", nil];
                [hrArr addObject:dict];
            }
        }
    }];
    return hrArr;
}

//读取静息心率数据
- (NSMutableArray *)readQuietHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart =nil;
        if (!detail) {
            rsChart = [db executeQuery:@"select max(HR_real) as maxHR,min(HR_real) as minHR,avg(HR_real) as avgHR from tb_HRate where HR_date>=? and HR_date<=? and hr_quiet=1 and user_id=?",date,toDate,[SMAAccountTool userInfo].userID];
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *max = [rsChart stringForColumn:@"maxHR"]?[rsChart stringForColumn:@"maxHR"]:@"0";
                NSString *min = [rsChart stringForColumn:@"minHR"]?[rsChart stringForColumn:@"minHR"]:@"0";
                NSString *avg = [rsChart stringForColumn:@"avgHR"]?[rsChart stringForColumn:@"avgHR"]:@"0";
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:max,@"maxHR",min,@"minHR",avg,@"avgHR", nil];
                [hrArr addObject:dict];
            }
        }
        else{
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_quiet=1 and user_id=? group by HR_time",date,toDate,[SMAAccountTool userInfo].userID];
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *date = [rsChart stringForColumn:@"HR_date"];
                NSString *time = [rsChart stringForColumn:@"HR_time"];
                NSString *HR_real = [rsChart stringForColumn:@"HR_real"];
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"DATE",time,@"TIME",HR_real,@"HEART", nil];
                [hrArr addObject:dict];
            }
        }
    }];
    return hrArr;
}

//删除指定静息心率数据
- (void)deleteQuietHearReatDataWithDate:(NSString *)date time:(NSString *)time{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        NSString *updatesql=[NSString stringWithFormat:@"delete from tb_HRate where HR_date=\'%@\' and HR_time =%d and user_id=\'%@\' and hr_quiet=1",date,time.intValue,[SMAAccountTool userInfo].userID];
        BOOL result = [db executeUpdate:updatesql];
        NSLog(@"删除 %d",result);
        [db commit];
    }];
}
@end
