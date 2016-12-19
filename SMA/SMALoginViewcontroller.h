//
//  SMALoginViewcontroller.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "SMAthirdPartyLoginTool.h"
#import "SMATabbarController.h"
#import "SMANickViewController.h"
@interface SMALoginViewcontroller : UIViewController<SecondViewControllerDelegate,TencentSessionDelegate,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *codeLab, *thiPartyLab;
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *countryBut,*resetPassBut, *backBut, *loginBut, *weChatBut, *QQBut, *weiboBut, *emailBut;
@end
