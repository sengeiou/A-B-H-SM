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
            
            result = [db executeUpdate:@"create table if not exists tb_clock (clock_id integer primary key autoincrement,user_id varchar(50),dayFlags text, aid text,timeInterval text,isopen integer,tagname text,clock_web integer);"];
            
            //运动数据
            result = [db executeUpdate:@"create table if not exists tb_CuffSport (id INTEGER PRIMARY KEY AUTOINCREMENT,user_id varchar(50), Cuff_id varchar(30), date varchar(30),time integer, step TEXT,ident TEXT,sp_mode integer,sp_web integer);"];
            
            //心率
            result = [db executeUpdate:@"create table if not exists tb_HRate ( _id INTEGER PRIMARY KEY ASC AUTOINCREMENT,user_id varchar(50),HR_id varchar(30),HR_date varchar(30), HR_time integer,HR_real integer,hr_mode integer,HR_ident TEXT,HR_web integer);"];
            
            //静息心率
            result = [db executeUpdate:@"create table if not exists tb_Quiet ( _id INTEGER PRIMARY KEY ASC AUTOINCREMENT,user_id varchar(50),HR_id varchar(30),HR_date varchar(30), HR_time integer,HR_real integer,HR_web integer);"];
            
            //睡眠
            result = [db executeUpdate:@"create table if not exists tb_sleep ( id INTEGER PRIMARY KEY ASC AUTOINCREMENT ,user_id varchar(50),sleep_id varchar(30),sleep_date varchar(30),sleep_time integer,sleep_mode integer,softly_action integer,strong_action integer,sleep_ident TEXT,sleep_waer integer,sleep_web integer);"];
//            NSLog(@"创表 %d",result);
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
- (void)insertClockInfo:(SmaAlarmInfo *)clockInfo account:(NSString *)account callback:(void (^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        SmaAlarmInfo *info=clockInfo;
        BOOL result;
        NSString *date;
        if (info.aid) {
            date = [NSString stringWithFormat:@"%@%@%@%@%@00",info.year,info.mounth,info.day,info.hour,info.minute];
            NSTimeInterval timeInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:date timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set dayFlags='%@',aid=%d,timeInterval='%@',isopen=%d,tagname='%@',clock_web=%d where user_id=\'%@\' and clock_id=%d",info.dayFlags,[info.aid intValue],[NSString stringWithFormat:@"%f",timeInterval],[info.isOpen intValue],info.tagname,[info.isWeb intValue],account,info.aid.intValue];
            result = [db executeUpdate:updatesql];
            NSLog(@"修改闹钟 == %d",result);
        }
        else{
            
            date = [NSString stringWithFormat:@"%@%@%@%@%@00",info.year,info.mounth,info.day,info.hour,info.minute];
            NSTimeInterval timeInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:date timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            result = [db executeUpdate:@"INSERT INTO tb_clock (user_id,dayFlags,aid,timeInterval,isopen,tagname,clock_web) VALUES (?,?,?,?,?,?,?);",account,info.dayFlags,info.aid,[NSString stringWithFormat:@"%f",timeInterval],info.isOpen,info.tagname,info.isWeb];
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

//删除指定闹钟
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

//删除所有闹钟
- (void)deleteAllClockCallback:(void (^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL result = [db executeUpdate:@"delete from tb_clock where user_id=?",[SMAAccountTool userInfo].userID];
        NSLog(@"删除所有 %d",result);
        [db commit];
        callBack(result);
    }];
}

//获取所需要上传闹钟数据
- (NSMutableArray *)readNeedUploadALData{
    NSMutableArray *spArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_clock where user_id = \'%@\'",[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            NSMutableDictionary *sportDict = [NSMutableDictionary dictionary];
            [sportDict setObject:[SMAAccountTool userInfo].userID forKey:@"account"];
            [sportDict setObject:[rs stringForColumn:@"timeInterval"] ? [NSNumber numberWithLongLong:[rs stringForColumn:@"timeInterval"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"time"];
            //            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[rs stringForColumn:@"timeInterval"] doubleValue] withFormatStr:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //            [sportDict setObject:date forKey:@"date"];
            [sportDict setObject:[rs stringForColumn:@"dayFlags"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"dayFlags"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"repeat"];
            [sportDict setObject:[rs stringForColumn:@"isopen"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"isopen"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"enabled"];
            [sportDict setObject:[rs stringForColumn:@"tagname"] ? [rs stringForColumn:@"tagname"]:@"" forKey:@"tag"];
            [spArr addObject:sportDict];
        }
    }];
    return spArr;
    
}
//插入运动数据
- (void)insertSportDataArr:(NSMutableArray *)sportData finish:(void (^)(id finish)) success {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL result = false;
        for (int i = 0; i < sportData.count; i ++) {
            
            NSDictionary *spDic = (NSDictionary *)[sportData objectAtIndex:i];
            NSString *spID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[spDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]];
            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:spID.doubleValue timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date=\'%@\' and sp_mode=%d and time=%d and user_id=\'%@\'",YTD,[[spDic objectForKey:@"MODE"] intValue],moment.intValue,[spDic objectForKey:@"USERID"]];
            NSString *sportStep;
            FMResultSet *rs = [db executeQuery:sql];
            while (rs.next) {
                sportStep = [rs stringForColumn:@"time"];
            }
            if (sportStep && ![sportStep isEqualToString:@""]) {
                result =   [db executeUpdate:@"update tb_CuffSport set Cuff_id=?, step=?, sp_mode=?, sp_web=? where date=? and time=? and user_id=?",spID,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"MODE"],[spDic objectForKey:@"WEB"],YTD,moment,[spDic objectForKey:@"USERID"]];
                NSLog(@"步数更新  %d  步数  %@  模式  %@  时间 %@",result,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"MODE"],moment);
            }
            else{
                result =   [db executeUpdate:@"insert into tb_CuffSport (user_id,Cuff_id,date,time,step,ident,sp_mode,sp_web) values(?,?,?,?,?,?,?,?)",[spDic objectForKey:@"USERID"],spID,YTD,moment,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"INDEX"],[spDic objectForKey:@"MODE"],[spDic objectForKey:@"WEB"]];
                NSLog(@"步数插入  %d  步数  %@ 模式  %@ 时间 %@",result,[spDic objectForKey:@"STEP"],[spDic objectForKey:@"MODE"],moment);
            }
        }
        [db commit];
        success ([NSString stringWithFormat:@"%d",result]);
    }];
}

