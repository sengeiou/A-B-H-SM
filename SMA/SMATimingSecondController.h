//
//  SMATimingSecondController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "SMAAlarmRulerView.h"
#import "SMATimingViewController.h"
@interface SMATimingSecondController : UIViewController<BEMAnalogClockDelegate,smaAlarmRulerScrollDelegate>
@property (nonatomic, weak) IBOutlet BEMAnalogClockView *clockView;
@property (nonatomic, weak) IBOutlet SMAAlarmRulerView *timeView;
@property (nonatomic, weak) IBOutlet UILabel *remindLab, *timeLab, *timeDetailLab;
@property (nonatomic, weak) IBOutlet UIButton *nextBut;
@property (nonatomic, assign) int hour, minute;
@end
