//
//  SMAAggregateTool.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAAggregateTool : NSObject

+ (NSMutableArray *)getSPDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month;
+ (NSMutableArray *)getDetalilObligateDataWithDate:(NSDate *)date month:(BOOL)month;
+ (NSMutableArray *)getSleepWeekDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month;
+ (NSMutableArray *)getSLDetalilObligateDataWithDate:(NSDate *)date month:(BOOL)month;
@end
