//
//  SMAWeightViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/31.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADialMainView.h"
#import "SMAPickerView.h"
#import "SMANavViewController.h"
#import "SMASpGoalViewController.h"
@interface SMAWeightViewController : UIViewController<smaDialViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *nextBut;
@property (nonatomic, weak) IBOutlet UIImageView *genderIma;
@property (nonatomic, weak) IBOutlet UILabel *weightTitLab, *weightLab;
@end
