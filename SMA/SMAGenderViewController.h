//
//  SMAGenderViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAAgeViewController.h"
@interface SMAGenderViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *nextBut, *gentlemanBut, *ladyBut;
@property (nonatomic, weak) IBOutlet UILabel *gentlemanLab, *ladyLab;
@end
