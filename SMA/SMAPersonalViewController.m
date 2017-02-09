//
//  SMAPersonalViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/13.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPersonalViewController.h"
@interface SMAPersonalViewController ()
{
    SMAUserInfo *user;
    SMAPersonalPickView *genderPickview;
    SMAPersonalPickView *unitPickview;
    NSArray *genderArr;
    NSArray *unitArr;
}
@end

@implementation SMAPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    genderArr = @[SMALocalizedString(@"user_boy"),SMALocalizedString(@"user_girl")];
    unitArr = @[SMALocalizedString(@"me_perso_metric"),SMALocalizedString(@"me_perso_british")];
    user = [SMAAccountTool userInfo];
    [self handleUserInfo];//修改用户信息以防止旧信息影响导致崩溃
}

- (void)createUI{
    self.title = SMALocalizedString(@"me_perso_title");
    _nameLab.text = SMALocalizedString(@"me_perso_name");
    _nameDetalLab.text = user.userName;
    _accountLab.text = SMALocalizedString(@"me_perso_account");
    _accDetailLab.text = user.userID;
    _genderLab.text = SMALocalizedString(@"me_perso_gender");
    _genderDetalLab.text = user.userSex.integerValue == 1 ? SMALocalizedString(@"user_boy"):SMALocalizedString(@"user_girl");
    _hightLab.text = SMALocalizedString(@"user_hight");
    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",user.unit.intValue == 0?user.userHeight:[SMACalculate convertToFt:(int)roundf([SMACalculate convertToInch:user.userHeight.floatValue])],user.unit.intValue == 0?SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"")];
    _weightLab.text = SMALocalizedString(@"user_weight");
    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",user.unit.intValue == 0?user.userWeigh:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToLbs:user.userWeigh.floatValue]],user.unit.intValue == 0?SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs")];
    _ageLab.text = SMALocalizedString(@"user_age");
    _ageDetalLab.text = user.userAge;
    _unitLab.text = SMALocalizedString(@"me_perso_unit");
    _unitDetalLab.text = user.unit.intValue?SMALocalizedString(@"me_perso_british"):SMALocalizedString(@"me_perso_metric");
//    [_saveBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
}

- (void)handleUserInfo{
    if (user.userHeight.intValue < 70) {
        user.userHeight = @"70";
    }
    if (user.userHeight.intValue > 230) {
        user.userHeight = @"230";
    }
    if (user.userWeigh.intValue < 30) {
        user.userWeigh = @"30";
    }
    if (user.userWeigh.intValue > 130) {
        user.userWeigh = @"130";
    }
    if (user.userAge.intValue < 0) {
        user.userAge = @"0";
    }
    if (user.userAge.intValue > 60) {
        user.userAge = @"60";
    }
    [SMAAccountTool saveUser:user];
}

