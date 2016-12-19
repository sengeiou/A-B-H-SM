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
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_RU_title");
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 64, MainScreen.size.width, MainScreen.size.height - 64)  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [SmaColor colorWithHexString:@"#F7F7F7" alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [cell createUIWithData:runDetailArr[indexPath.row]];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMATrackViewController *trackVC = [[SMATrackViewController alloc] init];
    trackVC.runDic = (NSMutableDictionary *)runDetailArr[indexPath.row];
//    [self.navigationController pushViewController:trackVC animated:YES];
}

- (NSMutableArray *)getRunFullWithData:(NSMutableArray *)runData{
  NSMutableArray *detailArr = [NSMutableArray array];
    for (int i = 0; i < runData.count; i ++) {
        NSMutableDictionary *modeDic = [(NSMutableDictionary *)runData[i] mutableCopy];
        NSMutableArray *mutable = [self.dal readRunHearReatDataWithDate:[modeDic objectForKey:@"DATE"] startTime:[[modeDic objectForKey:@"STARTTIME"] intValue] endTime:[[modeDic objectForKey:@"ENDTIME"] intValue] detail:NO];
        [modeDic setObject:[self putDistanceWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue]] forKey:@"DISTANCE"];
        [modeDic setObject:[self putCalWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue]] forKey:@"CAL"];
        [modeDic setObject:[self putSpeedPerHourWithStep:[[modeDic objectForKey:@"ENDSTEP"] intValue] - [[modeDic objectForKey:@"STARTSTEP"] intValue] duration:[[modeDic objectForKey:@"ENDTIME"] intValue] - [[modeDic objectForKey:@"STARTTIME"] intValue]] forKey:@"PER"];
        [modeDic setObject:[self putTimeWithMinute:[[modeDic objectForKey:@"STARTTIME"] intValue]] forKey:@"STARTTIME"];
        [modeDic setObject:[self putTimeWithMinute:[[modeDic objectForKey:@"ENDTIME"] intValue]] forKey:@"ENDTIME"];
        [modeDic setObject:[self putHrWithReat:[[mutable firstObject] objectForKey:@"REAT"]] forKey:@"REAT"];
         [detailArr addObject:modeDic];
        NSLog(@"fwgegtrhth=j===%@",mutable);
    }
    return detailArr;
}

- (NSString *)putTimeWithMinute:(int)minute{
    NSString *hour = [NSString stringWithFormat:@"%@%d",minute/60 < 10 ? @"0":@"",minute/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",minute%60 < 10 ? @"0":@"",minute%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

- (NSMutableAttributedString *)putDistanceWithStep:(int)step{
    SMAUserInfo *user = [SMAAccountTool userInfo];
    float distance = [SMACalculate countKMWithHeigh:user.userHeight.intValue step:step];
    NSString *disStr = nil;
    NSString *unitStr = nil;
    if (user.unit) {
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

- (NSMutableAttributedString *)putSpeedPerHourWithStep:(int)step duration:(int)time{
    SMAUserInfo *user = [SMAAccountTool userInfo];
    float distance = [SMACalculate countKMWithHeigh:user.userHeight.intValue step:step];
    NSString *perStr = nil;
    NSString *unitStr = nil;
    if (user.unit) {
        perStr = [SMACalculate notRounding:[SMACalculate convertToMile:distance]/(time/60.0) afterPoint:1];
        unitStr = SMALocalizedString(@"device_RU_per_brUnit");
    }
    else{
        perStr = [SMACalculate notRounding:distance/(time/60.0) afterPoint:1];
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
