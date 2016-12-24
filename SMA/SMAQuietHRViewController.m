//
//  SMAQuietHRViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAQuietHRViewController.h"

@interface SMAQuietHRViewController ()
{
    SmaQuietView *quietView;
    NSMutableArray *quietDaArr;
    int selectIdx;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMAQuietHRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)initializeMethod{
     selectIdx = -1;
    self.date = [NSDate date];
     quietDaArr = [self.dal readQuietHearReatDataWithDate:[[NSDate date] timeDifferenceWithNumbers:-10].yyyyMMddNoLineWithDate toDate:[NSDate date].yyyyMMddNoLineWithDate];
//    quietDaArr = [[[[self.dal readQuietHearReatDataWithDate:[[NSDate date] timeDifferenceWithNumbers:-10].yyyyMMddNoLineWithDate toDate:[NSDate date].yyyyMMddNoLineWithDate] reverseObjectEnumerator] allObjects] mutableCopy];
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_HR_quiet");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#FF77A6" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    _quietTBView.delegate = self;
    _quietTBView.dataSource = self;
    _quietTBView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0); // 设置端距，这里表示separator离左边和右边均80像素
    _quietTBView.tableFooterView = [[UIView alloc] init];
    _quietTBView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dateLab.text = SMALocalizedString(@"device_HR_quietNowData");
    _quietLab.text = SMALocalizedString(@"device_HR_quiet");
    _hisDateLab.text = SMALocalizedString(@"device_HR_quietHisData");
    _hisQuietLab.text = SMALocalizedString(@"device_HR_quiet");
    _remindLab.text = SMALocalizedString(@"device_HR_quietRemind");
    
    quietView = [[SmaQuietView alloc] initWithFrame:self.view.frame];
    [quietView createUIWithAndiord];
    quietView.hidden = YES;
    quietView.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:quietView];
//    [self.view addSubview:quietView];
    [self updateUI];
}

