//
//  SMAEmailLoginViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMATabbarController.h"
#import "SMANavViewController.h"
#import "SMAFindPassViewController.h"
@interface SMAEmailLoginViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *resetPassBut, *loginBut, *backBut;
@end
