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
             
             result = [db executeUpdate:@"create table if not exists tb_clock (clock_id integer primary key autoincrement,user_id text,dayFlags text, aid text,timeInterval text,isopen integer,tagname text,clock_web integer);"];
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
            
            NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set dayFlags='%@',aid=%d,timeInterval='%@',isopen=%d,tagname='%@',clock_web=%d where user_id='%@' and clock_id=%d",info.dayFlags,[info.aid intValue],[NSString stringWithFormat:@"%f",timeInterval],[info.isOpen intValue],info.tagname,[info.isWeb intValue],[SMAAccountTool userInfo].userID,info.aid.intValue];
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
@end
