//
//  SMAQuietHRViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmaQuietView.h"
#import "NSDate+Formatter.h"
#import "AppDelegate.h"
@interface SMAQuietHRViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,smaQuietViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *remindLab, *dateLab, *quietLab, *hisDateLab, *hisQuietLab, *nowDateLab, *nowQuietLab;
@property (nonatomic, weak) IBOutlet UITableView *quietTBView;
@property (nonatomic, weak) IBOutlet UIButton *addBut;
@property (nonatomic, strong) NSDate *date;
@end
