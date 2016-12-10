//
//  SMASedentaryController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/26.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMASedentaryCell.h"
#import "SMASedentEditCell.h"
#import "SMATimePickView.h"
#import "AppDelegate.h"
#import "SMABottomPickView.h"
#import "SMACenterTabView.h"
@interface SMASedentaryController : UITableViewController<timePickDelegate>
@property (nonatomic, weak) IBOutlet UILabel *firBeginLab, *firBeDescLab, *firEndLab, *firEndDescLab, *secBeginLab, *secBeDescLab, *secEndnLab, *secEndDescLab, *repeatLab, *sedentaryTimeLab, *timeLab;
@property (nonatomic, weak) IBOutlet UISwitch *firSwitch, *secSwitch;
@property (nonatomic, weak) IBOutlet UIButton *monBut, *tueBut, *wedBut, *thuBut, *firBut, *satBut, *sunBut, *saveBut;
@property (nonatomic, weak) IBOutlet UITableViewCell *firTimeCell, *secTimeCell, *sedentaryCell;
@property (nonatomic ,weak) IBOutlet UIImageView *firTimeIma, *secTimeIma;
@end
