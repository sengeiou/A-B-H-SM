//
//  SMADatabase.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "SMADateDaultionfos.h"
#import "NSDate+Formatter.h"
@interface SMADatabase : NSObject
@property (nonatomic, strong) FMDatabaseQueue *queue;
//插入闹钟
- (void)insertClockInfo:(SmaAlarmInfo *)clockInfo callback:(void (^)(BOOL result))callBack;
//获取闹钟列表
-(NSMutableArray *)selectClockList;
//删除闹钟
- (void)deleteClockInfo:(NSString *)clockId callback:(void (^)(BOOL result))callBack;

//插入运动数据
- (void)insertSportDataArr:(NSMutableArray *)sportData finish:(void (^)(id finish)) succes;
//获取运动数据
- (NSMutableArray *)readSportDataWithDate:(NSString *)date toDate:(NSString *)todate lastData:(BOOL)last;
//插入睡眠数据
-(void)insertSleepDataArr:(NSMutableArray *)sleepData finish:(void (^)(id finish)) success;
//读取睡眠数据
- (void)readSleepDataWithDate:(NSString *)date;
//插入心率数据
- (void)insertHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success;
//读取心率数据
- (NSMutableArray *)readHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail;

@end

