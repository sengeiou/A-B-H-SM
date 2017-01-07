//
//  SMADeviceDataTableViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADieviceDataCell.h"
#import "UIScrollView+MJRefresh.h"
#import "SMACalendarView.h"
#import "AppDelegate.h"
#import "SMASportDetailViewController.h"
#import "SMAHRDetailViewController.h"
#import "SMASleepDetailViewController.h"
#import "SMADatabase.h"
#import "SMARemindView.h"
#import "SMAShareView.h"
@interface SMADeviceDataTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,BLConnectDelegate,calenderDelegate>

@end
