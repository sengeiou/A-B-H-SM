//
//  SMARunHrViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARunHrViewController.h"

@interface SMARunHrViewController ()
{
    NSArray *hrtitArr;
    NSArray *imageArr;
    NSMutableArray *markArr;
    NSArray *sportStypeArr;
}
@end

@implementation SMARunHrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    hrtitArr = @[SMALocalizedString(@"device_RU_severe"),SMALocalizedString(@"device_RU_anaerobic"),SMALocalizedString(@"device_RU_aerobic"),SMALocalizedString(@"device_RU_burning"),SMALocalizedString(@"device_RU_Warmup")];
    imageArr = @[[UIImage imageNamed:@"heart_one"],[UIImage imageNamed:@"heart_two"],[UIImage imageNamed:@"heart_three"],[UIImage imageNamed:@"heart_four"],[UIImage imageNamed:@"herat_five"]];
    markArr = [@[@"168",@"140",@"114",@"90",@"80",@"60"] mutableCopy];
    sportStypeArr = [self movementWithHR:_hrArr];
    
}

-(void)createUI{
    self.title = SMALocalizedString(@"device_RU_stype");
    
    SMASportStypeView *stypeView = [[SMASportStypeView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height/2.5)];
    stypeView.colors = @[[SmaColor colorWithHexString:@"#ed7220" alpha:1],[SmaColor colorWithHexString:@"#ffb017" alpha:1],[SmaColor colorWithHexString:@"#36cd27" alpha:1],[SmaColor colorWithHexString:@"#16dbb4" alpha:1],[SmaColor colorWithHexString:@"#2e81ed" alpha:1]];
    stypeView.leftTits = markArr;
    stypeView.YleftTits = hrtitArr;
    stypeView.rightTits = [@[@"100%",@"90%",@"80%",@"70%",@"60%",@"50%"] mutableCopy];
    stypeView.XbottomTits = @[SMALocalizedString(@"setting_sedentary_star"),SMALocalizedString(@"setting_sedentary_end")];
    stypeView.hrDatas = _hrArr;
    //     stypeView.hrDatas = [@[@"263",@"55",@"78",@"99",@"126",@"146",@"86",@"70",@"88",@"67",@"189"] mutableCopy];
    [self.view addSubview:stypeView];
    
    UIView *hrDataView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stypeView.frame), MainScreen.size.width, 60)];
    hrDataView.backgroundColor = [SmaColor colorWithHexString:@"#ececec" alpha:1];
    NSArray *titArr = @[SMALocalizedString(@"device_RU_max"),SMALocalizedString(@"device_HR_mean"),SMALocalizedString(@"device_RU_min")];
    NSArray *rhArr = @[_runDic[@"MAXHR"],_runDic[@"AVGHR"],_runDic[@"MINHR"]];
    for (int i = 0; i < 3; i ++) {
        UILabel *lab0 = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/3 * i, 0, MainScreen.size.width/3, hrDataView.frame.size.height/2)];
        //        lab0.backgroundColor = [UIColor blueColor];
        lab0.attributedText = rhArr[i];
        lab0.textAlignment = NSTextAlignmentCenter;
        //        lab0.font = FontGothamLight(15);
        [hrDataView addSubview:lab0];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/3 *i, CGRectGetMaxY(lab0.frame), MainScreen.size.width/3 -1, hrDataView.frame.size.height/2)];
        //        lab1.backgroundColor = [UIColor yellowColor];
        lab1.text = titArr[i];
        lab1.font = FontGothamLight(15);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.numberOfLines = 0;
        [hrDataView addSubview:lab1];
    }
    [self.view addSubview:hrDataView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hrDataView.frame), MainScreen.size.width, MainScreen.size.height - stypeView.frame.size.height - hrDataView.frame.size.height)];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.imageView.image = imageArr[indexPath.row];
    cell.textLabel.font = FontGothamLight(13);
    cell.textLabel.text = hrtitArr[indexPath.row];
    cell.detailTextLabel.font = FontGothamLight(17);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",[sportStypeArr[indexPath.row] intValue],SMALocalizedString(@"setting_sedentary_minute")];
    return cell;
}

- (NSArray *)movementWithHR:(NSMutableArray *)HRarr{
    int warmUp = 0;//热身
    int burning = 0;//燃烧
    int aerobic = 0;//有氧
    int anaerobic = 0;//无氧
    int severe = 0;//剧烈
    int prevType = 0;//上一类型
    int prevTime = 0;//上一时间点
    /*
     REAT < 60 热身
     60 <= REAT < 80  热身
     80 <= REAT < 90  燃烧
     90 <= REAT < 114  有氧
     114 <= REAT < 140  无氧
     140 <= REAT < 168  剧烈
     REAT >=168 剧烈
     */
    prevTime = [[[_runDic[@"STARTTIME"] componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[_runDic[@"STARTTIME"] componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    prevType = 4;
    for (int i = 0; i < HRarr.count; i ++) {
        NSMutableDictionary *dic = [HRarr objectAtIndex:i];
        int atTime = [dic[@"TIME"] intValue];
        int amount = atTime - prevTime;
        int REAT = [[dic objectForKey:@"REAT"] intValue];
        if (prevType == 0) {
            severe = severe + amount;
        }
        if (prevType == 1) {
            anaerobic = anaerobic + amount;
        }
        if (prevType == 2) {
            aerobic = aerobic + amount;
        }
        if (prevType == 3) {
            burning = burning + amount;
        }
        if (prevType == 4) {
            warmUp = warmUp + amount;
        }
        prevTime = [dic[@"TIME"] intValue];
        prevType = [self intervalWithHR:REAT];
    }
    NSArray *arr = @[[NSNumber numberWithInt:severe],[NSNumber numberWithInt:anaerobic],[NSNumber numberWithInt:aerobic],[NSNumber numberWithInt:burning],[NSNumber numberWithInt:warmUp]];
    
    return arr;
}

- (int)intervalWithHR:(int)point{
    int interval = 0; //心率所在区间
    int hr0 = [markArr[0] intValue];
    int hr1 = [markArr[1] intValue];
    int hr2 = [markArr[2] intValue];
    int hr3 = [markArr[3] intValue];
    int hr4 = [markArr[4] intValue];
    int hr5 = [markArr[5] intValue];
    if (point > hr0) {
        interval = 0;
    }
    else if (point >= hr1 && point <= hr0) {
        interval = 0;
    }
    else if (point >= hr2 && point < hr1){
        interval = 1;
    }
    else if (point >= hr3 && point < hr2){
        interval = 2;
    }
    else if (point >= hr4 && point < hr3){
        interval = 3;
    }
    else if (point >= hr5 && point < hr4){
        interval = 4;
    }
    else if (point < hr5){
        interval = 4;
    }
    return interval;
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
