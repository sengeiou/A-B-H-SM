//
//  SMADeviceSetViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMACenterTabView.h"
#import "SMAWatchChangeController.h"
#import "SMASwitchScrollView.h"
@interface SMADeviceSetViewController : UITableViewController<BLConnectDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *deviceIma, *bleIma, *batteryIma, *antiLostIma, *noDistrubIma, *callIma, *smsIma, *screenIma, *sleepMonIma;
@property (nonatomic, weak) IBOutlet UIButton *antiLostBut, *noDistrubBut, *callBut, *smsBut, *screenBut, *sleepMonBut;
@property (nonatomic, weak) IBOutlet UILabel *deviceLab, *antiLostLab, *noDistrubLab, *callLab, *smsLab, *screenLab, *sleepMonLab, *sedentaryLab, *alarmLab, *HRSetLab, *vibrationLab, *backlightLab, *photoLab, *watchLab;
@property (nonatomic, weak) IBOutlet UITableViewCell *deviceCell, *switchCell, *sedentaryCell, *alarmCell, *HRSetCell,*vibrationCell, *backlightCell, *photoCell, *watchChangeCell;
@property (nonatomic, strong) SMAUserInfo *userInfo;
@end
