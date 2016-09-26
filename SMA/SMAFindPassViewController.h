//
//  SMAFindPassViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"

@interface SMAFindPassViewController : UIViewController<SecondViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *codeLab;
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField, *verCodeField;
@property (nonatomic, weak) IBOutlet UIButton *verCodeBut,*backBut,*findPassBut;
@end