- (IBAction)saveSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        [SMAAccountTool saveUser:user];
        NSLog(@"saveSelector===%@",[user watchUUID]);
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_setSuccess")];
        SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
        [SmaBleSend setUserMnerberInfoWithHeight:user.userHeight.intValue weight:user.userWeigh.intValue sex:user.userSex.intValue age:user.userAge.intValue];
        [webser acloudPutUserifnfo:user success:^(NSString *result) {
            
        } failure:^(NSError *erro) {
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 || section == 1 ){
        return 10;
    }
    else if (section == 2){
        return 30;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section == 0 && indexPath.row == 0)) {
        SMACenterLabView *lableView = [[SMACenterLabView alloc] initWithTitle:SMALocalizedString(@"setting_alarm_lable") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")]];
        [lableView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
            if (but.tag == 102) {
                _nameDetalLab.text = titleStr;
                user.userName = titleStr;
            }
             [self.tableView reloadData];
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:lableView];
    }
    if ((indexPath.section == 1 && indexPath.row == 0)) {
        __block NSInteger selectRow;
        SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"me_perso_gender") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:@[@[SMALocalizedString(@"user_boy"),SMALocalizedString(@"user_girl")]]];
        [pickView.pickView selectRow:!user.userSex.intValue inComponent:0 animated:NO];
        [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
            if (but.tag == 102) {
                user.userSex = [NSString stringWithFormat:@"%d",!selectRow];
                _genderDetalLab.text = user.userSex.integerValue == 1 ? SMALocalizedString(@"user_boy"):SMALocalizedString(@"user_girl");
            }
             [self.tableView reloadData];
        }];
        [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
            selectRow = row;
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickView];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY";
        NSMutableArray *ageArr = [NSMutableArray array];
        for (int i = 1; i<61; i ++) {
            [ageArr addObject:[NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - 60 + i]];
        }
        __block NSInteger selectRow = 59 - user.userAge.intValue;
        SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"user_age") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:@[ageArr]];
        [pickView.pickView selectRow:selectRow inComponent:0 animated:NO];
        [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
            if (but.tag == 102) {
                _ageDetalLab.text = [NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - [ageArr[selectRow] intValue]];
                user.userAge =  [NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - [ageArr[selectRow] intValue]];
            }
            [self.tableView reloadData];
        }];
        [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
            selectRow = row;
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickView];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (!user.unit.intValue) {
            NSMutableArray *hiArr = [NSMutableArray array];
            for (int i = 0; i < 161; i ++) {
                [hiArr addObject:[NSString stringWithFormat:@"%d",i + 70]];
            }
            __block NSInteger selectRow = user.userHeight.intValue - 70;
            SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"user_hight") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:@[hiArr,@[SMALocalizedString(@"me_perso_cm")]]];
            [pickView.pickView selectRow:selectRow inComponent:0 animated:NO];
            [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
                if (but.tag == 102) {
                    user.userHeight = [hiArr objectAtIndex:selectRow];
                    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",[hiArr objectAtIndex:selectRow],SMALocalizedString(@"me_perso_cm")];
                }
                [self.tableView reloadData];
            }];
            [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
                if (component == 0) {
                      selectRow = row;
                }
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:pickView];
        }
        else{
            NSMutableArray *unArr = [NSMutableArray array];
            NSMutableArray *unArr1 = [NSMutableArray array];
//            NSString *ftInch = [SMACalculate convertToFt:(int)roundf(inch)];
            float inch = [SMACalculate convertToInch:170];
            __block NSInteger selectRow = ((int)roundf(inch))/12;
            __block NSInteger selectRow1 = ((int)roundf(inch))%12;
            for (int i = 0; i < 12; i ++) {
                [unArr addObject:[NSString stringWithFormat:@"%d'",i]];
                [unArr1 addObject:[NSString stringWithFormat:@"%d\"",i]];
            }
            SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"user_hight") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:@[unArr,unArr1]];
            [pickView.pickView selectRow:selectRow inComponent:0 animated:NO];
            [pickView.pickView selectRow:selectRow1 inComponent:1 animated:NO];
            [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
                if (but.tag == 102) {
                    user.userHeight = [NSString stringWithFormat:@"%.0f",[SMACalculate convertToCm:selectRow * 12 + selectRow1]];
                    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",[unArr objectAtIndex:selectRow],[unArr1 objectAtIndex:selectRow1]];
                }
                [self.tableView reloadData];
            }];
            [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
                if (component == 0) {
                    selectRow = row;
                }
                else{
                    selectRow1 = row;
                }
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:pickView];
        }
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        if (user.unit.intValue == 0) {
             NSMutableArray *unArr = [NSMutableArray array];
            for (int i = 0; i < 101; i ++) {
                [unArr addObject:[NSString stringWithFormat:@"%d",i + 30]];
            }
            NSMutableArray *cycleArr = [NSMutableArray array];
            for (int j = 0; j < 100; j++) {
                [cycleArr addObjectsFromArray:unArr];
            }
            NSArray *messArr = @[cycleArr,@[@".0",@".5"]];
            NSString *kgStr = [NSString stringWithFormat:@"%.1f",user.userWeigh.floatValue];
            NSArray *kgArr = [kgStr componentsSeparatedByString:@"."];
            __block NSInteger selectRow = [[kgArr firstObject] intValue] - 30;
            __block NSInteger selectRow1 = [[kgArr lastObject] intValue] < 5 ? 0:1;
            SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"user_weight") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:messArr];
            [pickView.pickView selectRow:101 * 50 + selectRow inComponent:0 animated:NO];
            [pickView.pickView selectRow:selectRow1 inComponent:1 animated:NO];
            [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
                if (but.tag == 102) {
                    user.userWeigh = [NSString stringWithFormat:@"%@%@",[[messArr objectAtIndex:0] objectAtIndex:selectRow],[[messArr objectAtIndex:1] objectAtIndex:selectRow1]];
                    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@%@",[[messArr objectAtIndex:0] objectAtIndex:selectRow],[[messArr objectAtIndex:1] objectAtIndex:selectRow1]],SMALocalizedString(@"me_perso_kg")];
                }
                [self.tableView reloadData];
            }];
            [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
                if (component == 0) {
                    selectRow = row;
                }
                else{
                    selectRow1 = row;
                }
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:pickView];

        }
        else{
            NSMutableArray *unArr = [NSMutableArray array];
            for (int i = 0; i < 231; i ++) {
                [unArr addObject:[NSString stringWithFormat:@"%d",i + 60]];
            }
            NSMutableArray *cycleArr = [NSMutableArray array];
            for (int j = 0; j < 100; j++) {
                [cycleArr addObjectsFromArray:unArr];
            }
            float lbs = [SMACalculate convertToLbs:user.userWeigh.floatValue];
            __block NSInteger selectRow = (int)roundf(lbs) - 60;
            SMACenterLabView *pickView = [[SMACenterLabView alloc] initWithPickTitle:SMALocalizedString(@"user_weight") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")] pickerMessage:@[cycleArr,@[SMALocalizedString(@"me_perso_lbs")]]];
            [pickView.pickView selectRow:50 * 231 + selectRow inComponent:0 animated:NO];
            [pickView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
                if (but.tag == 102) {
                    user.userWeigh = [NSString stringWithFormat:@"%.0f",[SMACalculate convertToKg:[[cycleArr objectAtIndex:selectRow] intValue]]];
                    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",[cycleArr objectAtIndex:selectRow],SMALocalizedString(@"me_perso_lbs")];
                }
                [self.tableView reloadData];
            }];
            [pickView pickDidSelectRow:^(NSInteger row, NSInteger component) {
                     selectRow = row;
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:pickView];

        }
    }
