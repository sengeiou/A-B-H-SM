//
//  SMALoginViewcontroller.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMALoginViewcontroller.h"
#import "ACAccountManager.h"
@interface SMALoginViewcontroller ()
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
    //监听登录通知
    [SmaNotificationCenter addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[SMAthirdPartyLoginTool getinstance]];
    [SmaNotificationCenter addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[SMAthirdPartyLoginTool getinstance]];
    [SmaNotificationCenter addObserver:self selector:@selector(loginCancelled) name:kLoginCancelled object:[SMAthirdPartyLoginTool getinstance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)backSelector:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)countryCodeSelector:(id)sender{
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
    [self presentViewController:country2 animated:YES completion:^{
        ;
    }];

}

#pragma mark *******创建UI
- (void)createUI{
    [_accountField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _accountField.placeholder = SMALocalizedString(@"login_accplace");
    [_passwordField setValue:FontGothamLight(14) forKeyPath:@"_placeholderLabel.font"];
    _passwordField.placeholder = SMALocalizedString(@"login_passplace");
    _passwordField.secureTextEntry = YES;
    UIButton *eyesBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyesBut setImage:[UIImage imageNamed:@"icon_View"] forState:UIControlStateNormal];
    [eyesBut setImage:[UIImage imageNamed:@"icon_v"] forState:UIControlStateSelected];
    [eyesBut addTarget:self action:@selector(eyseSelect:) forControlEvents:UIControlEventTouchUpInside];
    eyesBut.frame = CGRectMake(0, 0, 32, 30);
    _passwordField.rightViewMode = UITextFieldViewModeAlways;
    _passwordField.rightView = eyesBut;
    [_resetPassBut setTitle:SMALocalizedString(@"login_resetpass") forState:UIControlStateNormal];
    _backBut.transform = CGAffineTransformMakeRotation(270*M_PI/180);
    [_loginBut setTitle:SMALocalizedString(@"login_login") forState:UIControlStateNormal];
    _thiPartyLab.text = SMALocalizedString(@"login_hirdParty");
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
    [MBProgressHUD showMessage:SMALocalizedString(@"login_ing")];
    SmaAnalysisWebServiceTool *webServict = [[SmaAnalysisWebServiceTool alloc] init];
    if ([_accountField.text rangeOfString:@"@"].location) {
        userAccount = _accountField.text;
    }
    else{
        userAccount = [NSString stringWithFormat:@"%@%@",[[_codeLab.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[_codeLab.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],_accountField.text];
    }
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
        user.userResHr = [dic objectForKey:@"user_rate"];
        [SMAAccountTool saveUser:user];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:SMALocalizedString(@"login_suc")];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if ([error.userInfo objectForKey:@"errorInfo"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"code:%ld %@",(long)error.code,[error.userInfo objectForKey:@"errorInfo"]]];
        }
        else if (error.code == -1001) {
            [MBProgressHUD showError:SMALocalizedString(@"alert_request_timeout")];
            NSLog(@"超时");
        }
        else if (error.code == -1009) {
            [MBProgressHUD showError:SMALocalizedString(@"alert_disconnetcted_net")];
        }
    }];
}

- (IBAction)thirdPartySelector:(UIButton *)sender{
    if (sender.tag == 102) {
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_ALBUM,
                                kOPEN_PERMISSION_ADD_ONE_BLOG,
                                kOPEN_PERMISSION_ADD_SHARE,
                                kOPEN_PERMISSION_ADD_TOPIC,
                                kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                kOPEN_PERMISSION_GET_INFO,
                                kOPEN_PERMISSION_GET_OTHER_INFO,
                                kOPEN_PERMISSION_LIST_ALBUM,
                                kOPEN_PERMISSION_UPLOAD_PIC,
                                kOPEN_PERMISSION_GET_VIP_INFO,
                                kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                nil];
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105552981" andDelegate:self];
        [_tencentOAuth authorize:permissions inSafari:NO];
    }
}

- (void)eyseSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
     [_passwordField resignFirstResponder];
    _passwordField.secureTextEntry = !_passwordField.secureTextEntry;

}

- (void)tencentDidLogin{
    NSLog(@"success");
    SmaAnalysisWebServiceTool *webServict = [[SmaAnalysisWebServiceTool alloc] init];
    [webServict acloudLoginWithOpenId:[_tencentOAuth openId] provider:ACAccountManagerLoginProviderQQ accessToken:[_tencentOAuth accessToken] success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    NSLog(@"wfwfew==%@",permissions);
    return permissions;
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
        self.view.transform = CGAffineTransformMakeTranslation(0, -150);
        // self.btnImgView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
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
        //self.btnImgView.transform = CGAffineTransformIdentity;
    }];
    
}

#pragma mark message
- (void)loginSuccessed
{
    NSLog(@"登录成功");
}

- (void)loginFailed
{
    NSLog(@"登录失败");
}

- (void) loginCancelled
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
    
//    state.text=[locale displayNameForKey:NSLocaleCountryCode value:tt];
    
}

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(NSString *)code
{
    NSLog(@"the area data：%@,", code);
    _codeLab.text = code;
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
