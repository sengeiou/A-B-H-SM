//
//  SMACalendarView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/15.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Formatter.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)
#define HeaderViewHeight 30
#define WeekViewHeight 40

@class MonthModel;
@protocol calenderDelegate <NSObject>
- (void)didSelectDate:(NSDate *)date;
@end
@interface SMACalendarView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) NSDate *date;
@property (weak,   nonatomic) id<calenderDelegate> delegate;
- (void)getDataDayModel:(NSDate *)date;
- (void)lastMonth:(id)sender;
- (void)nextMonth:(id)sender;
@end

//CollectionViewHeader
@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;
@property (weak, nonatomic) UIImageView *selectDayIma;
@property (weak, nonatomic) UIImageView *nowDayIma;
@property (weak, nonatomic) UIImageView *dataIma;
@property (strong, nonatomic) NSMutableArray *dayLabelArr;
@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@property (assign, nonatomic) BOOL isGreaterThanNowDay;
@property (assign, nonatomic) BOOL isGreaterNowDay;
@property (assign, nonatomic) BOOL isGreaterData;
@end
