//
//  SMATrackDetailView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATrackDetailView.h"

@implementation SMATrackDetailView
{
    UILabel *timeLab;
    UILabel *timeTitLab;
    UILabel *disLab;
    UILabel *perLab;
    UILabel *paceLab;
    UILabel *calLab;
    UILabel *hrLab;
    UILabel *avgLab;
    UILabel *maxLab;
    UIButton *hrTapBut;
    BOOL hidden;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
        [self createUI];
    }
    return self;
}

+ (instancetype)initializeView{
    SMATrackDetailView *trackView = [[self alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 300)];
    return trackView;
}

- (void)createUI{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGR];
    
    UIView *runTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 44)];
    runTimeView.backgroundColor = [SmaColor colorWithHexString:@"#5691FF" alpha:1];
    [self addSubview:runTimeView];
    
    CGSize fontSize = [@"00:00:000" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 10 - fontSize.width, 0, fontSize.width, 44)];
    timeLab.textColor = [UIColor whiteColor];
    timeLab.font = FontGothamLight(20);
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.text = @"00:00:00";
//    timeLab.backgroundColor = [UIColor blueColor];
    
    timeTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(timeLab.frame) - 10, 44)];
    timeTitLab.textColor = [UIColor whiteColor];
    timeTitLab.font = FontGothamLight(16);
    timeTitLab.text = SMALocalizedString(@"运动时长");
//    timeTitLab.backgroundColor = [UIColor blackColor];
    
    [runTimeView addSubview:timeLab];
    [runTimeView addSubview:timeTitLab];
    
    //路程
    UIView *disView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    disView.backgroundColor = [UIColor whiteColor];
    [self addSubview:disView];
    
    UIImageView *disIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 26)];
    disIma.image = [UIImage imageNamed:@"icon_distance"];
    disIma.center = CGPointMake(disIma.center.x, disView.frame.size.height/2);
    
    disLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, 0, CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disLab.textAlignment = NSTextAlignmentCenter;
//    disLab.backgroundColor = [UIColor greenColor];
    disLab.center = CGPointMake(disLab.center.x, CGRectGetHeight(disView.frame)/2 - 10);
    
    UILabel *disTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, CGRectGetMaxY(disLab.frame) , CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disTitLab.textAlignment = NSTextAlignmentCenter;
    disTitLab.font = FontGothamLight(14);
    disTitLab.text = SMALocalizedString(@"device_SP_sumDista");
    disTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    disTitLab.backgroundColor = [UIColor blueColor];
    [disView addSubview:disIma];
    [disView addSubview:disLab];
    [disView addSubview:disTitLab];
    
    //时速
    UIView *perView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disView.frame) + 1, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    perView.backgroundColor = [UIColor whiteColor];
    [self addSubview:perView];
    
    UIImageView *perIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 21, 25)];
    perIma.image = [UIImage imageNamed:@"icon_speed"];
    perIma.center = CGPointMake(perIma.center.x, perView.frame.size.height/2);
    
    perLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, 0, CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) -16, 26)];
    perLab.textAlignment = NSTextAlignmentCenter;
//    perLab.backgroundColor = [UIColor greenColor];
    perLab.center = CGPointMake(perLab.center.x, CGRectGetHeight(perView.frame)/2 - 10);
    
    UILabel *perTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, CGRectGetMaxY(perLab.frame) , CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) +- 16, 26)];
    perTitLab.textAlignment = NSTextAlignmentCenter;
    perTitLab.font = FontGothamLight(14);
    perTitLab.text = SMALocalizedString(@"device_RU_per");
    perTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    perTitLab.backgroundColor = [UIColor blueColor];
    [perView addSubview:perIma];
    [perView addSubview:perLab];
    [perView addSubview:perTitLab];

    //配速
    UIView *paceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 70)];
    paceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:paceView];
    
    UIImageView *paceIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 25, 23)];
    paceIma.image = [UIImage imageNamed:@"icon_pace"];
    paceIma.center = CGPointMake(paceIma.center.x, paceView.frame.size.height/2);
    
    paceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 8, 0, CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 16, 26)];
    paceLab.textAlignment = NSTextAlignmentCenter;
//    paceLab.backgroundColor = [UIColor greenColor];
    paceLab.center = CGPointMake(paceLab.center.x, CGRectGetHeight(paceView.frame)/2 - 10);
    
    UILabel *paceTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 8, CGRectGetMaxY(paceLab.frame) , CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 16, 26)];
    paceTitLab.textAlignment = NSTextAlignmentCenter;
    paceTitLab.font = FontGothamLight(14);
    paceTitLab.text = SMALocalizedString(@"device_RU_pace");
    paceTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    paceTitLab.backgroundColor = [UIColor blueColor];
    [paceView addSubview:paceIma];
    [paceView addSubview:paceLab];
    [paceView addSubview:paceTitLab];
    
    //卡路里
    UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceView.frame) + 1, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 70)];
    calView.backgroundColor = [UIColor whiteColor];
    [self addSubview:calView];
    
    UIImageView *calIma = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 23, 26)];
    calIma.image = [UIImage imageNamed:@"icon_cal"];
    calIma.center = CGPointMake(calIma.center.x, calView.frame.size.height/2);
    
    calLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, 0, CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) -
                                                       16, 26)];
    calLab.textAlignment = NSTextAlignmentCenter;
