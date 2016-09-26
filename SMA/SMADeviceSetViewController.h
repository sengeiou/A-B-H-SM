//
//  SMADeviceSetViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMADeviceSetViewController : UITableViewController<BLConnectDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *deviceIma, *bleIma, *batteryIma, *antiLostIma, *noDistrubIma, *callIma, *smsIma, *screenIma, *sleepMonIma;
@property (nonatomic, weak) IBOutlet UIButton *antiLostBut, *noDistrubBut, *callBut, *smsBut, *screenBut, *sleepMonBut;
@property (nonatomic, weak) IBOutlet UILabel *deviceLab, *antiLostLab, *noDistrubLab, *callLab, *smsLab, *screenLab, *sleepMonLab, *sedentaryLab, *alarmLab, *HRSetLab, *vibrationLab, *backlightLab;
@property (nonatomic, weak) IBOutlet UITableViewCell *deviceCell, *sedentaryCell, *alarmCell, *HRSetCell,*vibrationCell, *backlightCell;
@property (nonatomic, strong) SMAUserInfo *userInfo;
@end
