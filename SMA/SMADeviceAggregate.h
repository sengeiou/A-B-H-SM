//
//  SMADeviceAggregate.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Formatter.h"
@interface SMADeviceAggregate : NSObject
@property (strong, nonatomic) NSMutableArray *aggregateSlWeekData;
@property (strong, nonatomic) NSMutableArray *aggregateSpWeekData;
@property (strong, nonatomic) NSMutableArray *aggregateSpMonthData;
@property (strong, nonatomic) NSTimer *aggregateTimer; //预加载定时器
+ (instancetype)deviceAggregateTool;
- (void)initilizeWithWeek;
- (void)stopLoading;
- (void)startLoading;
- (NSMutableArray *)getSPDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month;
@end
