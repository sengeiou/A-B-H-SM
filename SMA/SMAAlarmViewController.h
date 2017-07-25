//
//  SMAAlarmViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMASedentEditCell.h"
#import "SmaAlarmInfo.h"
#import "SMAAlarmSubViewController.h"
@interface SMAAlarmViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,alarmEditDelegate,BLConnectDelegate>
@property (nonatomic, weak) IBOutlet UITableView *alarmTView;
@property (nonatomic, weak) IBOutlet UIButton *editBut, *addBut;
@end
