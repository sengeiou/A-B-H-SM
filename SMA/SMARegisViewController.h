//
//  SMARegisViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/18.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"
#import "SMANavViewController.h"
@interface SMARegisViewController : UIViewController<SecondViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *codeLab, *countryLab;
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField, *verCodeField;
@property (nonatomic, weak) IBOutlet UIButton *emailBut, *protocolBut, *registerBut, *verCodeBut, *backBut;

@end
