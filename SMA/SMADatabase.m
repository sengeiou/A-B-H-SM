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
             
             result = [db executeUpdate:@"create table if not exists tb_clock (clock_id integer primary key autoincrement,user_id text,dayFlags text, aid text,minute text,hour text,day text,mounth text,year text,isopen integer,tagname text,clock_web integer);"];
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
        if (info.aid) {
            NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set dayFlags='%@',aid=%d,isopen=%d,tagname='%@',hour='%@',minute='%@',clock_web=%d where user_id='%@' and clock_id=%d",info.dayFlags,[info.aid intValue],[info.isOpen intValue],info.tagname,info.hour,info.minute,[info.isWeb intValue],[SMAAccountTool userInfo].userID,info.aid.intValue];
            result = [db executeUpdate:updatesql];
            NSLog(@"修改闹钟 == %d",result);
        }
        else{
        result = [db executeUpdate:@"INSERT INTO tb_clock (user_id,dayFlags,aid,minute,hour,day ,mounth ,year ,isopen,tagname,clock_web) VALUES (?,?,?,?,?,?,?,?,?,?,?);",[SMAAccountTool userInfo].userID,info.dayFlags,info.aid,info.minute,info.hour,info.day,info.mounth,info.year,info.isOpen,info.tagname,info.isWeb];
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
//            info.clockid=[rs stringForColumn:@"clock_id"];
            info.aid=[rs stringForColumn:@"clock_id"];
            info.dayFlags=[rs stringForColumn:@"dayFlags"];
            info.minute=[rs stringForColumn:@"minute"];
            info.hour=[rs stringForColumn:@"hour"];
            info.mounth=[rs stringForColumn:@"mounth"];
            info.day=[rs stringForColumn:@"day"];
            info.year=[rs stringForColumn:@"year"];
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
