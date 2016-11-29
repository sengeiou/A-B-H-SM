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
    quietDaArr = [[[[self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES] reverseObjectEnumerator] allObjects] mutableCopy];
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_HR_quiet");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#FF77A6" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    _quietTBView.delegate = self;
    _quietTBView.dataSource = self;
    _quietTBView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0); // 设置端距，这里表示separator离左边和右边均80像素
    _quietTBView.tableFooterView = [[UIView alloc] init];
    _quietTBView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    quietView = [[SmaQuietView alloc] initWithFrame:self.view.frame];
    [quietView createUI];
    quietView.hidden = YES;
    quietView.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:quietView];
//    [self.view addSubview:quietView];
}

- (IBAction)addSelector:(id)sender{
    quietView.hidden = NO;
    quietView.confirmBut.selected = NO;
    quietView.dateLab.text = self.date.yyyyMMddSlashWithDate;
    quietView.quietField.text =@"";
}

#pragma mark ********UITitableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return quietDaArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUIETCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QUIETCELL"];
    }
    cell.textLabel.text = [[self getSlashDate:[[quietDaArr objectAtIndex:indexPath.row] objectForKey:@"DATE"]] yyyyMMddSlashWithDate];
    cell.textLabel.font = FontGothamLight(16);
    cell.textLabel.textColor = [SmaColor colorWithHexString:@"#2A3137" alpha:1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%dbmp",[[[quietDaArr objectAtIndex:indexPath.row] objectForKey:@"HEART"] intValue]];
    cell.detailTextLabel.font = FontGothamLight(16);
    cell.detailTextLabel.textColor = [SmaColor colorWithHexString:@"#2A3137" alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIdx = (int)indexPath.row;
    quietView.hidden = NO;
    quietView.confirmBut.selected = YES;
    quietView.quietField.text = [[quietDaArr objectAtIndex:indexPath.row] objectForKey:@"HEART"];
    quietView.unitLab.text = @"bpm";
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

                [self.dal insertHRDataArr:hrArr finish:^(id finish) {
                    
                }];
           
            NSString *moment = [SMADateDaultionfos minuteFormDate:dateNow];
            for (NSDictionary *diction in quietDaArr) {
                if ([moment isEqualToString:[diction objectForKey:@"TIME"]]) {
                    NSInteger fontInt = [quietDaArr indexOfObject:diction];
                    [quietDaArr removeObjectAtIndex:fontInt];
                    break;
                }
            }
                NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.date.yyyyMMddNoLineWithDate,@"DATE",quietView.quietField.text,@"HEART",@"SMA",@"INDEX",moment,@"TIME",@"0",@"WEB",@"1",@"HRMODE",[SMAAccountTool userInfo].userID,@"USERID", nil];
                [quietDaArr insertObject:dic1 atIndex:0];

            [quietView.quietField resignFirstResponder];
             quietView.hidden = YES;
            [_quietTBView reloadData];
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
