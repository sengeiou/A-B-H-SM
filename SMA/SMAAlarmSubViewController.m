//
//  SMAAlarmSubViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAlarmSubViewController.h"

@interface SMAAlarmSubViewController ()

@end

@implementation SMAAlarmSubViewController

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
    if (!_alarmInfo) {
        _alarmInfo = [[SmaAlarmInfo alloc] init];
        _alarmInfo.dayFlags = @"124";
        _alarmInfo.minute = @"30";
        _alarmInfo.hour = @"08";
        _alarmInfo.day = @"1";
        _alarmInfo.mounth = @"10";
         _alarmInfo.year = @"2016";
        _alarmInfo.tagname = SMALocalizedString(@"setting_alarm_title");
    }
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_alarm_set");
//    [_saveBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
    _clockView.borderColor = [UIColor whiteColor];
    _clockView.borderWidth = 3;
    _clockView.faceBackgroundColor = [UIColor whiteColor];
    _clockView.faceBackgroundAlpha = 0.0;
    _clockView.delegate = self;
    _clockView.digitOffset = 15;
    _clockView.digitFont = FontGothamBold(16);
    _clockView.digitColor = [UIColor whiteColor];
    _clockView.enableDigit = YES;
    _clockView.hours = _alarmInfo.hour.integerValue ;
    _clockView.minutes = _alarmInfo.minute.integerValue ;
    
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = self.view.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = self.view.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_alarmView.layer insertSublayer:_gradientLayer atIndex:0];
    
    _hourView.starTick = 0;
    _hourView.stopTick = 24;
    _hourView.showTick = _alarmInfo.hour.intValue;
    _hourView.alarmDelegate = self;
    
    _minView.stopTick = 0;
    _minView.stopTick = 60;
    _minView.showTick = _alarmInfo.minute.intValue;
    _minView.alarmDelegate = self;
    
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.tableFooterView = [[UIView alloc] init];
}

- (void)scrollDidEndDecelerating:(NSString *)ruler scrollView:(UIScrollView *)scrollview{
    if (scrollview == _hourView) {
        _clockView.hours = ruler.integerValue ;
        _alarmInfo.hour = ruler.intValue<10?[NSString stringWithFormat:@"0%@",ruler]:ruler;
    }
    else if (scrollview == _minView){
        _clockView.minutes = ruler.integerValue ;
        _alarmInfo.minute = ruler.intValue<10?[NSString stringWithFormat:@"0%@",ruler]:ruler;
    }
    [_clockView updateTimeAnimated:NO];
}

- (IBAction)saveSelector:(id)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        if ([_alarmInfo.tagname dataUsingEncoding:NSUTF8StringEncoding].length > 17) {
            [MBProgressHUD showError:SMALocalizedString(@"setting_alarm_itileLong")];
            return;
        }
        if (_alarmInfo.dayFlags.intValue == 0) {
            [MBProgressHUD showError:SMALocalizedString(@"setting_alarm_repeat")];
            return;
        }
        SMADatabase *smaDal = [[SMADatabase alloc] init];
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = kCFCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        _alarmInfo.year=[NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
        _alarmInfo.mounth=[NSString stringWithFormat:@"%@%ld",(long)[dateComponent month] < 10?@"0":@"",(long)[dateComponent month]];
        _alarmInfo.day=[NSString stringWithFormat:@"%@%ld",(long)[dateComponent day] < 10?@"0":@"",(long)[dateComponent day]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyyMMdd"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];//解决不同时令相差1小时问题
        [formatter setTimeZone:GTMzone];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSTimeInterval timeIntervalSinceNow = [[formatter dateFromString:[NSString stringWithFormat:@"%@%@%@00",[formatter1 stringFromDate:now],_alarmInfo.hour.intValue<10?[NSString stringWithFormat:@"0%@",_alarmInfo.hour]:_alarmInfo.hour,_alarmInfo.minute.intValue < 10?[NSString stringWithFormat:@"0%@",_alarmInfo.minute]:_alarmInfo.minute]] timeIntervalSince1970];
        _alarmInfo.isOpen = @"1";
        _alarmInfo.isWeb = @"0";
        [smaDal insertClockInfo:_alarmInfo account:[SMAAccountTool userInfo].userID callback:^(BOOL result) {
            [self.navigationController popViewControllerAnimated:YES];
            if (_delegate && [_delegate respondsToSelector:@selector(didEditAlarmInfo:)]) {
                [self.delegate didEditAlarmInfo:_alarmInfo];
            }
        }];
        
    }
}

#pragma mark ******tableViewDealegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SMARepeatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"REPEATCELL"];
        if (!cell) {
            cell = (SMARepeatCell *) [[[NSBundle mainBundle] loadNibNamed:@"SMARepeatCell" owner:nil options:nil] lastObject];
        }
        [cell setRepeatBlock:^(NSString *weekStr){
            NSLog(@"week ==%@",weekStr);
            _alarmInfo.dayFlags = weekStr;
        }];
        [cell weekStrConvert:_alarmInfo.dayFlags];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TITLECELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TITLECELL"];
    }
    cell.textLabel.text = SMALocalizedString(@"setting_alarm_lable");
    cell.textLabel.font = FontGothamLight(16);
    cell.detailTextLabel.text = _alarmInfo.tagname;
    cell.detailTextLabel.font = FontGothamLight(14);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        __block UITextField *titleField;
//        UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_alarm_lable") message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.font = FontGothamLight(17);
//            textField.delegate = self;
//            titleField = textField;
//        }];
//        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_achieve") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            _alarmInfo.tagname = titleField.text;
//            [_tabView reloadData];
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [_tabView reloadData];
//        }];
//        [aler addAction:cancelAction];
//        [aler addAction:confimAction];
//        [self presentViewController:aler animated:YES completion:^{
//            
//        }];
        SMACenterLabView *lableView = [[SMACenterLabView alloc] initWithTitle:SMALocalizedString(@"setting_alarm_lable") buttonTitles:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_sedentary_confirm")]];
        [lableView lableDidSelectRow:^(UIButton *but, NSString *titleStr) {
            if (but.tag == 102) {
              _alarmInfo.tagname = titleStr;
            }
            [_tabView reloadData];
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:lableView];
    }
}


/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([aString dataUsingEncoding:NSUTF8StringEncoding].length > 17) {
        return NO;
    }
    return YES;
}*/
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
