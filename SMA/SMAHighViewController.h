//
//  SMAHighViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMARulerScrollView.h"
@interface SMAHighViewController : UIViewController<smaRulerScrollDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *genderIma;
@property (nonatomic, weak) IBOutlet UILabel *highTitLab, *highLab;
@property (nonatomic, weak) IBOutlet UIButton *skipBut, *nextBut, *backBut;
@end