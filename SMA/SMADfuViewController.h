//
//  SMADfuViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADfuButton.h"
#import "SMADfuView.h"
@interface SMADfuViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *dfuBut;
@property (nonatomic, weak) IBOutlet UILabel *remindLab, *nowVerTitLab, *nowVerLab, *dfuVerTitLab, *dfuVerLab;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet SMADfuView *dfuView;
@end
