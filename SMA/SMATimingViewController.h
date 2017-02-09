//
//  SMATimingViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
@interface SMATimingViewController : UIViewController<BEMAnalogClockDelegate>
@property (nonatomic, weak) IBOutlet BEMAnalogClockView *clockView;
@property (nonatomic, weak) IBOutlet UILabel *remindLab, *timeLab;
@property (nonatomic, weak) IBOutlet UIButton *doneBut;
@property (nonatomic, assign) int hour, minute, second;
@end