//获取运动数据
- (NSMutableArray *)readSportDataWithDate:(NSString *)date toDate:(NSString *)todate{
    NSMutableArray *spArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where step > 0 and date >=\'%@\' and date <=\'%@\' and sp_mode != 32 and sp_mode != 33 and sp_mode != 47 and user_id = \'%@\' group by date",date,todate,[SMAAccountTool userInfo].userID];
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
        
        //        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where step > 0 and date >=\'%@\' and date <=\'%@\' and sp_mode != 32 and sp_mode != 33 and sp_mode != 47 and user_id = \'%@\' group by time",date,todate,[SMAAccountTool userInfo].userID];
        //        FMResultSet *rs = [db executeQuery:sql];
        //        NSMutableArray *spDetailArr = [NSMutableArray array];
        //        NSString *sportT;
        //        NSString *sportD;
        //        NSString *sportS;
        //        NSString *sportM;
        //        while (rs.next) {
        //            sportT = [rs stringForColumn:@"time"];
        //            sportD = [rs stringForColumn:@"date"];
        //            sportS = [rs stringForColumn:@"step"];
        //            sportM = [rs stringForColumn:@"sp_mode"];
        //            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sportT,@"TIME",sportD,@"DATE",sportS,@"STEP",sportM,@"MODE", nil];
        //            [spDetailArr addObject:dic];
        //        }
        //        if (spDetailArr.count > 0) {
        //            [spArr addObject:spDetailArr];
        //        }
    }];
    return spArr;
}

//获取运动数据
- (NSMutableArray *)readSportDetailDataWithDate:(NSString *)date toDate:(NSString *)todate{
    NSMutableArray *spArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date >=\'%@\' and date <=\'%@\' and sp_mode != 32 and sp_mode != 33 and sp_mode != 47 and user_id = \'%@\' group by time",date,todate,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        NSString *sportT;
        NSString *sportD;
        NSString *sportS;
        NSString *sportM;
        while (rs.next) {
            sportT = [rs stringForColumn:@"time"];
            sportD = [rs stringForColumn:@"date"];
            sportS = [rs stringForColumn:@"step"];
            sportM = [rs stringForColumn:@"sp_mode"];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sportT,@"TIME",sportD,@"DATE",sportS,@"STEP",sportM,@"MODE", nil];
            [spArr addObject:dic];
        }
    }];
    return spArr;
}

