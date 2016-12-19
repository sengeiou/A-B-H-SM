//
//  SMAEmailRegisViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAEmailRegisViewController.h"

@interface SMAEmailRegisViewController ()
{
    NSTimer *codeTimer;
}
@end

@implementation SMAEmailRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark *******创建UI
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
    
    _accountField.placeholder = SMALocalizedString(@"register_emalplace");
    _accountField.delegate = self;
    
    UIButton *eyesBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyesBut setImage:[UIImage imageNamed:@"icon_View"] forState:UIControlStateNormal];
    [eyesBut setImage:[UIImage imageNamed:@"icon_view_pre"] forState:UIControlStateSelected];
    [eyesBut addTarget:self action:@selector(eyseSelect:) forControlEvents:UIControlEventTouchUpInside];
    eyesBut.frame = CGRectMake(0, 0, 35, 30);
    _passwordField.rightViewMode = UITextFieldViewModeAlways;
    _passwordField.rightView = eyesBut;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.placeholder = SMALocalizedString(@"login_passplace");
    
    _verCodeField.placeholder = SMALocalizedString(@"register_code");
    _verCodeField.delegate = self;
    
//    geCodeBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    geCodeBut.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight ;//设置文字位置，现设为居右
//    [geCodeBut setTitle:SMALocalizedString(@"register_getcode") forState:UIControlStateNormal];
//    geCodeBut.titleLabel.font = FontGothamLight(10);
//    CGSize fontsize1 = [geCodeBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(11)}];
//    [geCodeBut addTarget:self action:@selector(getVerificationCodeSelector:) forControlEvents:UIControlEventTouchUpInside];
//    geCodeBut.frame = CGRectMake(0, 0, fontsize1.width>150?fontsize1.width:30, 30);
//    _verCodeField.rightView = geCodeBut;
//    _verCodeField.rightViewMode = UITextFieldViewModeAlways;
    
    [_geCodeBut setTitle:SMALocalizedString(@"register_getcode") forState:UIControlStateNormal];
    _geCodeBut.titleLabel.numberOfLines = 2;
    
    _protocolBut.titleLabel.numberOfLines = 2;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"register_protocol1") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(11),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"register_protocol2") attributes:@{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#1E6EFF" alpha:1],NSFontAttributeName:FontGothamLight(11)}];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] init];
    
    [attributed appendAttributedString:str1];
    [attributed appendAttributedString:str2];
    [_protocolBut setAttributedTitle:attributed forState:UIControlStateNormal];
    
    [_registerBut setTitle:SMALocalizedString(@"login_regis") forState:UIControlStateNormal];
}

- (IBAction)getVerificationCodeSelector:(id)sender{
    if([_accountField.text isEqualToString:@""])
    {
        [MBProgressHUD showError: SMALocalizedString(@"register_enteremail")];
        
    }else
    {
        [MBProgressHUD showMessage:SMALocalizedString(@"register_sending")];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
        SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
        [web acloudCheckExist:_accountField.text success:^(bool exist) {
            if (exist == 1) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:SMALocalizedString(@"register_accexist")];
            }
            else{
                [web acloudSendVerifiyCodeWithAccount:_accountField.text template:[preferredLang isEqualToString:@"zh"]?4:3 success:^(id result) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:SMALocalizedString(@"register_sendsucc")];
                    if (codeTimer) {
                        [codeTimer invalidate];
                        codeTimer = nil;
                    }
                    _geCodeBut.enabled = NO;
                    [_geCodeBut setTitle:@"60 S" forState:UIControlStateNormal];
                    codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(geCodeTimer) userInfo:nil repeats:YES];
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:SMALocalizedString(@"register_sendfail")];
                }];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SMALocalizedString(@"register_sendfail")];
        }];
    }
}

static int second = 60;
- (void)geCodeTimer{
    second--;
    [_geCodeBut setTitle:[NSString stringWithFormat:@"%d S",second] forState:UIControlStateNormal];
    if (second == 0) {
        second = 60;
        [_geCodeBut setTitle:SMALocalizedString(@"register_getcode") forState:UIControlStateNormal];
        _geCodeBut.enabled = YES;
        [codeTimer invalidate];
        codeTimer = nil;
    }
}

- (void)eyseSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_passwordField resignFirstResponder];
    _passwordField.secureTextEntry = !_passwordField.secureTextEntry;
}

- (IBAction)backSelector:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)protocolAgreeSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    _registerBut.enabled = !sender.selected;
}

- (IBAction)protocolSelector:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/page1000044?plg_nld=1&plg_uin=1&plg_auth=1&plg_nld=1&plg_usr=1&plg_vkey=1&plg_dev=1"]];
}

- (IBAction)registerSelector:(id)sender{
    if([_accountField.text isEqualToString:@""])
    {
        [MBProgressHUD showError:SMALocalizedString(@"register_enteremail")];
        return;
    }
    
    if([_passwordField.text isEqualToString:@""])
    {
        [MBProgressHUD showError: SMALocalizedString(@"register_regpwd")];
        return;
    }
    
    if([_verCodeField.text isEqualToString:@""])
    {
        [MBProgressHUD showError: SMALocalizedString(@"register_regcode")];
        return;
    }
    [MBProgressHUD showMessage:SMALocalizedString(@"register_beingreg")];
    SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
    [webservice acloudRegisterWithPhone:nil email:_accountField.text password:_passwordField.text verifyCode:_verCodeField.text success:^(id success) {
        SMAUserInfo *user = [[SMAUserInfo alloc] init];
        user.userID = _accountField.text;
        user.userPass = _passwordField.text;
        user.userWeigh = @"60";
        user.userHeight = @"170";
        user.userSex = @"1";
        user.userAge = @"25";
        user.userName = @"Welcome";
        user.userGoal = @"10000";
        [SMAAccountTool saveUser:user];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:SMALocalizedString(@"register_regsucceed")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             SMANavViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMANickViewController"];
            controller.leftItemHidden = YES;
//            [self presentViewController:controller animated:YES completion:nil];
             [UIApplication sharedApplication].keyWindow.rootViewController=controller;
        });

    } failure:^(NSError *erro) {
        NSLog(@"====error==%@",[erro.userInfo objectForKey:@"errorInfo"]);
        [MBProgressHUD hideHUD];
        if ([erro.userInfo objectForKey:@"errorInfo"]) {
            [MBProgressHUD showError:[self errorInfoWithSerialNumber:erro]];
        }
        else if (erro.code == -1001) {
            [MBProgressHUD showError:SMALocalizedString(@"login_timeout")];
            NSLog(@"超时");
        }
        else if (erro.code == -1009) {
            [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
        }
    }];
}

#pragma mark *****UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _accountField) {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField){
        [_verCodeField becomeFirstResponder];
    }
    else{
        [_verCodeField resignFirstResponder];
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
