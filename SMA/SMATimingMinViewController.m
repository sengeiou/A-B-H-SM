//
//  SMATimingMinViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMATimingMinViewController.h"

@interface SMATimingMinViewController ()

@end

@implementation SMATimingMinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
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
    _clockView.hours = 0;
    _clockView.minutes = 30;
    _clockView.secondHandAlpha = 0;
    _clockView.hourHandAlpha = 0;
    
    _timeView.starTick = 0;
    _timeView.stopTick = 60;
    _timeView.showTick = 30;
    _timeView.alarmDelegate = self;
    _timeView.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:0.5];
    _timeView.clockRuler.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:0];
    
    self.title = SMALocalizedString(@"setting_timing_title");
    _remindLab.text = SMALocalizedString(@"setting_timing_remind");
    _timeLab.text = SMALocalizedString(@"setting_timing_minute");
    _timeDetailLab.text = @"30";
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
}

- (void)scrollDidEndDecelerating:(NSString *)ruler scrollView:(UIScrollView *)scrollview{
    _clockView.minutes = ruler.integerValue ;
    _timeDetailLab.text = ruler;
    [_clockView updateTimeAnimated:NO];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SMATimingSecondController *secondVC = (SMATimingSecondController *)segue.destinationViewController;
    secondVC.hour = _hour;
    secondVC.minute = (int)_clockView.minutes;
}

@end
