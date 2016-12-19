//
//  SMAHeartViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAHeartViewController.h"
#import "AppDelegate.h"
@interface SMAHeartViewController ()
{
    NSMutableArray *starTarr;
    NSMutableArray *endTarr;
    SmaHRHisInfo *HRInfo;
}
@end

@implementation SMAHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)initializeMethod{
    starTarr = [NSMutableArray array];
    endTarr = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        [starTarr addObject:[NSString stringWithFormat:@"%d:00",i]];
//        [endTarr addObject:[NSString stringWithFormat:@"%d:59",i]];
    }
    for (int j = 0; j < 100; j++) {
        [endTarr addObjectsFromArray:starTarr];
    }
    HRInfo = [SMAAccountTool HRHisInfo];
    if (!HRInfo) {
        HRInfo = [[SmaHRHisInfo alloc] init];
        HRInfo.isopen0 = [NSString stringWithFormat:@"%d",1];
        HRInfo.dayFlags=@"127";//每天
        HRInfo.isopen=[NSString stringWithFormat:@"%d",1];
        HRInfo.tagname=@"30";
        HRInfo.beginhour0 = @"0";
        HRInfo.endhour0 = @"23";
        [SMAAccountTool saveHRHis:HRInfo];
    }
}

- (void)viewDidLayoutSubviews{
    //由于初始化未能实时创建相关对象，因此在此方法修改
    _titleCell.alpha = _openSwitch.on;
    _timePickCell.alpha = _openSwitch.on;
    _gapCell.alpha = _openSwitch.on;
    _saveCell.alpha = _openSwitch.on;
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_heart_title");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#FF77A6" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [_pickView selectRow:50 * 24 + [HRInfo.beginhour0 integerValue] inComponent:0 animated:NO];
    [_pickView selectRow:50 * 24 + [HRInfo.endhour0 integerValue] inComponent:1 animated:NO];
    _openSwitch.on = HRInfo.isopen0.intValue;
 
    _startLab.text = SMALocalizedString(@"setting_sedentary_star");
    _stopLab.text = SMALocalizedString(@"setting_sedentary_end");
    _startDesLab.text = SMALocalizedString(@"setting_today");
    _stopDesLab.text = SMALocalizedString(@"setting_today");
    if ([HRInfo.beginhour0 integerValue] >= [HRInfo.endhour0 integerValue]) {
     _stopDesLab.text = SMALocalizedString(@"setting_tomorrow");
    }
    
    _hrMonitorLab.text = SMALocalizedString(@"setting_heart_monitor");
    _gapLab.text = SMALocalizedString(@"setting_heart_gap");
    _timeLab.text = [NSString stringWithFormat:@"%@%@",HRInfo.tagname,SMALocalizedString(@"setting_sedentary_minute")];
    [_saveBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
}


- (IBAction)switchSelector:(UISwitch *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
       HRInfo.isopen0 = [NSString stringWithFormat:@"%d",sender.on];
        [SMAAccountTool saveHRHis:HRInfo];
        [SmaBleSend setHRWithHR:HRInfo];
        for (int i = 1; i < 5; i ++ ) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [UIView animateWithDuration:0.5 animations:^{
                    cell.alpha = sender.on;
            }];
        }
    }
    else{
        sender.on = HRInfo.isopen0.intValue;
    }
}

- (IBAction)saveSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        [SMAAccountTool saveHRHis:HRInfo];
        [SmaBleSend setHRWithHR:HRInfo];
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_setSuccess")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.0;
    }
    else if (section == 1){
        return 1.0;
    }
    else if (section == 2){
        return 5.0;
    }
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
           UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_sedentary_timeout") message:SMALocalizedString(@"") preferredStyle:UIAlertControllerStyleActionSheet];
            NSArray *timeArr = @[@"15",@"30",@"60",@"120"];
            for ( int i = 0; i < 5; i ++) {
                if (i < 4) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d %@",[timeArr[i] intValue] > 60 ? [timeArr[i] intValue]/60 : [timeArr[i] intValue],[timeArr[i] intValue] > 60 ? SMALocalizedString(@"setting_sedentary_hour") : SMALocalizedString(@"setting_sedentary_minute")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        HRInfo.tagname = timeArr[i];
                        _timeLab.text = [NSString stringWithFormat:@"%@%@",timeArr[i],SMALocalizedString(@"setting_sedentary_minute")];
                    }];
                    [aler addAction:action];
                }
                else{
                    UIAlertAction *action = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [aler addAction:action];
                }
            }
//        [self presentViewController:aler animated:YES completion:^{
//            
//        }];
        NSArray *timeArr1 = @[[NSString stringWithFormat:@"15%@",SMALocalizedString(@"setting_sedentary_minute")],[NSString stringWithFormat:@"30%@",SMALocalizedString(@"setting_sedentary_minute")],[NSString stringWithFormat:@"1%@",SMALocalizedString(@"setting_sedentary_hour")],[NSString stringWithFormat:@"2%@",SMALocalizedString(@"setting_sedentary_hour")]];
        SMACenterTabView *timeTab = [[SMACenterTabView alloc] initWithMessages:timeArr1 selectMessage:timeArr1[[self selectIndexWithMinute:HRInfo.tagname]] selName:@"icon_selected_xiinlv"];
        [timeTab tabViewDidSelectRow:^(NSIndexPath *indexPath) {
            HRInfo.tagname = timeArr[indexPath.row];
            _timeLab.text = timeArr1[indexPath.row];
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:timeTab];
    }
}

#pragma mark *******UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  endTarr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timeLab;
    if (component == 0) {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width/2, 50)];
        timeLab.font = FontGothamLight(20);
        timeLab.text = endTarr[row];
    }
    else{
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/2, 0, MainScreen.size.width/2, 50)];
        timeLab.font = FontGothamLight(20);
        timeLab.text = endTarr[row];
    }
    timeLab.textAlignment = NSTextAlignmentCenter;
//    是设置pickview的上下两条线的颜色，或者隐藏他
//    ((UIView *)[self.pickView.subviews objectAtIndex:1]).backgroundColor = [YSColor(255, 255, 255) colorWithAlphaComponent:0.5];
//    ((UIView *)[self.pickView.subviews objectAtIndex:2]).backgroundColor = [YSColor(255, 255, 255) colorWithAlphaComponent:0.5];
    return timeLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        HRInfo.beginhour0 = [NSString stringWithFormat:@"%ld",row%24];
    }
    else{
        HRInfo.endhour0 = [NSString stringWithFormat:@"%ld",row%24];
    }
    if ([HRInfo.beginhour0 integerValue] >= [HRInfo.endhour0 integerValue]) {
        _stopDesLab.text = SMALocalizedString(@"setting_tomorrow");
    }
    else{
        _stopDesLab.text = SMALocalizedString(@"setting_today");
    }
}

- (int)selectIndexWithMinute:(NSString *)minute{
    int select = 0;
    switch (HRInfo.tagname.intValue) {
        case 15:
            select = 0;
            break;
        case 30:
            select = 1;
            break;
        case 60:
            select = 2;
            break;
        case 120:
            select = 3;
            break;
        default:
            break;
    }
    return select;
}
@end
