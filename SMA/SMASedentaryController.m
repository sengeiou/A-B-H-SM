//
//  SMASedentaryController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/26.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASedentaryController.h"

@interface SMASedentaryController ()
{
    NSArray *headerArr;
    NSString *weekString;
    int selectIndex;
    UIAlertController *aler;
    SmaSeatInfo *seat;
}
@end

@implementation SMASedentaryController

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
    seat = [SMAAccountTool seatInfo];
    if (!seat) {
        seat = [[SmaSeatInfo alloc] init];
        seat.isOpen = @"1";
        seat.repeatWeek = @"124";
        seat.beginTime0 = @"8";
        seat.endTime0 = @"21";
        seat.isOpen0 = @"0";
        seat.beginTime1 = @"9";
        seat.endTime1 = @"22";
        seat.isOpen1 = @"0";
        seat.seatValue = @"30";
        seat.stepValue = @"30";
        [SMAAccountTool saveSeat:seat];
    }
    weekString = seat.repeatWeek;
    headerArr = @[SMALocalizedString(@"setting_sedentary_time"),SMALocalizedString(@"setting_other"),SMALocalizedString(@"setting_sedentary_remind")];
}

- (void)createUI{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.title  = SMALocalizedString(@"setting_sedentary");
    _firTimeLab.text = [NSString stringWithFormat:@"%@:00 ~ %@:59",seat.beginTime0,seat.endTime0];
    _secTimeLab.text = [NSString stringWithFormat:@"%@:00 ~ %@:59",seat.beginTime1,seat.endTime1];
    _firSwitch.on = seat.isOpen0.intValue;
    _secSwitch.on = seat.isOpen1.intValue;
    [self weekStrConvert:seat.repeatWeek];
    _repeatLab.text = SMALocalizedString(@"setting_sedentary_repeat");
    _sedentaryTimeLab.text = SMALocalizedString(@"setting_sedentary_timeout");
    _timeLab.text = [NSString stringWithFormat:@"%@%@",seat.seatValue,SMALocalizedString(@"setting_sedentary_minute")];
    [_saveBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLab;
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 20)];
    headerLab.font = FontGothamLight(14);
    headerLab.text = headerArr[section];
    headerLab.textColor = [SmaColor colorWithHexString:@"#AAABAD" alpha:1];
    if (section == 2) {
        headerLab.textAlignment = NSTextAlignmentCenter;
    }
    
    return  headerLab;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == _firTimeCell) {
        _firTimeIma.transform = CGAffineTransformMakeRotation(M_PI_2);
        selectIndex = 0;
        SMATimePickView *pickView = [[SMATimePickView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) startTime:seat.beginTime0 endTime:seat.endTime0];
        pickView.pickDelegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickView];
    }
    else if (cell == _secTimeCell){
        _secTimeIma.transform = CGAffineTransformMakeRotation(M_PI_2);
        selectIndex = 1;
        SMATimePickView *pickView = [[SMATimePickView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) startTime:seat.beginTime1 endTime:seat.endTime1];
        pickView.pickDelegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickView];
    }
    else if (cell == _sedentaryCell){
        if (!aler) {
            aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_sedentary_timeout") message:SMALocalizedString(@"") preferredStyle:UIAlertControllerStyleActionSheet];
            NSArray *timeArr = @[@"15",@"30",@"60",@"120"];
            for ( int i = 0; i < 5; i ++) {
                if (i < 4) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ %@",timeArr[i],SMALocalizedString(@"setting_sedentary_minute")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        seat.seatValue = timeArr[i];
//                        seat.seatValue = @"1";
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
        }
        [self presentViewController:aler animated:YES completion:^{
            
        }];
    }
}


-(NSString *)weekStrConvert:(NSString *)weekStr{
    NSArray *week = [[SMACalculate toBinarySystemWithDecimalSystem:weekStr] componentsSeparatedByString: @","];
    NSArray *weekButArr = @[_monBut,_tueBut,_wedBut,_thuBut,_firBut,_satBut,_sunBut];
    NSString *str;
    int counts = 0;
    for (int i = 0; i < week.count; i++) {
        str = [NSString stringWithFormat:@"%@",[self stringWith:i]];
        UIButton *weekBut = (UIButton *)[weekButArr objectAtIndex:i];
        [weekBut setTitle:str forState:UIControlStateNormal];
        weekBut.selected = NO;
        if([week[i] intValue]==1)
        {
            counts ++;
            weekBut.selected = YES;
        }
    }
    return str;
}

- (IBAction)weekSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self weekStringWithIndex:sender.tag - 101 object:sender.selected?@"1":@"0"];
}

- (IBAction)weekSwitchSelector:(UISwitch *)sender{
    if (sender == _firSwitch) {
        seat.isOpen0 = [NSString stringWithFormat:@"%d",_firSwitch.on];
    }
    else{
        seat.isOpen1 = [NSString stringWithFormat:@"%d",_secSwitch.on];
    }
}

- (IBAction)saveSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        [SMAAccountTool saveSeat:seat];
        [SmaBleSend seatLongTimeInfoV2:seat];
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_setSuccess")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)weekStringWithIndex:(NSInteger)index object:(NSString *)obj{
    NSMutableArray *weekAppSplit = [[[SMACalculate toBinarySystemWithDecimalSystem:weekString] componentsSeparatedByString:@","] mutableCopy];
    [weekAppSplit replaceObjectAtIndex:index withObject:obj];
    weekString = [SMACalculate toDecimalSystemWithBinarySystem:[weekAppSplit componentsJoinedByString:@""]];
    NSLog(@"fwfewfwe===%@",weekString);
    seat.repeatWeek = weekString;
}

-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SMALocalizedString(@"setting_sedentary_mon");
            break;
        case 1:
            weekStr= SMALocalizedString(@"setting_sedentary_tue");
            break;
        case 2:
            weekStr= SMALocalizedString(@"setting_sedentary_wed");
            break;
        case 3:
            weekStr= SMALocalizedString(@"setting_sedentary_thu");
            break;
        case 4:
            weekStr= SMALocalizedString(@"setting_sedentary_fri");
            break;
        case 5:
            weekStr= SMALocalizedString(@"setting_sedentary_sat");
            break;
        default:
            weekStr= SMALocalizedString(@"setting_sedentary_sun");
    }
    return weekStr;
}

#pragma mark ******timePickDelegate
- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ( selectIndex == 0) {
        if (component == 0) {
            seat.beginTime0 = [NSString stringWithFormat:@"%ld",row + 8];
        }
        else{
            seat.endTime0 = [NSString stringWithFormat:@"%ld",row + 8];
        }
         _firTimeLab.text = [NSString stringWithFormat:@"%@:00 ~ %@:59",seat.beginTime0,seat.endTime0];
    }
    else{
        if (component == 0) {
            seat.beginTime1 = [NSString stringWithFormat:@"%ld",row + 8];
        }
        else{
            seat.endTime1 = [NSString stringWithFormat:@"%ld",row + 8];
        }
        _secTimeLab.text = [NSString stringWithFormat:@"%@:00 ~ %@:59",seat.beginTime1,seat.endTime1];
    }
}

- (void)didremoveFromSuperview{
    if ( selectIndex == 0) {
        _firTimeIma.transform = CGAffineTransformIdentity;
    }
    else{
        _secTimeIma.transform = CGAffineTransformIdentity;
    }
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