//查找当天是否有运动数据
- (BOOL)selectSportDataWithDate:(NSString *)date{
    __block NSString *sportD;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where date=\'%@\' and user_id=\'%@\'",date,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            sportD = [rs stringForColumn:@"date"];
        }
    }];
    if (sportD) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSMutableArray *)readRunSportDetailDataWithDate:(NSString *)date{
    NSMutableArray *runArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where step > 0 and date = \'%@\' and (sp_mode = 32 or sp_mode = 47) and user_id = \'%@\' group by time",date,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        int starMode = 0;
        //        NSMutableArray *modeArr = [NSMutableArray array];
        NSMutableDictionary *modeDic;
        while (rs.next) {
            int mode = [rs intForColumn:@"sp_mode"];
            if (mode == 32) {
                if (starMode == 0) {
                    starMode = mode;
                    modeDic = [NSMutableDictionary dictionary];
                    [modeDic setObject:[rs stringForColumn:@"date"] forKey:@"DATE"];
                    [modeDic setObject:[rs stringForColumn:@"time"] forKey:@"STARTTIME"];
                    [modeDic setObject:[rs stringForColumn:@"step"] forKey:@"STARTSTEP"];
                }
            }
            else{
                starMode = 0;
                if (modeDic) { //确保有运动结束须有运动开始
                    [modeDic setObject:[rs stringForColumn:@"time"] forKey:@"ENDTIME"];
                    [modeDic setObject:[rs stringForColumn:@"step"] forKey:@"ENDSTEP"];
                    [runArr addObject:modeDic];
                    modeDic = nil;//保证若有多余结束时间以首个为准
                }
            }
            NSLog(@"fwfgwgrg===  %@  %d %@",runArr,mode,[rs stringForColumn:@"time"]);
        }
        //        for (int i = 0; i < modeArr.count; i ++) {
        //            NSMutableArray *runDetailArr = [NSMutableArray array];
        //            sql = [NSString stringWithFormat:@"selecet *from tb_CuffSport where step > 0 and date = \'%@\' and sp_mode != 0 and time >= %d and time <= %d and user_id = \'%@\' group by time",date,[[[modeArr objectAtIndex:i] objectForKey:@"STARTTIME"] intValue],[[[modeArr objectAtIndex:i] objectForKey:@"ENDTIME"] intValue],[SMAAccountTool userInfo].userID];
        //            rs = [db executeQuery:sql];
        //            int sumStep = 0;
        //            while (rs.next) {
        //
        //            }
        //        }
    }];
    return runArr;
}

- (NSMutableArray *)readRunDetailDataWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT{
    NSMutableArray *runDetailArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where step > 0 and date = \'%@\' and sp_mode != 0 and time >= %d and time <= %d and user_id = \'%@\' group by time",date,starT ,endT,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            NSMutableDictionary *modeDic = [NSMutableDictionary dictionary];
            [modeDic setObject:[rs stringForColumn:@"date"] forKey:@"DATE"];
            [modeDic setObject:[NSString stringWithFormat:@"%d:%d",[[rs stringForColumn:@"time"] intValue]/60,[[rs stringForColumn:@"time"] intValue]%60] forKey:@"TIME"];
            [modeDic setObject:[rs stringForColumn:@"step"] forKey:@"STEP"];
            [modeDic setObject:[rs stringForColumn:@"sp_mode"] forKey:@"MODE"];
            [runDetailArr addObject:modeDic];
        }
    }];
    return runDetailArr;
}

