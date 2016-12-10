//
//  SMAAlarmSubViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "SMARulerScrollView.h"
#import "SMAAlarmRulerView.h"
#import "SMARepeatCell.h"
#import "SmaAlarmInfo.h"
#import "SMADateDaultionfos.h"
#import "SMACenterLabView.h"
@protocol alarmEditDelegate <NSObject>
- (void)didEditAlarmInfo:(SmaAlarmInfo *)alarmInfo;

@end

@interface SMAAlarmSubViewController : UIViewController<BEMAnalogClockDelegate,smaAlarmRulerScrollDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet BEMAnalogClockView *clockView;
@property (nonatomic, weak) IBOutlet SMAAlarmRulerView *hourView, *minView;
@property (nonatomic, weak) IBOutlet UIView *alarmView;
@property (nonatomic, weak) IBOutlet UITableView *tabView;
@property (nonatomic, strong) SmaAlarmInfo *alarmInfo;
@property (nonatomic, weak) IBOutlet UIButton *saveBut;
@property (nonatomic, weak) id<alarmEditDelegate> delegate;
@end
