//
//  SMATimingViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMATimingViewController.h"

@interface SMATimingViewController ()

@end

@implementation SMATimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
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
    _clockView.hours = _hour;
    _clockView.minutes = _minute;
    _clockView.seconds = _second;
    
    self.title = SMALocalizedString(@"setting_timing_title");
    _remindLab.text = SMALocalizedString(@"setting_timing_confirm");
    _timeLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d ",_hour],SMALocalizedString(@"setting_timing_hour"),[NSString stringWithFormat:@" %@%d ",_minute < 10 ? @"0":@"",_minute],SMALocalizedString(@"setting_timing_minute"),[NSString stringWithFormat:@" %@%d ",_second < 10 ? @"0":@"",_second],SMALocalizedString(@"setting_seconds")] fontArr:@[FontGothamLight(28),FontGothamLight(18)]];
//    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]) {
    if ([SmaBleMgr.peripheral.name isEqualToString:@"SMA-A2"]) {
        _clockView.secondHandAlpha = 0;
        _timeLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d ",_hour],SMALocalizedString(@"setting_timing_hour"),[NSString stringWithFormat:@" %@%d ",_minute < 10 ? @"0":@"",_minute],SMALocalizedString(@"setting_timing_minute")] fontArr:@[FontGothamLight(28),FontGothamLight(18)]];
    }
    [_doneBut setTitle:SMALocalizedString(@"setting_timing_done") forState:UIControlStateNormal];
}

- (IBAction)setTimingSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        [SmaBleSend setPointerHour:_hour minute:_minute second:_second];
        [SmaBleSend setSystemTiming];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr fontArr:(NSArray *)fontArr{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:fontArr[0]};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:fontArr[1]};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}
@end