//获取所需要上传运动数据
- (NSMutableArray *)readNeedUploadSPData{
    NSMutableArray *spArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_CuffSport where sp_web=0 and user_id = \'%@\'",[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            NSMutableDictionary *sportDict = [NSMutableDictionary dictionary];
            [sportDict setObject:[SMAAccountTool userInfo].userID forKey:@"account"];
            [sportDict setObject:[rs stringForColumn:@"Cuff_id"] ? [NSNumber numberWithLongLong:[rs stringForColumn:@"Cuff_id"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"time"];
            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[rs stringForColumn:@"Cuff_id"] doubleValue] withFormatStr:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [sportDict setObject:date forKey:@"date"];
            [sportDict setObject:[rs stringForColumn:@"step"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"step"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"step"];
            [sportDict setObject:[rs stringForColumn:@"sp_mode"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"sp_mode"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"mode"];
            [spArr addObject:sportDict];
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
            NSString *spID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[slDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]];
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
                NSString *updatesql=[NSString stringWithFormat:@"update tb_sleep set sleep_id='%@', sleep_mode=%d,softly_action=%d,strong_action=%d,sleep_ident='%@',sleep_waer=%d,sleep_web=%d where sleep_date=\'%@\' and sleep_time=%d and user_id=\'%@\';",spID,[[slDic objectForKey:@"MODE"] intValue],[[slDic objectForKey:@"SOFTLY"] intValue],[[slDic objectForKey:@"STRONG"] intValue],[slDic objectForKey:@"INDEX"],[[slDic objectForKey:@"WEAR"] intValue],[[slDic objectForKey:@"WEB"] intValue],YTD,moment.intValue,[slDic objectForKey:@"USERID"]];
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
            if (strTime.intValue >= 1320) {
                NSDictionary *starDic = [NSDictionary dictionaryWithObjectsAndKeys:strDate,@"DATE",strTime,@"TIME",@"2",@"TYPE", nil];
                [sleepData addObject:starDic];
            }
            else{
                NSDictionary *starDic = [NSDictionary dictionaryWithObjectsAndKeys:strDate,@"DATE",[NSString stringWithFormat:@"%d",strTime.intValue + 1440],@"TIME",@"2",@"TYPE", nil];
                [sleepData addObject:starDic];
                
            }
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
                        NSString *sleepTime = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue + 1440];
                        NSString *sleepType;
                        int sleep_type;
                        if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                            if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                                NSString *time = [NSString stringWithFormat:@"%d",([rs stringForColumn:@"sleep_time"].intValue - 15) + 1440];
                                NSString *type = @"3";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 2;
                            }
                            else{
                                if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
                                    NSString *time = [NSString stringWithFormat:@"%d",([rs stringForColumn:@"sleep_time"].intValue - 15) + 1440];
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
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",sleepTime,@"TIME",sleepType,@"TYPE", nil];
                        [sleepData addObject:dic];
                    }
                }
                else{//入睡时间为当天，十点前睡眠数据
                    startSql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and sleep_time >=%d and sleep_time <=%d and user_id=\'%@\' and sleep_mode < 15 group by sleep_time",date,strTime.intValue,endTime.intValue,[SMAAccountTool userInfo].userID];
                    rs = [db executeQuery:startSql];
                    while (rs.next) {
                        
                        NSString *date = [rs stringForColumn:@"sleep_date"];
                        NSString *sleepTime = [NSString stringWithFormat:@"%d",[rs stringForColumn:@"sleep_time"].intValue + 1440];
                        NSString *sleepType = [rs stringForColumn:@"sleep_mode"];
                        int sleep_type;
                        if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                            if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                                NSString *time = [NSString stringWithFormat:@"%d",([rs stringForColumn:@"sleep_time"].intValue - 15) + 1440];
                                NSString *type = @"3";
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",time,@"TIME",type,@"TYPE", nil];
                                [sleepData addObject:dic];
                                sleep_type = 2;
                            }
                            else{
                                if ([[rs stringForColumn:@"softly_action"] floatValue]>1) {
                                    NSString *time = [NSString stringWithFormat:@"%d",([rs stringForColumn:@"sleep_time"].intValue - 15) + 1440];
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
                            //                            sleepType = [rs stringForColumn:@"sleep_mode"];
                        }
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"DATE",sleepTime,@"TIME",sleepType,@"TYPE", nil];
                        [sleepData addObject:dic];
                    }
                }
                NSDictionary *endDic = [NSDictionary dictionaryWithObjectsAndKeys:endDate,@"DATE",[NSString stringWithFormat:@"%d",endTime.intValue + 1440],@"TIME",@"3",@"TYPE", nil];
                [sleepData addObject:endDic];
            }
        }
    }];
    return sleepData;
}

