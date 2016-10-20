//
//  SMAGoalViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAAlarmRulerView.h"
@interface SMAGoalViewController : UITableViewController<smaAlarmRulerScrollDelegate>

@property (nonatomic, weak) IBOutlet SMAAlarmRulerView *ruleView;
@property (nonatomic, weak) IBOutlet UIView *rulerBackView;
@property (nonatomic, weak) IBOutlet UILabel *walkLab, *walkTimeLab, *runLab, *runTimeLab, *saveLab;
@end
