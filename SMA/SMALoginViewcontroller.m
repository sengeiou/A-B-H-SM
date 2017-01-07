//
//  SMALoginViewcontroller.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMALoginViewcontroller.h"
#import "ACAccountManager.h"
#import "SMAthirdPartyManager.h"
#import "SMANavViewController.h"
@interface SMALoginViewcontroller (){
    NSString *LoginProvider;
}
@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@end

@implementation SMALoginViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
    //设置本地区号
    [self setTheLocalAreaCode];
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(update) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //监听登录通知
    [SmaNotificationCenter addObserver:self selector:@selector(loginSuccessed:) name:kLoginSuccessed object:[SMAthirdPartyManager sharedManager]];
    [SmaNotificationCenter addObserver:self selector:@selector(loginFailed:) name:kLoginFailed object:[SMAthirdPartyManager sharedManager]];
    [SmaNotificationCenter addObserver:self selector:@selector(loginCancelled:) name:kLoginCancelled object:[SMAthirdPartyManager sharedManager]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    //    [self.navigationController setNavigationBarHidden:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)backSelector:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)countryCodeSelector:(id)sender{
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
    [self presentViewController:country2 animated:YES completion:^{
        
    }];
    
}

- (void)update{
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark *******创建UI
- (void)createUI{
    [_accountField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _accountField.placeholder = SMALocalizedString(@"register_accplace");
    [_passwordField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _passwordField.placeholder = SMALocalizedString(@"login_passplace");
    [_emailBut setTitle:SMALocalizedString(@"login_email") forState:UIControlStateNormal];
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
    _thiPartyLab.text = SMALocalizedString(@"login_hirdParty");
    
    if (![[SMAthirdPartyLoginTool getinstance] iphoneQQInstalled]) {
        [_QQBut setImage:[UIImage imageNamed:@"icon_qq_2"] forState:UIControlStateNormal];
    }
    else{
        [_QQBut setImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
    }
    if (![[SMAthirdPartyLoginTool getinstance] isWXAppInstalled]) {
        [_weChatBut setImage:[UIImage imageNamed:@"icon_weixin_2"] forState:UIControlStateNormal];
    }
    else{
        [_weChatBut setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    }
    if (![[SMAthirdPartyLoginTool getinstance] isWXAppInstalled]) {
        [_weiboBut setImage:[UIImage imageNamed:@"icon_weibo_2"] forState:UIControlStateNormal];
    }
    else{
        [_weiboBut setImage:[UIImage imageNamed:@"icon_weibo"] forState:UIControlStateNormal];
    }
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
}

- (IBAction)loginSelector:(id)sender{
    NSString *userAccount;
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:SMALocalizedString(@"login_ing")];
    SmaAnalysisWebServiceTool *webServict = [[SmaAnalysisWebServiceTool alloc] init];
    
    //    if ([_accountField.text rangeOfString:@"@"].location) {
    //        userAccount = _accountField.text;
    //    }
    //    else{
    userAccount = [NSString stringWithFormat:@"%@%@",[[_codeLab.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[_codeLab.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],_accountField.text];
    //    }
    [webServict acloudLoginWithAccount:userAccount Password:_passwordField.text success:^(id dic) {

        [webServict acloudDownLHeadUrlWithAccount:userAccount Success:^(id result) {
            
        } failure:^(NSError *error) {
        }];
        [webServict acloudDownLDataWithAccount:userAccount callBack:^(id finish) {
//            dispatch_async(dispatch_get_main_queue(), ^{
            
//            });
            if ([finish isEqualToString:@"finish"]) {
                [SMADefaultinfos putInt:THIRDLOGIN andValue:NO];
                SMAUserInfo *user = [[SMAUserInfo alloc] init];
                
                user.userName = [dic objectForKey:@"nickName"];
                user.userID = userAccount;
                user.userPass = _passwordField.text;
                user.userHeight = [[dic objectForKey:@"hight"] intValue] ? [dic objectForKey:@"hight"]:@"170";
                user.userWeigh =  [[dic objectForKey:@"weight"] intValue] ? [dic objectForKey:@"weight"]:@"60";
                user.userAge = [[dic objectForKey:@"age"] intValue] ? [dic objectForKey:@"age"]:@"26";
                user.userSex = [[dic objectForKey:@"sex"] intValue] ? [dic objectForKey:@"sex"]:@"1";
                user.userGoal = [[dic objectForKey:@"steps_Aim"] intValue] ? [dic objectForKey:@"steps_Aim"]:@"10000";
                user.userHeadUrl = [dic objectForKey:@"_avatar"];
                [SMAAccountTool saveUser:user];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//                NSNotification *updateNot = [NSNotification notificationWithName:@"updateData" object:@{@"UPDATE":@"updateUI"}];
//                [SmaNotificationCenter postNotification:updateNot];
            }
            else{
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:SMALocalizedString(@"login_fail")];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:SMALocalizedString(@"login_fail")];
//                    [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
                });
//                SMAUserInfo *user = [[SMAUserInfo alloc] init];
//                user.userName = [dic objectForKey:@"nickName"];
//                user.userID = userAccount;
//                user.userPass = _passwordField.text;
//                user.userHeight = [[dic objectForKey:@"hight"] intValue] ? [dic objectForKey:@"hight"]:@"170";
//                user.userWeigh =  [[dic objectForKey:@"weight"] intValue] ? [dic objectForKey:@"weight"]:@"60";
//                user.userAge = [[dic objectForKey:@"age"] intValue] ? [dic objectForKey:@"age"]:@"26";
//                user.userSex = [[dic objectForKey:@"sex"] intValue] ? [dic objectForKey:@"sex"]:@"1";
//                user.userGoal = [[dic objectForKey:@"steps_Aim"] intValue] ? [dic objectForKey:@"steps_Aim"]:@"10000";
//                user.userHeadUrl = [dic objectForKey:@"_avatar"];
//                [SMAAccountTool saveUser:user];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    SMATabbarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
//                    controller.isLogin = NO;
//                    NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
//                    NSArray *arrControllers = controller.viewControllers;
//                    for (int i = 0; i < arrControllers.count; i ++) {
//                        SMANavViewController *nav = [arrControllers objectAtIndex:i];
//                        nav.tabBarItem.title = itemArr[i];
//                    }
//                    [UIApplication sharedApplication].keyWindow.rootViewController=controller;
//                });
            }
        }];

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

- (IBAction)thirdPartySelector:(UIButton *)sender{
    if (sender.tag == 101){
        if (![[SMAthirdPartyLoginTool getinstance] isWXAppInstalled]) {
            [MBProgressHUD showError:SMALocalizedString(@"login_noInstal")];
            return;
        }
        LoginProvider = ACAccountManagerLoginProviderWechat;
        [[SMAthirdPartyLoginTool getinstance] WeChatLoginController:self];
    }
    else if (sender.tag == 102) {
        if (![[SMAthirdPartyLoginTool getinstance] iphoneQQInstalled]) {
            [MBProgressHUD showError:SMALocalizedString(@"login_noInstal")];
            return;
        }
        LoginProvider = ACAccountManagerLoginProviderQQ;
        [[SMAthirdPartyLoginTool getinstance] QQlogin];
    }
    else{
        if (![[SMAthirdPartyLoginTool getinstance] isWBAppInstalled]) {
            [MBProgressHUD showError:SMALocalizedString(@"login_noInstal")];
            return;
        }
         LoginProvider = ACAccountManagerLoginProviderWeibo;
         [[SMAthirdPartyLoginTool getinstance] WeiboLogin];
    }
    
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

#pragma mark message
- (void)loginSuccessed:(NSNotification *)systemVersion
{
    NSLog(@"登录成功   %@",systemVersion.userInfo);
    SmaAnalysisWebServiceTool *webServict = [[SmaAnalysisWebServiceTool alloc] init];
    [MBProgressHUD showMessage:SMALocalizedString(@"login_ing")];
    //    [webServict acloudCheckExist:[NSString stringWithFormat:@"%@ %@",[systemVersion.userInfo objectForKey:@"LOGINTYPE"],[[[SMAthirdPartyLoginTool getinstance] oauth] openId]] success:^(bool exit) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    [webServict acloudLoginWithOpenId:systemVersion.userInfo[@"OPENID"] provider:LoginProvider accessToken:systemVersion.userInfo[@"TOKEN"] success:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
//        [webServict acloudDownLHeadUrlWithAccount:systemVersion.userInfo[@"OPENID"] Success:^(id result) {
//            
//        } failure:^(NSError *error) {
//        }];
        [SMADefaultinfos putInt:THIRDLOGIN andValue:YES];
        [webServict acloudDownFileWithsession: [result objectForKey:@"_avatar"] callBack:^(float progress, NSError *error) {
            
        } CompleteCallback:^(NSString *filePath) {
            
        }];
        if (![result objectForKey:@"nickName"] || [[result objectForKey:@"nickName"] isEqualToString:@""] /*|| [[result objectForKey:@"nickName"] isEqualToString:@"Welcome"]*/) {
            SMAUserInfo *user = [[SMAUserInfo alloc] init];
            user.userID = systemVersion.userInfo[@"OPENID"];
            user.userPass = _passwordField.text;
            user.userWeigh = @"60";
            user.userHeight = @"170";
            user.userSex = @"1";
            user.userAge = @"26";
            user.userName = @"Welcome";
            user.userGoal = @"10000";
            [SMAAccountTool saveUser:user];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SMANavViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMANickViewController"];
//                controller.leftItemHidden = YES;
                [UIApplication sharedApplication].keyWindow.rootViewController=controller;
            });
            
        }
        else{
            SMAUserInfo *user = [[SMAUserInfo alloc]init];
            user.userName = [result objectForKey:@"nickName"];
            user.userID = systemVersion.userInfo[@"OPENID"];
            user.userPass = _passwordField.text;
            user.userHeight = [result objectForKey:@"hight"];
            user.userWeigh = [result objectForKey:@"weight"];
            user.userAge = [result objectForKey:@"age"];
            user.userSex = [result objectForKey:@"sex"];
            user.userGoal = [result objectForKey:@"steps_Aim"];
            user.userHeadUrl = [result objectForKey:@"_avatar"];
            [SMAAccountTool saveUser:user];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SMATabbarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
                controller.isLogin = NO;
                NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
                NSArray *arrControllers = controller.viewControllers;
                for (int i = 0; i < arrControllers.count; i ++) {
                    SMANavViewController *nav = [arrControllers objectAtIndex:i];
                    nav.tabBarItem.title = itemArr[i];
                }
                [UIApplication sharedApplication].keyWindow.rootViewController=controller;
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if ([error.userInfo objectForKey:@"errorInfo"]) {
                [MBProgressHUD showError:[self errorInfoWithSerialNumber:error]];
            }
            else if (error.code == -1001) {
                [MBProgressHUD showError:SMALocalizedString(@"login_timeout")];
                NSLog(@"超时");
            }
            else if (error.code == -1009) {
                [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
            }
        });
    }];
    
}

- (void)loginFailed:(NSNotification *)systemVersion
{
    NSLog(@"登录失败");
}

- (void) loginCancelled:(NSNotification *)systemVersion
{
    NSLog(@"登录取消");
}

-(void)setTheLocalAreaCode
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    _codeLab.text=[NSString stringWithFormat:@"+%@",defaultCode];
    [_countryBut setTitle:[locale displayNameForKey:NSLocaleCountryCode value:tt] forState:UIControlStateNormal];
    //    state.text=[locale displayNameForKey:NSLocaleCountryCode value:tt];
    
}

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(NSString *)code
{
    NSLog(@"the area data：%@,", code);
    _codeLab.text = [NSString stringWithFormat:@"+%@",[[code componentsSeparatedByString:@","] lastObject]];
    [_countryBut setTitle:[[code componentsSeparatedByString:@","] firstObject] forState:UIControlStateNormal];
}

#pragma mark *****
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
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
