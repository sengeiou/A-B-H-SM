//
//  SMASpGoalViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/30.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMANavViewController.h"
@interface SMASpGoalViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,BLConnectDelegate>
@property (nonatomic, weak) IBOutlet UILabel *suggestLab, *approximateLab, *kmLab, *kmUnitLab, *calLab, *calUnitLab;
@property (nonatomic, weak) IBOutlet UIPickerView *goalPick;
@property (nonatomic, weak) IBOutlet UIButton *nextBut;
@property (nonatomic, assign) BOOL isSelect;
@end