- (void)updateUI{
    NSDictionary *hrDic = [quietDaArr firstObject];
    NSString *date = hrDic[@"DATE"];
    if ([date isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        [_addBut setImage:nil forState:UIControlStateNormal];
        [_addBut setTitle:@"" forState:UIControlStateNormal];
        
        _nowDateLab.text  = [SMADateDaultionfos stringFormmsecIntervalSince1970:[hrDic[@"ID"] doubleValue] withFormatStr:@"yyyy.MM.dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        _nowQuietLab.text = [NSString stringWithFormat:@"%@bpm",hrDic[@"HEART"]];
    }
    else{
        [_addBut setImage:[UIImage imageNamed:@"add_watch"] forState:UIControlStateNormal];
        [_addBut setTitle:SMALocalizedString(@"device_HR_quietAdd") forState:UIControlStateNormal];
        _nowDateLab.text  = @"";
        _nowQuietLab.text = @"";
    }
}

- (IBAction)addSelector:(id)sender{
    NSDictionary *hrDic = [quietDaArr firstObject];
    NSString *date = hrDic[@"DATE"];
    if ([date isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        NSDictionary *hrDic = [quietDaArr firstObject];
        quietView.hidden = NO;
        quietView.confirmBut.selected = NO;
        quietView.dateLab.text = [NSDate date].yyyyMMddSlashWithDate;
        quietView.quietField.text = hrDic[@"HEART"];
        quietView.titleLab.text = SMALocalizedString(@"device_HR_chanQuiet");
    }
    else{
        quietView.hidden = NO;
        quietView.confirmBut.selected = NO;
        quietView.dateLab.text = [NSDate date].yyyyMMddSlashWithDate;
        quietView.quietField.text =@"";
        quietView.titleLab.text = SMALocalizedString(@"device_HR_addQuiet");
    }
}

#pragma mark ********UITitableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *hrDic = [quietDaArr firstObject];
    NSString *date = hrDic[@"DATE"];
    if ([date isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        return quietDaArr.count - 1;
    }
    return quietDaArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUIETCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QUIETCELL"];
    }
    NSDictionary *hrDic = [quietDaArr firstObject];
    NSString *date = hrDic[@"DATE"];
    int add = 0;
    if ([date isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        add ++;
    }
    NSString *text = [SMADateDaultionfos stringFormmsecIntervalSince1970:[[quietDaArr[indexPath.row + add] objectForKey:@"ID"] doubleValue] withFormatStr:@"yyyy.MM.dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    cell.textLabel.text = text;
    cell.textLabel.font = FontGothamLight(16);
    cell.textLabel.textColor = [SmaColor colorWithHexString:@"#2A3137" alpha:1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%dbpm",[[[quietDaArr objectAtIndex:indexPath.row + add] objectForKey:@"HEART"] intValue]];
    cell.detailTextLabel.font = FontGothamLight(16);
    cell.detailTextLabel.textColor = [SmaColor colorWithHexString:@"#2A3137" alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    selectIdx = (int)indexPath.row;
//    quietView.hidden = NO;
//    quietView.confirmBut.selected = YES;
//    quietView.quietField.text = [[quietDaArr objectAtIndex:indexPath.row] objectForKey:@"HEART"];
//    quietView.unitLab.text = @"bpm";
}

#pragma mark *******QuietView*******
- (void)cancelWithBut:(UIButton *)sender{
    [quietView.quietField resignFirstResponder];
    quietView.hidden = YES;
}

- (void)confirmWithBut:(UIButton *)sender{
    if (!sender.selected) {
        if (quietView.quietField && ![quietView.quietField.text isEqualToString:@""]) {
            if (selectIdx>=0) {
                [self.dal deleteQuietHearReatDataWithDate:[[quietDaArr objectAtIndex:selectIdx] objectForKey:@"DATE"] time:[[quietDaArr objectAtIndex:selectIdx] objectForKey:@"TIME"]];
                [quietDaArr removeObjectAtIndex:selectIdx];
            }
            NSString *dateNow = [self.date yyyyMMddHHmmSSNoLineWithDate];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dateNow,@"DATE",quietView.quietField.text,@"HEART",@"SMA",@"INDEX",@"0",@"WEB",@"1",@"HRMODE",[SMAAccountTool userInfo].userID,@"USERID", nil];
                NSMutableArray *hrArr = [NSMutableArray arrayWithObject:dic];
            [self.dal insertQuietHRDataArr:hrArr finish:^(id finish) {
                
            }];
           
            NSString *moment = [SMADateDaultionfos minuteFormDate:dateNow];
            for (NSDictionary *diction in quietDaArr) {
                if ([self.date.yyyyMMddNoLineWithDate isEqualToString:[diction objectForKey:@"DATE"]]) {
                    NSInteger fontInt = [quietDaArr indexOfObject:diction];
                    [quietDaArr removeObjectAtIndex:fontInt];
                    break;
                }
            }
             NSString *hrID = [NSString stringWithFormat:@"%.0f",[SMADateDaultionfos msecIntervalSince1970Withdate:dateNow timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]];
                NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.date.yyyyMMddNoLineWithDate,@"DATE",quietView.quietField.text,@"HEART",@"SMA",@"INDEX",moment,@"TIME",@"0",@"WEB",@"1",@"HRMODE",[SMAAccountTool userInfo].userID,@"USERID",hrID,@"ID", nil];
            [quietDaArr insertObject:dic1 atIndex:0];
            [quietView.quietField resignFirstResponder];
             quietView.hidden = YES;
            [self updateUI];
        }
        else{
            [MBProgressHUD showError:SMALocalizedString(@"hearReat_notHR")];
        }
    }
    else{
       [self.dal deleteQuietHearReatDataWithDate:[[quietDaArr objectAtIndex:selectIdx] objectForKey:@"DATE"] time:[[quietDaArr objectAtIndex:selectIdx] objectForKey:@"TIME"]];
        [quietDaArr removeObjectAtIndex:selectIdx];
        [quietView.quietField resignFirstResponder];
        quietView.hidden = YES;
        [_quietTBView reloadData];
    }
   selectIdx = -1;
}

- (void)keyboardWillShow{
    quietView.confirmBut.selected = NO;
}

- (NSDate *)getSlashDate:(NSString *)dateStr{
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    [formatter0 setDateFormat:@"yyyyMMdd"];
    return [formatter0 dateFromString:dateStr];
}

- (NSDate *)getDateWithStringDate:(NSString *)date{
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    [formatter0 setDateFormat:@"HHmmss"];
    NSString *da = [formatter0 stringFromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *theDate = [formatter dateFromString:[date stringByAppendingString:da]];
    return theDate;
}
@end
