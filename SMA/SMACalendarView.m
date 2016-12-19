//  SMACalendarView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/15.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMACalendarView.h"

@interface SMACalendarView ()
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) UILabel *dateLabel;
@end

@implementation SMACalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [UIView animateWithDuration:0.5 animations:^{
    //        self.transform = CGAffineTransformIdentity;
    //        self.alpha = 0;
    //    } completion:^(BOOL finished) {
    [self removeFromSuperview];
    //    }];
}

- (void)createUI{
    //    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 64)];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = backView.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = backView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[SmaColor colorWithHexString:@"#5790F9" alpha:1] CGColor],
                             (id)[[SmaColor colorWithHexString:@"#80C1F9" alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [backView.layer insertSublayer:_gradientLayer atIndex:0];
    
    UIButton *lastBut = [UIButton buttonWithType:UIButtonTypeCustom];
    lastBut.frame = CGRectMake(10, 20, 50, 40);
    lastBut.tag = 101;
    [lastBut setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [lastBut addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:lastBut];
    
    UIButton *nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBut.frame = CGRectMake(LL_SCREEN_WIDTH - 60, 20, 50, 40);
    [nextBut setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextBut addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    nextBut.tag = 102;
    [backView addSubview:nextBut];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastBut.frame), 20, LL_SCREEN_WIDTH - CGRectGetMaxX(lastBut.frame) - CGRectGetWidth(nextBut.frame) - 10, 40)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = FontGothamLight(20);
    _dateLabel.textColor = [UIColor whiteColor];
    [backView addSubview:_dateLabel];
    [self addSubview:backView];
    
    [self addSubview:self.collectionView];
}

static int nowDay;
- (void)getDataDayModel:(NSDate *)date{
    self.tempDate = date;
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:self.date.yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
               
            }
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isGreaterNowDay = YES;
                 nowDay = day;
            }
            if (dayDate.yyyyMMddNoLineWithDate.intValue <= [NSDate date].yyyyMMddNoLineWithDate.intValue) {
                mon.isGreaterData = [self selectDataWithDate:dayDate.yyyyMMddNoLineWithDate];
            }
            if (day > nowDay && nowDay != 0 && [[date.mmddByLineWithDate substringToIndex:2] isEqualToString:[[NSDate date].mmddByLineWithDate substringToIndex:2]]) {
                mon.isGreaterThanNowDay = YES;
            }
            [_dayModelArray addObject:mon];
            day++;
        }
    }
    nowDay = 0;
    if ([[self.tempDate.mmddByLineWithDate substringToIndex:2] isEqualToString:[[NSDate date].mmddByLineWithDate substringToIndex:2]]) {
        UIButton *but = (UIButton *)[self viewWithTag:102];
        but.enabled = NO;
    }
    else{
        UIButton *but = (UIButton *)[self viewWithTag:102];
        but.enabled = YES;
    }
    [self.collectionView reloadData];
}

- (BOOL)selectDataWithDate:(NSString *)date{
    SMADatabase *sqlBase = [[SMADatabase alloc] init];
    BOOL spResult = [sqlBase selectSportDataWithDate:date];
    BOOL slResult = [sqlBase selectSleepDataWithDate:date];
    BOOL hrResult = [sqlBase selectHRDataWithDate:date];
    if (spResult || slResult || hrResult) {
        return  YES;
    }
    return NO;
}

