//
//  SMAPersonalViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/13.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMACalculate.h"
#import "SMAPersonalPickView.h"
#import "AppDelegate.h"
@interface SMAPersonalViewController : UITableViewController<PersonalPickDelegate>
@property (nonatomic, weak) IBOutlet UILabel *nameLab, *nameDetalLab, *genderLab, *genderDetalLab, *hightLab, *hightDetalLab, *weightLab, *weightDetalLab, *ageLab, *ageDetalLab, *unitLab, *unitDetalLab, *lanLab, *lanDetalLab;
@property (nonatomic, weak) IBOutlet UIButton *saveBut;
@end
