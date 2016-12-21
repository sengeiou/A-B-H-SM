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
- (void)insertClockInfo:(SmaAlarmInfo *)clockInfo account:(NSString *)account callback:(void (^)(BOOL result))callBack;
//获取闹钟列表
-(NSMutableArray *)selectClockList;
//删除闹钟
- (void)deleteClockInfo:(NSString *)clockId callback:(void (^)(BOOL result))callBack;
//删除所有闹钟
- (void)deleteAllClockCallback:(void (^)(BOOL result))callBack;
//获取所需要上传闹钟数据
- (NSMutableArray *)readNeedUploadALData;
//插入运动数据
- (void)insertSportDataArr:(NSMutableArray *)sportData finish:(void (^)(id finish)) succes;
//获取运动数据
- (NSMutableArray *)readSportDataWithDate:(NSString *)date toDate:(NSString *)todate;
//获取详细运动数据
- (NSMutableArray *)readSportDetailDataWithDate:(NSString *)date toDate:(NSString *)todate;
//查找当天是否有运动数据
- (BOOL)selectSportDataWithDate:(NSString *)date;
//获取运动模式数据
- (NSMutableArray *)readRunSportDetailDataWithDate:(NSString *)date;

- (NSMutableArray *)readRunDetailDataWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT;

//获取所需要上传运动数据
- (NSMutableArray *)readNeedUploadSPData;
//获取首条运动数据
- (NSString *)readFirstSportdata;
//插入睡眠数据
-(void)insertSleepDataArr:(NSMutableArray *)sleepData finish:(void (^)(id finish)) success;
//读取睡眠数据
- (NSMutableArray *)readSleepDataWithDate:(NSString *)date;
//查找当天是否有睡眠数据
- (BOOL)selectSleepDataWithDate:(NSString *)date;
//获取所需要上传睡眠数据
- (NSMutableArray *)readNeedUploadSLData;
//插入心率数据
- (void)insertHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success;
//查找当天是否有睡眠数据
- (BOOL)selectHRDataWithDate:(NSString *)date;
//插入静息心率数据
- (void)insertQuietHRDataArr:(NSMutableArray *)HRarr finish:(void (^)(id finish)) success;
//读取心率数据
- (NSMutableArray *)readHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail;
//读取运动模式心率
- (NSMutableArray *)readRunHearReatDataWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT detail:(BOOL)detail;
//获取平均、最大、最小心率
- (NSDictionary *)readSummaryHreatReatWithDate:(NSString *)date startTime:(int)starT endTime:(int)endT;
//读取静息心率数据
- (NSMutableArray *)readQuietHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate detailData:(BOOL)detail;
//读取每天静息心率数据
- (NSMutableArray *)readQuietHearReatDataWithDate:(NSString *)date toDate:(NSString *)toDate;
//删除指定静息心率数据
- (void)deleteQuietHearReatDataWithDate:(NSString *)date time:(NSString *)time;

//获取所需要上传心率数据
- (NSMutableArray *)readNeedUploadHRData;
@end

