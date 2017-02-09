//
//  SMACalibrationViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMACalibrationViewController.h"

@interface SMACalibrationViewController ()
{
    int pointerStype;
    BOOL nextStep;
}
@end

@implementation SMACalibrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    [SmaBleSend setStopTiming];
    [SmaBleSend setPrepareTiming];
}

- (void)viewWillAppear:(BOOL)animated{
    nextStep = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    if (!nextStep) {
        [SmaBleSend setCancelTiming];
         [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1];
    _clockView.borderColor = [UIColor whiteColor];
    _clockView.borderWidth = 3;
    _clockView.faceBackgroundColor = [UIColor whiteColor];
    _clockView.faceBackgroundAlpha = 0.0;
    _clockView.delegate = self;
    _clockView.digitOffset = 15;
    _clockView.digitFont = FontGothamBold(16);
    _clockView.digitColor = [UIColor whiteColor];
    _clockView.enableDigit = YES;
    _clockView.hours = 6;
    _clockView.minutes = 0;
    _clockView.secondHandAlpha = 0;
    _clockView.minuteHandAlpha = 0;
    
    _timeView.starTick = 0;
    _timeView.stopTick = 13;
    _timeView.showTick = 6;
    _timeView.alarmDelegate = self;
    _timeView.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:0.5];
    _timeView.clockRuler.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:0];
    
    self.title = SMALocalizedString(@"setting_timing_title");
    _remindLab.text = SMALocalizedString(@"setting_timing_remind");
    _timeLab.text = SMALocalizedString(@"setting_timing_hour");
    _timeDetailLab.text = @"6";
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
}

- (void)scrollDidEndDecelerating:(NSString *)ruler scrollView:(UIScrollView *)scrollview{
    _clockView.hours = ruler.integerValue ;
    _timeDetailLab.text = ruler;
    [_clockView updateTimeAnimated:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    nextStep = YES;
    SMATimingMinViewController *minuteVC = (SMATimingMinViewController *)segue.destinationViewController;
    minuteVC.hour = (int)_clockView.hours;
}

@end
