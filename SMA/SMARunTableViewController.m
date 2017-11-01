//
//  SMARunTableViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARunTableViewController.h"

@interface SMARunTableViewController ()
{
    NSMutableArray *runDetailArr;
    NSMutableArray *cyclingDetailArr;
    UIButton *cyclingBut;
    UIButton *runBut;
    UILabel *line;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMARunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)initializeMethod{
    NSMutableArray *runArr = [self.dal readRunSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate];
    runDetailArr = [self getRunFullWithData:runArr];
    cyclingDetailArr = [self.dal readCylingDataWithDate:self.date.yyyyMMddNoLineWithDate];
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_RU_title");
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 64, MainScreen.size.width, MainScreen.size.height - 64)  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [SmaColor colorWithHexString:@"#F7F7F7" alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 40)];
    //    headView.backgroundColor = [UIColor greenColor];
    runBut = [UIButton buttonWithType:UIButtonTypeCustom];
    runBut.frame = CGRectMake(38, 4, 35, 35);
    runBut.selected = YES;
    [runBut setImage:[UIImage imageNamed:@"icon-run_n"] forState:UIControlStateNormal];
    [runBut setImage:[UIImage imageNamed:@"icon-run_s"] forState:UIControlStateSelected];
    [runBut addTarget:self action:@selector(selectRunMode:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:runBut];
    
    cyclingBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cyclingBut.frame = CGRectMake(CGRectGetMaxX(runBut.frame) + 60, 4, 35, 35);
    [cyclingBut setImage:[UIImage imageNamed:@"icon_ride_n"] forState:UIControlStateNormal];
    [cyclingBut setImage:[UIImage imageNamed:@"icon_ride_s"] forState:UIControlStateSelected];
    [cyclingBut addTarget:self action:@selector(selectRunMode:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cyclingBut];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5 , 44, 1.5)];
    line.backgroundColor = [SmaColor colorWithHexString:@"#5790F9" alpha:1];
    line.center = CGPointMake(runBut.center.x, line.center.y);
    [headView addSubview:line];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height , MainScreen.size.width, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.alpha = 0.2;
    [headView addSubview:line1];
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"] /*|| [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]*/){
        self.tableView.tableHeaderView = headView;
    }
}

- (void)selectRunMode:(UIButton *)sender{
    if (runBut == sender && runBut.selected == NO) {
        cyclingBut.selected = NO;
    }
    if (cyclingBut == sender && cyclingBut.selected == NO) {
        runBut.selected = NO;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        line.center = CGPointMake(sender.center.x, line.center.y);
    }];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *timelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    timelab.font = FontGothamLight(16);
    if (runDetailArr.count > 0) {
        timelab.text = [NSString stringWithFormat:@"%@.%@.%@",[[[runDetailArr firstObject] objectForKey:@"DATE"] substringToIndex:4],[[[runDetailArr firstObject] objectForKey:@"DATE"] substringWithRange:NSMakeRange(4, 2)],[[[runDetailArr firstObject] objectForKey:@"DATE"] substringWithRange:NSMakeRange(6, 2)]];
    }
    return timelab;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (cyclingBut.selected) {
        return cyclingDetailArr.count;
    }
    return runDetailArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMARunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RUNCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMARunTableViewCell" owner:self options:nil] lastObject];
    }
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (cyclingBut.selected) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 10)];
        view.backgroundColor = [UIColor clearColor];
        cell.accessoryView = view;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell createUIWithCylingData:cyclingDetailArr[indexPath.row]];
    }
    else{
        [cell createUIWithData: runDetailArr[indexPath.row]];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cyclingBut.selected) return;
    SMATrackViewController *trackVC = [[SMATrackViewController alloc] init];
    trackVC.runDic = (NSMutableDictionary *)runDetailArr[indexPath.row];
    [self.navigationController pushViewController:trackVC animated:YES];
}

