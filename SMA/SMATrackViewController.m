//
//  SMATrackViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATrackViewController.h"

@interface SMATrackViewController ()<MKMapViewDelegate>
{
    NSMutableArray *hrArr;
    NSMutableArray *runArr;
    SMAMKMapView *MKmapView;
    NSMutableArray *locationArr;
    SMATrackDetailView *trackview;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMATrackViewController

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

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
    hrArr = [self.dal readRunHearReatDataWithDate:[_runDic objectForKey:@"DATE"] startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]] detail:YES];
    NSDictionary *dic = [self.dal readSummaryHreatReatWithDate:[_runDic objectForKey:@"DATE"]startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]]];
    runArr = [self.dal readRunDetailDataWithDate:[_runDic objectForKey:@"DATE"] startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]]];
    [self getFullDetailViewWithHrDic:dic];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    SMADatabase *base = [[SMADatabase alloc] init];
    //    locationArr = [base readLocationDataWithDate:[self converToDtae:[[_runDic objectForKey:@"PRECISESTART"] doubleValue]]] toDate:[NSString stringWithFormat:@"%@%@%@30",[_runDic objectForKey:@"DATE"],[[[_runDic objectForKey:@"ENDTIME"] componentsSeparatedByString:@":"] firstObject],[[[_runDic objectForKey:@"ENDTIME"] componentsSeparatedByString:@":"] lastObject]]];
    locationArr = [base readLocationDataWithDate:[self converToDtae:[[_runDic objectForKey:@"PRECISESTART"] doubleValue]] toDate:[self converToDtae:[[_runDic objectForKey:@"PRECISEEND"] doubleValue]]];
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_RU_traTit");
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"icon-xinlv" highIcon:@"icon-xinlv" frame:CGRectMake(0, 0, 45, 45) target:self action:@selector(rightButton) transfrom:0];
    
    MKmapView = [[SMAMKMapView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 300)];
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [MKmapView addGestureRecognizer:mTap];
    MKmapView.pointImages = [@[[UIImage imageNamed:@"map_location_blue"],[UIImage imageNamed:@"map_location_red"]] mutableCopy];
    if (locationArr.count > 0) {
        [MKmapView drawOverlayWithPoints:[@[locationArr] mutableCopy]];
        [MKmapView addAnnotationsWithPoints:[@[[locationArr firstObject],[locationArr lastObject]] mutableCopy]];
    }
    [self.view addSubview:MKmapView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    trackview = [SMATrackDetailView initializeView];
    [trackview updateUIwithData:_runDic];
    [trackview tapPushBut:^(UIButton *pushBut) {
        NSLog(@"tapPush");
        //        SMARunHrViewController *runHRVC = [[SMARunHrViewController alloc] init];
        //        runHRVC.hrArr = hrArr;
        //        [self.navigationController pushViewController:runHRVC animated:YES];
    }];
    [trackview tapGesture:^(BOOL gesture) {
        if (gesture) {
            [UIView animateWithDuration:0.5 animations:^{
                MKmapView.frame = CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 104);
            }];
        }
        else{
            [UIView animateWithDuration:0.5 animations:^{
                MKmapView.frame = CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 300);
            }];
        }
        
    }];
    [self.view addSubview:trackview];
    
}

- (void)rightButton{
    SMARunHrViewController *runHRVC = [[SMARunHrViewController alloc] init];
    runHRVC.hrArr = hrArr;
    runHRVC.runDic = _runDic;
    [self.navigationController pushViewController:runHRVC animated:YES];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    [trackview tapAction:nil];
}

- (void)getFullDetailViewWithHrDic:(NSDictionary *)dictionary{
    NSString *runTime = [self convertRunToMin:[[_runDic objectForKey:@"PRECISEEND"] doubleValue] - [[_runDic objectForKey:@"PRECISESTART"] doubleValue]];
    [_runDic setObject:[self putPaceWithStep:[[_runDic objectForKey:@"ENDSTEP"] intValue] - [[_runDic objectForKey:@"STARTSTEP"] intValue] duration:[[_runDic objectForKey:@"PRECISEEND"] doubleValue] - [[_runDic objectForKey:@"PRECISESTART"] doubleValue]]  forKey:@"PACE"];
    [_runDic setObject:runTime forKey:@"RUNTIME"];
    [_runDic setObject:[self putHrWithReat:[NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"avgHR"] intValue]]] forKey:@"AVGHR"];
    [_runDic setObject:[self putHrWithReat:[dictionary objectForKey:@"maxHR"]] forKey:@"MAXHR"];
    [_runDic setObject:[self putHrWithReat:[dictionary objectForKey:@"minHR"]] forKey:@"MINHR"];
    
}

- (int)convertToMin:(NSString *)time{
    NSLog(@"===%@   %d",[time componentsSeparatedByString:@":"],[[[time componentsSeparatedByString:@":"] objectAtIndex:0] intValue] * 60 + [[[time componentsSeparatedByString:@":"] objectAtIndex:1] intValue]);
    return [[[time componentsSeparatedByString:@":"] objectAtIndex:0] intValue] * 60 + [[[time componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
}

- (NSString *)convertRunToMin:(double)time{
    time = time/1000;
    int hour = ((int)time)/3600;
    int minute = ((int)time - hour * 3600)/60;
    int seconds = ((int)time - hour * 3600)%60;
    return [NSString stringWithFormat:@"%@%@:%@%@:%@%@",hour > 9 ? @"":@"0",[NSString stringWithFormat:@"%d",hour], minute > 9 ? @"":@"0",[NSString stringWithFormat:@"%d",minute],seconds > 9 ? @"":@"0",[NSString stringWithFormat:@"%d",seconds]];
}

- (NSString *)converToDtae:(double)millisecond{
    NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:millisecond timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return date;
}

- (NSMutableAttributedString *)putPaceWithStep:(int)step duration:(double)time{
    time = time/1000.0;
    SMAUserInfo *user = [SMAAccountTool userInfo];
    //    float distance = [SMACalculate countKMWithHeigh:user.userHeight.intValue step:step];
    NSString *distance = [SMACalculate notRounding:[SMACalculate countKMWithHeigh:user.userHeight.intValue step:step] * 1000 afterPoint:0];
    NSString *paceStr = nil;
    NSString *unitStr = nil;
    if (user.unit.intValue) {
        int minute = ((int)time * 1000)/[[SMACalculate notRounding:[SMACalculate convertToMile:distance.intValue] afterPoint:0] intValue];
        paceStr = [NSString stringWithFormat:@"%d'%@%d\"",minute/60,minute%60 < 10 ? @"0":@"",minute%60];
        if (time == 0 || distance.intValue == 0) {
            paceStr = @"00'00\"";
        }
        unitStr = SMALocalizedString(@"device_RU_pace_brUnit");
    }
    else{
        int minute = (int)time/(distance.intValue/1000.0);
        paceStr = [NSString stringWithFormat:@"%d'%@%d\"",minute/60,minute%60 < 10 ? @"0":@"",minute%60];
        if (time == 0 || distance.intValue == 0) {
            paceStr = @"00'00\"";
        }
        unitStr = SMALocalizedString(@"device_RU_pace_meUnit");
    }
    
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:paceStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
}

- (NSMutableAttributedString *)putHrWithReat:(NSString *)hr {
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:hr ? hr:@"0" attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:@"bpm" attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
    
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