//    calLab.backgroundColor = [UIColor greenColor];
    calLab.center = CGPointMake(calLab.center.x, CGRectGetHeight(calView.frame)/2 - 10);
    
    UILabel *calTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, CGRectGetMaxY(calLab.frame) , CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) - 16, 26)];
    calTitLab.textAlignment = NSTextAlignmentCenter;
    calTitLab.font = FontGothamLight(14);
    calTitLab.text = SMALocalizedString(@"device_SP_calorie");
    calTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    calTitLab.backgroundColor = [UIColor blueColor];
    [calView addSubview:calIma];
    [calView addSubview:calLab];
    [calView addSubview:calTitLab];
    
    //心率
    UIView *hrTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calView.frame), MainScreen.size.width, 44)];
    hrTimeView.backgroundColor = [SmaColor colorWithHexString:@"#FF568A" alpha:1];
    [self addSubview:hrTimeView];
    
    hrTapBut = [UIButton buttonWithType:UIButtonTypeCustom];
    hrTapBut.frame = CGRectMake(0, 0,  MainScreen.size.width, 44);
    
    [hrTimeView addSubview:hrTapBut];
    
    UIImageView *indexIma = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20, 12, 12, 20)];
    indexIma.image = [UIImage imageNamed:@"icon_next"];
    [hrTimeView addSubview:indexIma];
    
    CGSize fontSize2 = [@"228 bpm" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    hrLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 25 - fontSize2.width, 0, fontSize2.width, 44)];
    hrLab.textColor = [UIColor whiteColor];
    hrLab.font = FontGothamLight(20);
    hrLab.textAlignment = NSTextAlignmentRight;
    hrLab.text = @"228 bpm";
//    hrLab.backgroundColor = [UIColor blueColor];
    
    UILabel *hrTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(hrLab.frame) - 10, 44)];
    hrTitLab.textColor = [UIColor whiteColor];
    hrTitLab.font = FontGothamLight(16);
    hrTitLab.text = SMALocalizedString(@"即时心率");
//    hrTitLab.backgroundColor = [UIColor blackColor];
    
    [hrTimeView addSubview:hrLab];
    [hrTimeView addSubview:hrTitLab];
    
    //平均心率
    UIView *avgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hrTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    avgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:avgView];
    
    UIImageView *avgIma = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 24, 15)];
    avgIma.image = [UIImage imageNamed:@"icon_heart"];
    avgIma.center = CGPointMake(avgIma.center.x, avgView.frame.size.height/2);
    
    avgLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, 0, CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgLab.textAlignment = NSTextAlignmentCenter;
//    avgLab.backgroundColor = [UIColor greenColor];
    avgLab.center = CGPointMake(avgLab.center.x, CGRectGetHeight(avgView.frame)/2 - 10);
    
    UILabel *avgTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, CGRectGetMaxY(avgLab.frame) , CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgTitLab.textAlignment = NSTextAlignmentCenter;
    avgTitLab.font = FontGothamLight(14);
    avgTitLab.text = SMALocalizedString(@"device_HR_mean");
    avgTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    avgTitLab.backgroundColor = [UIColor blueColor];
    [avgView addSubview:avgIma];
    [avgView addSubview:avgLab];
    [avgView addSubview:avgTitLab];
    
    //最大心率
    UIView *maxView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgView.frame) + 1, CGRectGetMaxY(hrTimeView.frame) , MainScreen.size.width/2 - 0.5, 70)];
    maxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:maxView];
    
    UIImageView *maxIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 25, 23)];
    maxIma.image = [UIImage imageNamed:@"icon_heart_big"];
    maxIma.center = CGPointMake(maxIma.center.x, maxView.frame.size.height/2);
    
    maxLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, 0, CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxLab.textAlignment = NSTextAlignmentCenter;
//    maxLab.backgroundColor = [UIColor greenColor];
    maxLab.center = CGPointMake(maxLab.center.x, CGRectGetHeight(maxView.frame)/2 - 10);
    
    UILabel *maxTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, CGRectGetMaxY(maxLab.frame) , CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxTitLab.textAlignment = NSTextAlignmentCenter;
    maxTitLab.font = FontGothamLight(14);
    maxTitLab.text = SMALocalizedString(@"device_HR_max");
    maxTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
//    maxTitLab.backgroundColor = [UIColor blueColor];
    [maxView addSubview:maxIma];
    [maxView addSubview:maxLab];
    [maxView addSubview:maxTitLab];
    
    CGFloat viewHight = CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame);
    self.frame = CGRectMake(self.frame.origin.x, MainScreen.size.height - viewHight - 64, self.frame.size.width, CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));
}

- (void)tapAction{
    hidden = !hidden;
    if (hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height - 44);
            NSLog(@"+++%@",NSStringFromCGRect(self.frame));
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
            }];
    }
}

- (void)updateUIwithData:(NSMutableDictionary *)dic{
    timeLab.text = dic[@"RUNTIME"];
    disLab.attributedText = dic[@"DISTANCE"];;
    perLab.attributedText = dic[@"PER"];;
    paceLab.attributedText = dic[@"PACE"];;
    calLab.attributedText = dic[@"CAL"];;
    hrLab.attributedText = dic[@"REAT"];;
    avgLab.attributedText = dic[@"AVGHR"];;
    maxLab.attributedText = dic[@"MAXHR"];;
}

- (void)tapPushBut:(pushAction)action{
    _block = action;
    [hrTapBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushAction:(UIButton *)sender{
    _block(sender);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
