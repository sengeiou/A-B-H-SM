//
//  SMAHeartViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMACenterTabView.h"
@interface SMAHeartViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, weak) IBOutlet UILabel *hrMonitorLab, *startLab, *startDesLab, *stopLab, *stopDesLab, *gapLab, *timeLab;
@property (nonatomic, weak) IBOutlet UISwitch *openSwitch;
@property (nonatomic, weak) IBOutlet UIPickerView *pickView;
@property (nonatomic, weak) IBOutlet UIButton *saveBut;
@property (nonatomic, weak) IBOutlet UITableViewCell *timePickCell, *gapCell, *saveCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *titleCell;
@end