- (void)tap:(UIButton *)sender{
    switch (sender.tag) {
        case 101:
            [self lastMonth:sender];
            break;
            
        default:
            [self nextMonth:sender];
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
//    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    id mon = _dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
        cell.selectDayIma.image = nil;
        cell.nowDayIma.image = nil;
        cell.dataIma.image = nil;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = (CalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        for (int i = 0; i < _dayModelArray.count; i ++) {
            id model = [self.dayModelArray objectAtIndex:i];
            CalendarCell *allCell = (CalendarCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([model isKindOfClass:[MonthModel class]]) {
                MonthModel *mondel = (MonthModel *)model;
                mondel = (MonthModel *)model;
                int ia = indexPath.row;
                NSLog(@"efwefw==%d  %D",mondel.isGreaterThanNowDay,indexPath.row);
                if (mondel.isGreaterThanNowDay == 0) {
                    mondel.isSelectedDay = NO;
                    if (i == indexPath.row ) {
                        mondel.isSelectedDay = YES;
                        allCell.monthModel = mondel;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
                            [self.delegate didSelectDate:[(MonthModel *)mon dateValue]];
                        }
                    }
                }
            }
            else{
                cell.dayLabel.text = @"";
                cell.selectDayIma.image = nil;
                cell.nowDayIma.image = nil;
                cell.dataIma.image = nil;
            }
        }
         [self removeFromSuperview];
    }
}

- (UICollectionView *)collectionView{
    NSInteger width = Iphone6Scale(54);
    NSInteger height = Iphone6Scale(54);
    _collectionView.frame = CGRectMake(0, 64,  width * 7, (_dayModelArray.count/7 + (_dayModelArray.count%7 == 0?0:1))*46.0 + HeaderViewHeight);
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, width * 7, LL_SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
    }
    return _collectionView;
}


#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

- (void)lastMonth:(UIButton *)sender {
    self.tempDate = [self getLastMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];

}

- (void)nextMonth:(UIButton *)sender {
    self.tempDate = [self getNextMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];

}

@end

@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:SMALocalizedString(@"setting_sedentary_sun"),SMALocalizedString(@"setting_sedentary_mon"),SMALocalizedString(@"setting_sedentary_tue"),SMALocalizedString(@"setting_sedentary_wed"),SMALocalizedString(@"setting_sedentary_thu"),SMALocalizedString(@"setting_sedentary_fri"),SMALocalizedString(@"setting_sedentary_sat"), nil];
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*Iphone6Scale(54), 0, Iphone6Scale(54), HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor grayColor];
            weekLabel.font = [UIFont systemFontOfSize:13.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
    }
    return self;
}
@end

@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width*0.6-width*0.5,  self.contentView.frame.size.height*0.6-height*0.5 - 1, width, height )];
        [self.contentView addSubview:selectView];
        
        UIImageView *nowdayView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width*0.6-width*0.5,  self.contentView.frame.size.height*0.6-height*0.5 - 1, width, height )];
        [self.contentView addSubview:nowdayView];
        
        UIImageView *dataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width*0.6-width*0.5,  self.contentView.frame.size.height*0.6-height*0.5 - 1, width, height )];
        [self.contentView addSubview:dataView];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width*0.6-width*0.5,  self.contentView.frame.size.height*0.6-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
//        dayLabel.layer.masksToBounds = YES;
//        dayLabel.layer.cornerRadius = height * 0.5;
        dayLabel.font = FontGothamLight(17);
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        self.selectDayIma = selectView;
        self.nowDayIma = nowdayView;
        self.dataIma = dataView;
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)monthModel.dayValue];
//    UIImage *ima = [UIImage imageNamed:@"date_choose_selected"];
//    self.dayIma.image = [UIImage imageNamed:@"date_choose_selected"];
    self.selectDayIma.image = nil;
    self.nowDayIma.image = nil;
    self.dataIma.image = nil;
    if (monthModel.isSelectedDay) {
//        self.dayIma.backgroundColor = [UIColor redColor];
        self.selectDayIma.image = [UIImage imageNamed:@"date_choose_selected"];
        self.dayLabel.textColor = [UIColor blackColor];
    }
    else{
        self.dayLabel.textColor = [UIColor blackColor];
    }
    if (monthModel.isGreaterThanNowDay) {
        self.dayLabel.textColor = [UIColor grayColor];
    }
    if (monthModel.isGreaterNowDay) {
        self.nowDayIma.image = [UIImage imageNamed:@"nowdate_choose"];
        self.dayLabel.textColor = [UIColor whiteColor];
    }
    if (monthModel.isGreaterData) {
        self.dataIma.image = [UIImage imageNamed:@"date_choose_hover"];
    }
}
@end


@implementation MonthModel

@end
