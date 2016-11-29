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
@property (nonatomic, weak) IBOutlet UILabel *codeLab, *countryLab;
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField, *verCodeField;
@property (nonatomic, weak) IBOutlet UIButton *verCodeBut,*backBut,*findPassBut;
@property (nonatomic, weak) IBOutlet UIView *countryView;
@property (nonatomic, weak) IBOutlet UIImageView *accountIma;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *countryTop, *accW, *accH ,*accTop;
@property (nonatomic, assign) CGFloat countryFloat;
@property (nonatomic, assign) BOOL emailFind;
@end
