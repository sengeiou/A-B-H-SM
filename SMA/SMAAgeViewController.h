//
//  SMAAgeViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAPickerView.h"
#import "SMAHighViewController.h"
#import "SMABottomSelView.h"

@interface SMAAgeViewController : UIViewController<tapSelectCellDelegate>
@property (nonatomic, strong) IBOutlet UILabel *ageTileLab, *ageLab;
@property (nonatomic, weak) IBOutlet UIButton *nextBut;
@property (nonatomic, strong) IBOutlet UIImageView *genderImage;
@property (nonatomic, strong) NSString *sgr;
@end
