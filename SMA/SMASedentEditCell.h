//
//  SMASedentEditCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMASedentEditCell;
typedef void (^pushButton)(SmaAlarmInfo *alarminfo);
typedef void (^deleteButton)(SmaAlarmInfo *alarminfo,SMASedentEditCell *cell);
typedef void (^openButton)(UISwitch *openSwitch , SmaAlarmInfo *alarminfo);
@interface SMASedentEditCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIButton *editBut,*deleBut,*pushBut;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *timeLab, *titleLab, *weakLab;
@property (nonatomic, weak) IBOutlet UISwitch *alarmSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *accessoryIma;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SmaAlarmInfo *alarmInfo;
@property (nonatomic, assign) BOOL edit;
@property (nonatomic, copy) pushButton pushBlock;
@property (nonatomic, copy) deleteButton deleteBlock;
@property (nonatomic, copy) openButton switchBlock;
- (void)tapSwitchBlock:(openButton) block;
@end
