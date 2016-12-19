//
//  SMAEmailLoginViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAEmailLoginViewController.h"

@interface SMAEmailLoginViewController ()

@end

@implementation SMAEmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    SMAFindPassViewController *findVC = (SMAFindPassViewController *)segue.destinationViewController;
    findVC.countryFloat = 0;
    findVC.emailFind = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)initializeMethod{
    // 监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI{
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = self.view.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = self.view.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:177/255.0 green:98/255.0 blue:252/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:84/255.0 green:211/255.0 blue:254/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [self.view.layer insertSublayer:_gradientLayer atIndex:0];
    
    [_accountField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _accountField.placeholder = SMALocalizedString(@"register_emalplace");
    [_passwordField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _passwordField.placeholder = SMALocalizedString(@"login_passplace");
    _passwordField.secureTextEntry = YES;
    _accountField.delegate = self;
    UIButton *eyesBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyesBut setImage:[UIImage imageNamed:@"icon_View"] forState:UIControlStateNormal];
    [eyesBut setImage:[UIImage imageNamed:@"icon_view_pre"] forState:UIControlStateSelected];
    [eyesBut addTarget:self action:@selector(eyseSelect:) forControlEvents:UIControlEventTouchUpInside];
    eyesBut.frame = CGRectMake(0, 0, 35, 30);
    _passwordField.rightViewMode = UITextFieldViewModeAlways;
    _passwordField.rightView = eyesBut;
    _passwordField.delegate = self;
    [_resetPassBut setTitle:SMALocalizedString(@"login_resetpass") forState:UIControlStateNormal];
    [_loginBut setTitle:SMALocalizedString(@"login_login") forState:UIControlStateNormal];
    _loginBut.enabled = NO;
}

- (IBAction)backSelector:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginSelector:(id)sender{
    NSString *userAccount;
    [MBProgressHUD showMessage:SMALocalizedString(@"login_ing")];
    SmaAnalysisWebServiceTool *webServict = [[SmaAnalysisWebServiceTool alloc] init];
     userAccount = _accountField.text;
    [webServict acloudLoginWithAccount:userAccount Password:_passwordField.text success:^(id dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        [webServict acloudDownLHeadUrlWithAccount:userAccount Success:^(id result) {
            
        } failure:^(NSError *error) {
        }];
        SMAUserInfo *user = [[SMAUserInfo alloc]init];
        user.userName = [dic objectForKey:@"nickName"];
        user.userID = userAccount;
        user.userPass = _passwordField.text;
        user.userHeight = [dic objectForKey:@"hight"];
        user.userWeigh = [dic objectForKey:@"weight"];
        user.userAge = [dic objectForKey:@"age"];
        user.userSex = [dic objectForKey:@"sex"];
        user.userGoal = [dic objectForKey:@"steps_Aim"];
        user.userHeadUrl = [dic objectForKey:@"_avatar"];
        [SMAAccountTool saveUser:user];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SMATabbarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
            controller.isLogin = NO;
            NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
            NSArray *arrControllers = controller.viewControllers;
            for (int i = 0; i < arrControllers.count; i ++) {
                SMANavViewController *nav = [arrControllers objectAtIndex:i];
                nav.tabBarItem.title = itemArr[i];
            }
            [UIApplication sharedApplication].keyWindow.rootViewController=controller;
            //            [self presentViewController:controller animated:YES completion:nil];
        });
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if ([error.userInfo objectForKey:@"errorInfo"]) {
           [MBProgressHUD showError:[self errorInfoWithSerialNumber:error]];
        }
        else if (error.code == -1001) {
            [MBProgressHUD showError:SMALocalizedString(@"alert_request_timeout")];
            NSLog(@"超时");
        }
        else if (error.code == -1009) {
            [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
        }
    }];
}

- (void)eyseSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_passwordField resignFirstResponder];
    _passwordField.secureTextEntry = !_passwordField.secureTextEntry;
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    
    // 1.取出键盘的frame
    //zzzzCGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
        _backBut.hidden = YES;// 上移或者导航栏效果不理想，直接隐藏返回键
    }];
    
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
        _backBut.hidden = NO;
    }];
    
}

static bool accInt;
static bool passInt;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _accountField) {
        if (aString.length > 0) {
            accInt = YES;
        }
        else{
            accInt = NO;
        }
    } else if (textField == _passwordField) {
        if (aString.length > 0) {
            passInt = YES;
        }
        else{
            passInt = NO;
        }
    }
    if (passInt && accInt) {
        _loginBut.enabled = YES;
    }
    else{
        _loginBut.enabled = NO;
    }
    return YES;
}

- (NSString *)errorInfoWithSerialNumber:(NSError *)error{
    NSString *errStr;
    switch (error.code) {
        case 3501:
            errStr = SMALocalizedString(@"account_error_3501");
            break;
        case 3503:
            errStr = SMALocalizedString(@"account_error_3503");
            break;
        case 3505:
            errStr = SMALocalizedString(@"account_error_3505");
            break;
        case 3506:
            errStr = SMALocalizedString(@"account_error_3506");
            break;
        case 3507:
            errStr = SMALocalizedString(@"account_error_3507");
            break;
        case 3508:
            errStr = SMALocalizedString(@"account_error_3508");
            break;
        case 3509:
            errStr = SMALocalizedString(@"account_error_3509");
            break;
        default:
            errStr = [NSString stringWithFormat:@"code:%ld %@",(long)error.code,[error.userInfo objectForKey:@"errorInfo"]];
            break;
    }
    return errStr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