//    if ((indexPath.section == 0 || indexPath.section == 1)) {
//        if (!(indexPath.section == 0 && indexPath.row == 1)) {
//            __block UITextField *titleField;
//            __block UIAlertController *aler;
//            aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"me_perso_name") message:nil preferredStyle:UIAlertControllerStyleAlert];
//            if (indexPath.section == 1 && indexPath.row == 0) {
//                aler.title = SMALocalizedString(@"user_hight");
//            }
//            else if (indexPath.section == 1 && indexPath.row == 1){
//                aler.title = SMALocalizedString(@"user_weight");
//            }
//            else if (indexPath.section == 1 && indexPath.row == 2){
//                aler.title = SMALocalizedString(@"user_age");
//            }
//            [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.font = FontGothamLight(17);
//                UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
//                unitLab.textAlignment = NSTextAlignmentRight;
//                unitLab.font = [UIFont systemFontOfSize:11];
//              if (indexPath.section == 1 && indexPath.row == 0) {
//                    unitLab.text = user.unit.intValue == 0?SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"me_perso_inch");
//                    textField.keyboardType= UIKeyboardTypePhonePad;
//                    textField.rightView = unitLab;
//                    textField.rightViewMode = UITextFieldViewModeAlways;
//                }
//                else if(indexPath.section == 1 && indexPath.row == 1){
//                    unitLab.text = user.unit.intValue == 0?SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs");
//                    textField.keyboardType= UIKeyboardTypePhonePad;
//                    textField.rightView = unitLab;
//                    textField.rightViewMode = UITextFieldViewModeAlways;
//                }
//                else if (indexPath.section == 1 && indexPath.row == 2){
//                    textField.keyboardType= UIKeyboardTypePhonePad;
//                }
//                titleField = textField;
//            }];
//            UIAlertAction *confimAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_achieve") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                if (indexPath.section == 0 && indexPath.row == 0) {
//                    _nameDetalLab.text = titleField.text;
//                    user.userName = titleField.text;
//                }
//                else if (indexPath.section == 1 && indexPath.row == 0){
//                    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",titleField.text,user.unit.intValue == 0 ? SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"me_perso_inch")];
//                    user.userHeight = user.unit.intValue == 0?titleField.text:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToCm:titleField.text.floatValue]];
//                }
//                else if (indexPath.section == 1 && indexPath.row == 1){
//                    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",titleField.text,user.unit.intValue == 0 ? SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs")];
//                    user.userWeigh = user.unit.intValue == 0?titleField.text:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToLbs:titleField.text.floatValue]];
//                }
//                else if (indexPath.section == 1 && indexPath.row == 2){
//                    _ageDetalLab.text = titleField.text;
//                    user.userAge = titleField.text;
//                }
//                cell.selected = NO;
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [aler addAction:cancelAction];
//            [aler addAction:confimAction];
//            [self presentViewController:aler animated:YES completion:^{
//                
//            }];
//        }
//        else if (indexPath.section == 0 && indexPath.row == 1){
//            genderPickview = [[SMAPersonalPickView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) viewContentWithRow:[@[genderArr] mutableCopy]];
//            genderPickview.pickDelegate = self;
//            [genderPickview.pickView selectRow:!user.userSex.boolValue inComponent:0 animated:YES];
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [app.window addSubview:genderPickview];
//        }
//    }
//    else if (indexPath.section == 2 && indexPath.row == 0){
//        unitPickview = [[SMAPersonalPickView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) viewContentWithRow:[@[unitArr] mutableCopy]];
//        unitPickview.pickDelegate = self;
//        [unitPickview.pickView selectRow:user.unit.boolValue inComponent:0 animated:YES];
//        [genderPickview.pickView selectRow:user.unit.boolValue inComponent:0 animated:YES];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [app.window addSubview:unitPickview];
//    }
}

#pragma mark *******PersonalPickDelegate
- (void)pickView:(SMAPersonalPickView *)pickview didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickview == genderPickview) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.selected = NO;
        user.userSex = [NSString stringWithFormat:@"%d",!row];
        _genderDetalLab.text = user.userSex.integerValue == 1 ?SMALocalizedString(@"user_boy"):SMALocalizedString(@"user_girl");
    }
    else{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        cell.selected = NO;
        user.unit = [NSString stringWithFormat:@"%ld",(long)row];
        _unitDetalLab.text = user.unit.intValue?SMALocalizedString(@"me_perso_british"):SMALocalizedString(@"me_perso_metric");
        [self createUI];
    }
}
@end
