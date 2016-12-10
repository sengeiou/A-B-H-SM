//
//  SMAPairViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/18.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADeviceCell.h"
#import "AppDelegate.h"
#import "SMABindRemindView.h"
#import "SMABottomAlerView.h"
#import "SMATabbarController.h"
#import "SMANavViewController.h"
@interface SMAPairViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BLConnectDelegate,tapAlerButDelegate>
@property (nonatomic, weak) IBOutlet UILabel *ignoreLab, *nearLab;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIButton *searchBut;
@property (nonatomic, weak) IBOutlet UITableView *deviceTableView;

@end
