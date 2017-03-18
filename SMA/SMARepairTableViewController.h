//
//  SMARepairTableViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADeviceCell.h"
#import "SMADfuViewController.h"
@interface SMARepairTableViewController : UITableViewController<BLConnectDelegate>
@property (nonatomic, strong) NSString *bleCustom;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *dfuName;
@end