//查找当天是否有睡眠数据
- (BOOL)selectSleepDataWithDate:(NSString *)date{
    __block NSString *sleepD;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_date=\'%@\' and user_id=\'%@\'",date,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            sleepD = [rs stringForColumn:@"sleep_date"];
        }
    }];
    if (sleepD) {
        return YES;
    }
    else{
        return NO;
    }
}

//获取所需要上传睡眠数据
- (NSMutableArray *)readNeedUploadSLData{
    NSMutableArray *slArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_sleep where sleep_web=0 and user_id = \'%@\'",[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            NSMutableDictionary *sleepDict = [NSMutableDictionary dictionary];
            [sleepDict setObject:[SMAAccountTool userInfo].userID forKey:@"account"];
            [sleepDict setObject:[rs stringForColumn:@"sleep_id"] ? [NSNumber numberWithLongLong:[rs stringForColumn:@"sleep_id"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"time"];
            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[rs stringForColumn:@"sleep_id"] doubleValue] withFormatStr:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [sleepDict setObject:date forKey:@"date"];
            [sleepDict setObject:[rs stringForColumn:@"sleep_mode"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"sleep_mode"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"mode"];
            [sleepDict setObject:[rs stringForColumn:@"strong_action"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"strong_action"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"strong"];
            [sleepDict setObject:[rs stringForColumn:@"softly_action"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"softly_action"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"soft"];
            [slArr addObject:sleepDict];
        }
    }];
    return slArr;
}

//插入心率数据
- (void)insertHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        __block BOOL result = false;
        for (int i = 0; i < HRarr.count; i ++) {
            NSMutableDictionary *hrDic=(NSMutableDictionary *)HRarr[i];
            NSString *hrID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[hrDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]];
            NSString *date = [hrDic objectForKey:@"DATE"];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *mode;
            NSString *HR_id;
            FMResultSet *rs = [db executeQuery:@"select * from tb_HRate where HR_date =? and HR_time=? and hr_mode=? and user_id=?",YTD,moment,[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"USERID"]];
            while ([rs next]) {
                mode = [rs stringForColumn:@"hr_mode"];
                HR_id = [rs stringForColumn:@"HR_id"];
            }
            
            if (HR_id && ![HR_id isEqualToString:@""]) {
                result = [db executeUpdate:@"update tb_HRate set HR_id=?, HR_real=?,hr_mode=?,HR_web=? where HR_date =? and HR_time=? and user_id=?",hrID,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"WEB"],YTD,moment,[hrDic objectForKey:@"USERID"]];
                NSLog(@"更新心率数据 %d ",result);
            }
            else{
                result = [db executeUpdate:@"insert into tb_HRate(user_id,HR_id,HR_date,HR_time,HR_real,hr_mode,HR_ident,HR_web) values(?,?,?,?,?,?,?,?)",[hrDic objectForKey:@"USERID"],hrID,YTD,moment,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"INDEX"],[hrDic objectForKey:@"WEB"]];
                NSLog(@"插入心率数据 %d",result);
            }
        }
        [db commit];
        success ([NSString stringWithFormat:@"%d",result]);
    }];
}

//查找当天是否有睡眠数据
- (BOOL)selectHRDataWithDate:(NSString *)date{
    __block NSString *HRD;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_HRate where HR_date=\'%@\' and user_id=\'%@\'",date,[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            HRD = [rs stringForColumn:@"HR_date"];
        }
    }];
    if (HRD) {
        return YES;
    }
    else{
        return NO;
    }
}

