//
//  SMASpGoalViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/30.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASpGoalViewController.h"
#import "SMASelectDeviceController.h"
@interface SMASpGoalViewController ()
{
    NSMutableArray *goalArr;
    SMAUserInfo *user;
}
@end

@implementation SMASpGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeMethod{
    goalArr = [NSMutableArray array];
    for (int i = 1; i <= 100; i ++) {
        [goalArr addObject:[NSString stringWithFormat:@"%d",i * 1000]];
    }
    user = [SMAAccountTool userInfo];
}

- (void)createUI{
    self.title = SMALocalizedString(@"me_sport_goal");
    _goalPick.delegate = self;
    _goalPick.dataSource = self;
    _suggestLab.text = SMALocalizedString(@"me_goal_suggest");
    _approximateLab.text = SMALocalizedString(@"me_goal_approximate");
    _kmUnitLab.text = user.unit.intValue == 0 ? SMALocalizedString(@"device_SP_km"):SMALocalizedString(@"device_SP_mile");
    _calUnitLab.text = SMALocalizedString(@"device_SP_cal");
    [_nextBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
    [_goalPick selectRow:user.userGoal.intValue/1000 - 1 inComponent:0 animated:NO];
    _kmLab.text = [self putDisStringWithHeight:user.userHeight.floatValue setp:user.userGoal.intValue];
    _calLab.text = [self putCalStringWithSex:user.userSex userWeight:user.userWeigh.floatValue step:user.userGoal.intValue];
}

#pragma mark ******UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return goalArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 50)];
    lab.text = goalArr[row];
    lab.font = FontGothamBold(40);
    lab.textColor = [SmaColor colorWithHexString:@"#3D81EA" alpha:1];
    lab.textAlignment=NSTextAlignmentCenter;
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel *lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    lab.textColor = [SmaColor colorWithHexString:@"#3D81EA" alpha:1];
    user.userGoal = goalArr[row];
    _kmLab.text = [self putDisStringWithHeight:user.userHeight.floatValue setp:[goalArr[row] intValue]];
    _calLab.text = [self putCalStringWithSex:user.userSex userWeight:user.userWeigh.floatValue step:[goalArr[row] intValue]];
}

- (NSString *)putDisStringWithHeight:(float)height setp:(int)step{
    float disFloat = [SMACalculate countKMWithHeigh:height step:step];
    if (user.unit.intValue == 1) {
        disFloat = [SMACalculate convertToMile:disFloat];
    }
    return [SMACalculate notRounding:disFloat afterPoint:1];;
}

- (NSString *)putCalStringWithSex:(NSString *)sex userWeight:(float)weight step:(int)step{
    float calFloat = [SMACalculate countCalWithSex:sex userWeight:weight step:step];
    return [SMACalculate notRounding:calFloat afterPoint:1];
}

- (IBAction)accomplishSelector:(id)sender{
    

    if (_isSelect) {
        self.navigationController.leftItemHidden = YES;
        SMASelectDeviceController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMASelectDeviceController"];
        controller.isSelect = YES;
        [SMAAccountTool saveUser:user];
        SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
        [webser acloudPutUserifnfo:user success:^(NSString *result) {
            
        } failure:^(NSError *erro) {
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
//        controller.leftItemHidden = YES;
//        [UIApplication sharedApplication].keyWindow.rootViewController=controller;
    }
    else{
        if ([SmaBleMgr checkBLConnectState]) {
            [SMAAccountTool saveUser:user];
            SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
            [webser acloudPutUserifnfo:user success:^(NSString *result) {
                
            } failure:^(NSError *erro) {
                
            }];
            [SmaBleSend setStepNumber:user.userGoal.intValue];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
//    UITabBarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
//    [self presentViewController:controller animated:YES completion:nil];
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
