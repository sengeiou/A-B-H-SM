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
}

- (void)createUI{
   
    _nameLab.text = SMALocalizedString(@"me_perso_name");
    _nameDetalLab.text = user.userName;
    _genderLab.text = SMALocalizedString(@"me_perso_gender");
    _genderDetalLab.text = user.userSex.integerValue?SMALocalizedString(@"user_boy"):SMALocalizedString(@"user_girl");
    _hightLab.text = SMALocalizedString(@"user_hight");
    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",user.unit.intValue == 0?user.userHeight:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToInch:user.userHeight.floatValue]],user.unit.intValue == 0?SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"me_perso_inch")];
    _weightLab.text = SMALocalizedString(@"user_weight");
    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",user.unit.intValue == 0?user.userWeigh:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToLbs:user.userWeigh.floatValue]],user.unit.intValue == 0?SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs")];
    _ageLab.text = SMALocalizedString(@"user_age");
    _ageDetalLab.text = user.userAge;
    _unitLab.text = SMALocalizedString(@"me_perso_unit");
    _unitDetalLab.text = user.unit.intValue?SMALocalizedString(@"me_perso_british"):SMALocalizedString(@"me_perso_metric");
    [_saveBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
}

- (IBAction)saveSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        [SMAAccountTool saveUser:user];
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_setSuccess")];
        SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
        
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ((indexPath.section == 0 || indexPath.section == 1)) {
        if (!(indexPath.section == 0 && indexPath.row == 1)) {
            __block UITextField *titleField;
            __block UIAlertController *aler;
            aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"me_perso_name") message:nil preferredStyle:UIAlertControllerStyleAlert];
            if (indexPath.section == 1 && indexPath.row == 0) {
                aler.title = SMALocalizedString(@"user_hight");
            }
            else if (indexPath.section == 1 && indexPath.row == 1){
                aler.title = SMALocalizedString(@"user_weight");
            }
            else if (indexPath.section == 1 && indexPath.row == 2){
                aler.title = SMALocalizedString(@"user_age");
            }
            [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.font = FontGothamLight(17);
                UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
                unitLab.textAlignment = NSTextAlignmentRight;
                unitLab.font = [UIFont systemFontOfSize:11];
              if (indexPath.section == 1 && indexPath.row == 0) {
                    unitLab.text = user.unit.intValue == 0?SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"me_perso_inch");
                    textField.keyboardType= UIKeyboardTypePhonePad;
                    textField.rightView = unitLab;
                    textField.rightViewMode = UITextFieldViewModeAlways;
                }
                else if(indexPath.section == 1 && indexPath.row == 1){
                    unitLab.text = user.unit.intValue == 0?SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs");
                    textField.keyboardType= UIKeyboardTypePhonePad;
                    textField.rightView = unitLab;
                    textField.rightViewMode = UITextFieldViewModeAlways;
                }
                else if (indexPath.section == 1 && indexPath.row == 2){
                    textField.keyboardType= UIKeyboardTypePhonePad;
                }
                titleField = textField;
            }];
            UIAlertAction *confimAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_achieve") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (indexPath.section == 0 && indexPath.row == 0) {
                    _nameDetalLab.text = titleField.text;
                    user.userName = titleField.text;
                }
                else if (indexPath.section == 1 && indexPath.row == 0){
                    _hightDetalLab.text = [NSString stringWithFormat:@"%@%@",titleField.text,user.unit?SMALocalizedString(@"me_perso_cm"):SMALocalizedString(@"me_perso_inch")];
                    user.userHeight = user.unit.intValue == 0?titleField.text:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToCm:titleField.text.floatValue]];
                }
                else if (indexPath.section == 1 && indexPath.row == 1){
                    _weightDetalLab.text = [NSString stringWithFormat:@"%@%@",titleField.text,user.unit?SMALocalizedString(@"me_perso_kg"):SMALocalizedString(@"me_perso_lbs")];
                    user.userWeigh = user.unit.intValue == 0?titleField.text:[NSString stringWithFormat:@"%.0f",[SMACalculate convertToLbs:titleField.text.floatValue]];
                }
                else if (indexPath.section == 1 && indexPath.row == 2){
                    _ageDetalLab.text = titleField.text;
                    user.userAge = titleField.text;
                }
                cell.selected = NO;
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [aler addAction:cancelAction];
            [aler addAction:confimAction];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
        else if (indexPath.section == 0 && indexPath.row == 1){
            genderPickview = [[SMAPersonalPickView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) viewContentWithRow:[@[genderArr] mutableCopy]];
            genderPickview.pickDelegate = self;
            [genderPickview.pickView selectRow:!user.userSex.boolValue inComponent:0 animated:YES];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:genderPickview];
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        unitPickview = [[SMAPersonalPickView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) viewContentWithRow:[@[unitArr] mutableCopy]];
        unitPickview.pickDelegate = self;
        [unitPickview.pickView selectRow:user.unit.boolValue inComponent:0 animated:YES];
        [genderPickview.pickView selectRow:user.unit.boolValue inComponent:0 animated:YES];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:unitPickview];
    }
}

#pragma mark *******PersonalPickDelegate
- (void)pickView:(SMAPersonalPickView *)pickview didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickview == genderPickview) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.selected = NO;
        user.userSex = [NSString stringWithFormat:@"%d",!row];
        _genderDetalLab.text = user.userSex.integerValue?SMALocalizedString(@"user_boy"):SMALocalizedString(@"user_girl");
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