//插入静息心率数据
- (void)insertQuietHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        __block BOOL result = false;
        for (int i = 0; i < HRarr.count; i ++) {
            NSMutableDictionary *hrDic=(NSMutableDictionary *)HRarr[i];
            NSString *hrID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:[hrDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]];
            NSString *date = [hrDic objectForKey:@"DATE"];
            NSString *YTD = [date substringToIndex:8];
            NSString *moment = [SMADateDaultionfos minuteFormDate:date];
            NSString *mode;
            NSString *HR_id;
            FMResultSet *rs = [db executeQuery:@"select * from tb_HRate where HR_date =? and hr_mode=? and user_id=?",YTD,[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"USERID"]];
            while ([rs next]) {
                mode = [rs stringForColumn:@"hr_mode"];
                HR_id = [rs stringForColumn:@"HR_id"];
            }
            
            if (HR_id && ![HR_id isEqualToString:@""]) {
                result = [db executeUpdate:@"update tb_HRate set HR_id=?, HR_real=?,hr_mode=?,HR_web=? and HR_time=? where HR_date =? and user_id=?",hrID,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"WEB"],moment,YTD,[hrDic objectForKey:@"USERID"]];
                NSLog(@"更新静息心率数据 %d ",result);
            }
            else{
                result = [db executeUpdate:@"insert into tb_HRate(user_id,HR_id,HR_date,HR_time,HR_real,hr_mode,HR_ident,HR_web) values(?,?,?,?,?,?,?,?)",[hrDic objectForKey:@"USERID"],hrID,YTD,moment,[hrDic objectForKey:@"HEART"],[hrDic objectForKey:@"HRMODE"],[hrDic objectForKey:@"INDEX"],[hrDic objectForKey:@"WEB"]];
                NSLog(@"插入静息心率数据 %d",result);
            }
        }
        [db commit];
        success ([NSString stringWithFormat:@"%d",result]);
    }];
}

//读取心率数据
- (NSMutableArray *)readHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart =nil;
        if (!detail) {
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=0 and user_id=? group by HR_date",date,toDate,[SMAAccountTool userInfo].userID];
            
            while (rsChart.next) {
                NSDictionary *dict;
                NSString *date = [rsChart stringForColumn:@"HR_date"];
                NSString *time = [rsChart stringForColumn:@"HR_time"];
                NSString *HR_real = [rsChart stringForColumn:@"HR_real"];
                dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"DATE",time,@"TIME",HR_real,@"REAT", nil];
                [hrArr addObject:dict];
            }
            
            rsChart = [db executeQuery:@"select max(HR_real) as maxHR,min(HR_real) as minHR,avg(HR_real) as avgHR from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=0 and user_id=? group by HR_date",date,toDate,[SMAAccountTool userInfo].userID];
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
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=0 and user_id=? group by HR_time",date,toDate,[SMAAccountTool userInfo].userID];
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

//读取运动模式心率
- (NSMutableArray *)readRunHearReatDataWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT detail:(BOOL)detail{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart =nil;
        NSString *sql = nil;
        if (detail) {
            sql = [NSString stringWithFormat:@"select *from tb_HRate where hr_mode = 2 and HR_date = \'%@\' and HR_time >= %d and HR_time <= %d and user_id = \'%@\' group by HR_time",date,starT,endT,[SMAAccountTool userInfo].userID];
            rsChart = [db executeQuery:sql];
            while (rsChart.next) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[rsChart stringForColumn:@"HR_date"],@"DATE",[rsChart stringForColumn:@"HR_time"],@"TIME",[rsChart stringForColumn:@"HR_real"],@"REAT", nil];
                NSLog(@"GWGRGGH----%@",dic);
                [hrArr addObject:dic];
            }
        }
        else{
            sql = [NSString stringWithFormat:@"select *from tb_HRate where hr_mode = 2 and HR_date = \'%@\' and HR_time >= %d and HR_time <= %d and user_id = \'%@\' order by HR_time DESC limit 1",date,starT,endT,[SMAAccountTool userInfo].userID];
            rsChart = [db executeQuery:sql];
            while (rsChart.next) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[rsChart stringForColumn:@"HR_date"],@"DATE",[rsChart stringForColumn:@"HR_time"],@"TIME",[rsChart stringForColumn:@"HR_real"],@"REAT", nil];
                NSLog(@"GWGRGGH0000----%@",dic);
                [hrArr addObject:dic];
            }
        }
    }];
    return hrArr;
}

