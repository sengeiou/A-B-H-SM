//
//  SMADatabase.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface SMADatabase : NSObject
@property (nonatomic, strong) FMDatabaseQueue *queue;
//插入闹钟
- (void)insertClockInfo:(SmaAlarmInfo *)clockInfo callback:(void (^)(BOOL result))callBack;
//获取闹钟列表
-(NSMutableArray *)selectClockList;
//删除闹钟
- (void)deleteClockInfo:(NSString *)clockId callback:(void (^)(BOOL result))callBack;
@end