- (NSMutableArray *)getRunFullWithData:(NSMutableArray *)runData{
    NSMutableArray *detailArr = [NSMutableArray array];
    for (int i = 0; i < runData.count; i ++) {
        NSMutableDictionary *modeDic = [(NSMutableDictionary *)runData[i] mutableCopy];
        NSMutableArray *mutable = [self.dal readRunHearReatDataWithDate:[modeDic objectForKey:@"DATE"] startTime:[[modeDic objectForKey:@"STARTTIME"] intValue] endTime:[[modeDic objectForKey:@"ENDTIME"] intValue] detail:NO];
        [modeDic setObject:[self putDistanceWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue]] forKey:@"DISTANCE"];
        [modeDic setObject:[self putCalWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue]] forKey:@"CAL"];
        [modeDic setObject:[self putSpeedPerHourWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue] duration:[[modeDic objectForKey:@"PRECISEEND"] doubleValue] - [[modeDic objectForKey:@"PRECISESTART"] doubleValue]] forKey:@"PER"];
        [modeDic setObject:[self putTimeWithMinute:[[modeDic objectForKey:@"PRECISESTART"] doubleValue]] forKey:@"STARTTIME"];
        [modeDic setObject:[self putTimeWithMinute:[[modeDic objectForKey:@"PRECISEEND"] doubleValue]] forKey:@"ENDTIME"];
        [modeDic setObject:[self putHrWithReat:[[mutable firstObject] objectForKey:@"REAT"]] forKey:@"REAT"];
        [detailArr addObject:modeDic];
        //      NSLog(@"fwgegtrhth=j===%@",mutable);
    }
    return detailArr;
}

- (NSString *)putTimeWithMinute:(double)millisecond{
    //    NSString *hour = [NSString stringWithFormat:@"%@%.0f",minute/3600 < 10 ? @"0":@"",minute/3600];
    //    NSString *min = [NSString stringWithFormat:@"%@%d",minute%60 < 10 ? @"0":@"",minute%60];
    NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:millisecond withFormatStr:@"HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return date;
}

- (NSMutableAttributedString *)putDistanceWithStep:(int)step{
    SMAUserInfo *user = [SMAAccountTool userInfo];
    float distance = [SMACalculate countKMWithHeigh:user.userHeight.intValue step:step];
    NSString *disStr = nil;
    NSString *unitStr = nil;
    if (user.unit.intValue) {
        disStr = [SMACalculate notRounding:[SMACalculate convertToMile:distance] afterPoint:1];
        unitStr = SMALocalizedString(@"device_SP_mile");
    }
    else{
        disStr = [SMACalculate notRounding:distance afterPoint:1];
        unitStr = SMALocalizedString(@"device_SP_km");
    }
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSAttributedString *disAtt = [[NSAttributedString alloc] initWithString:disStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    NSMutableAttributedString *disAttStr = [[NSMutableAttributedString alloc] init];
    [disAttStr appendAttributedString:disAtt];
    [disAttStr appendAttributedString:unitAtt];
    return disAttStr;
}

- (NSMutableAttributedString *)putCalWithStep:(int)step{
    SMAUserInfo *user = [SMAAccountTool userInfo];
    float cal = [SMACalculate countCalWithSex:user.userSex userWeight:user.userWeigh.intValue step:step];
    NSString *calStr = nil;
    NSString *unitStr = nil;
    
    calStr = [SMACalculate notRounding:cal afterPoint:1];
    unitStr = SMALocalizedString(@"device_SP_cal");
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSAttributedString *disAtt = [[NSAttributedString alloc] initWithString:calStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    NSMutableAttributedString *disAttStr = [[NSMutableAttributedString alloc] init];
    [disAttStr appendAttributedString:disAtt];
    [disAttStr appendAttributedString:unitAtt];
    return disAttStr;
}

- (NSMutableAttributedString *)putSpeedPerHourWithStep:(int)step duration:(double)time{
    time = time/1000.0;
    SMAUserInfo *user = [SMAAccountTool userInfo];
    NSString *distance = [SMACalculate notRounding:[SMACalculate countKMWithHeigh:user.userHeight.intValue step:step] * 1000 afterPoint:0];
    NSString *perStr = nil;
    NSString *unitStr = nil;
    if (user.unit.intValue) {
        float speed = ([SMACalculate convertToMile:distance.intValue/1000.0] * 3600)/((int)time);
        perStr = [SMACalculate notRounding:((double)round(speed *1000.0)/1000) afterPoint:2];
        unitStr = SMALocalizedString(@"device_RU_per_brUnit");
    }
    else{
        NSLog(@"fwghh===%d",(int)time);
        float speed = (distance.floatValue/1000.0 * 3600)/((int)time);
        perStr = [SMACalculate notRounding:((double)(round(speed*1000.0)/1000)) afterPoint:2];
        unitStr = SMALocalizedString(@"device_RU_per_meUnit");
    }
    
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:perStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
}

- (NSMutableAttributedString *)putHrWithReat:(NSString *)hr {
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:hr ? hr:@"0" attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:@"bpm" attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
    
}
@end