//获取平均、最大、最小心率
- (NSDictionary *)readSummaryHreatReatWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT{
    __block NSDictionary *dict;
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart = [db executeQuery:@"select HR_date timeSegment,max(HR_real) as maxHR,min(HR_real) as minHR,avg(HR_real) as avgHR from tb_HRate where HR_date=? and HR_real !=0 and HR_time >= ? and HR_time <= ? and user_id=?  group by HR_date;",date,[NSString stringWithFormat:@"%d",starT],[NSString stringWithFormat:@"%d",endT],[SMAAccountTool userInfo].userID];
        while (rsChart.next) {
            NSString *HRDate = [rsChart stringForColumn:@"timeSegment"] ? [rsChart stringForColumn:@"timeSegment"]:@"0";
            NSString *max = [rsChart stringForColumn:@"maxHR"] ? [rsChart stringForColumn:@"maxHR"]:@"0";
            NSString *min = [rsChart stringForColumn:@"minHR"] ? [rsChart stringForColumn:@"minHR"]:@"0";
            NSString *avg = [rsChart stringForColumn:@"avgHR"] ? [rsChart stringForColumn:@"avgHR"]:@"0";
            dict = [[NSDictionary alloc]initWithObjectsAndKeys:HRDate,@"timeSegment",max,@"maxHR",min,@"minHR",avg,@"avgHR", nil];
        }
    }];
    return dict;
}

//读取静息心率数据
- (NSMutableArray *)readQuietHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsChart =nil;
        if (!detail) {
            rsChart = [db executeQuery:@"select max(HR_real) as maxHR,min(HR_real) as minHR,avg(HR_real) as avgHR from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=1 and user_id=?",date,toDate,[SMAAccountTool userInfo].userID];
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
            rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=1 and user_id=? group by HR_time",date,toDate,[SMAAccountTool userInfo].userID];
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

//读取每天静息心率数据
- (NSMutableArray *)readQuietHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate{
     NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
       FMResultSet *rsChart = [db executeQuery:@"select *from tb_HRate where HR_date>=? and HR_date<=? and hr_mode=1 and user_id=? group by HR_date order by HR_date DESC",date,toDate,[SMAAccountTool userInfo].userID];
        while (rsChart.next) {
            NSDictionary *dict;
            NSString *date = [rsChart stringForColumn:@"HR_date"];
            NSString *time = [rsChart stringForColumn:@"HR_time"];
            NSString *HR_real = [rsChart stringForColumn:@"HR_real"];
            NSString *HR_id = [rsChart stringForColumn:@"HR_id"];
            dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"DATE",time,@"TIME",HR_real,@"HEART",HR_id,@"ID", nil];
            [hrArr addObject:dict];
        }
    }];
    return hrArr;
}

//删除指定静息心率数据
- (void)deleteQuietHearReatDataWithDate:(NSString *)date time:(NSString *)time{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        NSString *updatesql=[NSString stringWithFormat:@"delete from tb_HRate where HR_date=\'%@\' and HR_time =%d and user_id=\'%@\' and hr_mode=1",date,time.intValue,[SMAAccountTool userInfo].userID];
        BOOL result = [db executeUpdate:updatesql];
        NSLog(@"删除 %d",result);
        [db commit];
    }];
}

//获取所需要上传心率数据
- (NSMutableArray *)readNeedUploadHRData{
    NSMutableArray *hrArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select *from tb_HRate where HR_web=0 and user_id = \'%@\'",[SMAAccountTool userInfo].userID];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            NSMutableDictionary *hrDict = [NSMutableDictionary dictionary];
            NSLog(@"ffwf==%d",[rs intForColumn:@"HR_web"]);
            [hrDict setObject:[SMAAccountTool userInfo].userID forKey:@"account"];
            [hrDict setObject:[rs stringForColumn:@"HR_id"] ? [NSNumber numberWithLongLong:[rs stringForColumn:@"HR_id"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"time"];
            NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[rs stringForColumn:@"HR_id"] doubleValue] withFormatStr:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [hrDict setObject:date forKey:@"date"];
            [hrDict setObject:[rs stringForColumn:@"hr_mode"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"hr_mode"] intValue]] : [NSNumber numberWithInt:@"".intValue] forKey:@"type"];
            [hrDict setObject:[rs stringForColumn:@"HR_real"] ? [NSNumber numberWithInt:[[rs stringForColumn:@"HR_real"] intValue]]:[NSNumber numberWithInt:@"".intValue] forKey:@"value"];
            [hrArr addObject:hrDict];
        }
    }];
    return hrArr;
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
@end
