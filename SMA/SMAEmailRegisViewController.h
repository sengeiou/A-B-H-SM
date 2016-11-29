//
//  SMAEmailRegisViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMANavViewController.h"
@interface SMAEmailRegisViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *accountField, *passwordField, *verCodeField;
@property (nonatomic, weak) IBOutlet UIButton  *geCodeBut, *protocolBut, *registerBut;
@end
