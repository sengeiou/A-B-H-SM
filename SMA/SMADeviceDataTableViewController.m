//
//  SMADeviceDataTableViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADeviceDataTableViewController.h"

@interface SMADeviceDataTableViewController ()
{
    SMACalendarView *calendarView;
    NSMutableArray *spArr;
    NSMutableArray *HRArr;
    NSMutableArray *quietArr;
    NSMutableArray *sleepArr;
    UILabel *titleLab;
}
@property (nonatomic, strong) SMADatabase *dal;
@property (nonatomic, strong) NSDate *date;
@end

@implementation SMADeviceDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeMethod:YES];
//    [self updateUI];
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (NSDate *)date{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (void)initializeMethod:(BOOL)updateUi{
   
//    HRArr = [self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate];
//    NSMutableArray *sl_arr = [NSMutableArray array];
//    NSMutableDictionary *slDic = [NSMutableDictionary dictionary];
//    [slDic setObject:@"SM07" forKey:@"INDEX"];
//    [slDic setObject:@"0" forKey:@"WEB"];
//    [slDic setObject:@"1" forKey:@"WEAR"];
//    [slDic setObject:@"20161021090700" forKey:@"DATE"];
//    [slDic setObject:@"34" forKey:@"MODE"];
//    [slDic setObject:@"0" forKey:@"SOFTLY"];
//    [slDic setObject:@"0" forKey:@"STRONG"];
//    [slDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
//    [sl_arr addObject:slDic];
//    
//    [[[SMADatabase alloc] init] insertSleepDataArr: sl_arr finish:^(id finish) {
//        
//    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
        HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
        quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
        sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!updateUi) {
                [self createUI];
            }
            else{
                 [self updateUI];
            }
        });
    });
   }

- (void)createUI{
    SmaBleMgr.BLdelegate = self;
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLab.text = [self dateWithYMD];
    titleLab.font = FontGothamLight(20);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLab;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)updateUI{
    SmaBleMgr.BLdelegate = self;
    if (!SmaBleMgr.syncing) {
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
    }
    [self.tableView reloadData];
}

- (IBAction)calendarSelector:(id)sender{
    calendarView = [[SMACalendarView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    calendarView.delegate = self;
    calendarView.date = self.date;
    [calendarView getDataDayModel:self.date];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:calendarView];
}

- (IBAction)shareselector:(id)sender{
    
}

- (UIImage *)screenshot{
     CGSize imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//你要的截图的位置
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = SMALocalizedString(@"device_pullSync");
    self.tableView.headerReleaseToRefreshText = SMALocalizedString(@"device_loosenSync");
    self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncing");
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.tableView.scrollEnabled = NO;
    if ([SmaBleMgr checkBLConnectState]) {
        if (SmaBleSend.serialNum == SmaBleMgr.sendIdentifier) {
//            self.scrolllView.headerRefreshingText = SMALocalizedString(@"device_syncing");
            SmaBleMgr.syncing = YES;
            [SmaBleSend requestCuffSportData];
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.scrollEnabled = YES;
                [self.view endEditing:YES];
                [self.tableView headerEndRefreshing];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            });
            [MBProgressHUD showError: SMALocalizedString(@"device_SP_syncWait")];
        }
    }
    else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.scrollEnabled = YES;
            [self.view endEditing:YES];
            [self.tableView headerEndRefreshing];
        });

    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMADieviceDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DATACELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMADieviceDataCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.pulldownView.hidden = NO;
            cell.roundView.progressViewClass = [SDLoopProgressView class];
            cell.roundView.progressView.progress = 0.801;
            cell.roundView.progressView.titleLab = spArr.count > 0?[[spArr firstObject] objectForKey:@"STEP"]:@"0";
            cell.titLab.text = SMALocalizedString(@"device_SP_goal");
            cell.dialLab.text = [SMAAccountTool userInfo].userGoal;
            cell.stypeLab.text = [SMAAccountTool userInfo].userGoal.intValue < 10? SMALocalizedString(@"device_SP_step"):SMALocalizedString(@"device_SP_steps");

            cell.detailsTitLab1.text = SMALocalizedString(@"device_SP_sit");
            cell.detailsTitLab2.text = SMALocalizedString(@"device_SP_walking");
            cell.detailsTitLab3.text = SMALocalizedString(@"device_SP_running");
            cell.detailsLab1.text = @"00h33m";
            cell.detailsLab2.text = @"00h33m";
            cell.detailsLab3.text = @"00h88m";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5B6B78" alpha:1],[SmaColor colorWithHexString:@"#5B6B78" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#7DBEF9" alpha:1],[SmaColor colorWithHexString:@"#7DBEF9" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#1F90EA" alpha:1],[SmaColor colorWithHexString:@"#1F90EA" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 绘制操作完成
                    cell.roundView1.image = cornerImage;
                    cell.roundView2.image = cornerImage1;
                    cell.roundView3.image = cornerImage2;
                });
                
            });
        }
        else
            if (indexPath.row == 1){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDRotationLoopProgressView class];
                cell.roundView.progressView.progress = [[[HRArr firstObject] objectForKey:@"REAT"] intValue]/200.0;
                cell.titLab.text = SMALocalizedString(@"device_HR_monitor");
                cell.dialLab.text = SMALocalizedString(@"device_HR_typeT");
                cell.stypeLab.text = @"";
                cell.detailsTitLab1.text = SMALocalizedString(@"device_HR_rest");
                cell.detailsTitLab2.text = SMALocalizedString(@"device_HR_mean");
                cell.detailsTitLab3.text = SMALocalizedString(@"device_HR_max");
                cell.detailsLab1.text = [NSString stringWithFormat:@"%dbmp",[[[quietArr lastObject] objectForKey:@"HEART"] intValue]];
                cell.detailsLab2.text = [NSString stringWithFormat:@"%dbmp",[[[HRArr lastObject] objectForKey:@"avgHR"] intValue]];
                cell.detailsLab3.text = [NSString stringWithFormat:@"%dbmp",[[[HRArr lastObject] objectForKey:@"maxHR"] intValue]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#F8A3BD" alpha:1],[SmaColor colorWithHexString:@"#F8A3BD" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#D7B7EF" alpha:1],[SmaColor colorWithHexString:@"#D7B7EF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#EA1F75" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 绘制操作完成
                        cell.roundView1.image = cornerImage;
                        cell.roundView2.image = cornerImage1;
                        cell.roundView3.image = cornerImage2;
                    });
                });
            }
            else if (indexPath.row == 2){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDPieLoopProgressView class];
                cell.roundView.progressView.progress = 0.001;
                cell.roundView.progressView.startTime = [[sleepArr objectAtIndex:5] floatValue];
                cell.roundView.progressView.endTime = [[sleepArr objectAtIndex:6] floatValue];
                cell.titLab.text = SMALocalizedString(@"device_SL_qualith");
                cell.stypeLab.text = [sleepArr objectAtIndex:1];
                cell.stypeLab.font = FontGothamLight(20);
                cell.stypeLab.textColor = [SmaColor colorWithHexString:@"#2CCB6F" alpha:1];
                cell.dialLab.attributedText = [sleepArr objectAtIndex:0];
                cell.detailsTitLab1.text = SMALocalizedString(@"device_SL_deep");
                cell.detailsTitLab2.text = SMALocalizedString(@"device_SL_light");
                cell.detailsTitLab3.text = SMALocalizedString(@"device_SL_awake");
                cell.detailsLab1.attributedText = [sleepArr objectAtIndex:2];
                cell.detailsLab2.attributedText = [sleepArr objectAtIndex:3];
                cell.detailsLab3.attributedText = [sleepArr objectAtIndex:4];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#8DE3BF" alpha:1],[SmaColor colorWithHexString:@"#8DE3BF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#00C6AE" alpha:1],[SmaColor colorWithHexString:@"#00C6AE" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#2CCB6F" alpha:1],[SmaColor colorWithHexString:@"#2CCB6F" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 绘制操作完成
                        cell.roundView1.image = cornerImage;
                        cell.roundView2.image = cornerImage1;
                        cell.roundView3.image = cornerImage2;
                    });
                    
                });
            }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SMASportDetailViewController *spDetailVC = [[SMASportDetailViewController alloc] init];
        spDetailVC.hidesBottomBarWhenPushed=YES;
        spDetailVC.date = self.date;
        [self.navigationController pushViewController:spDetailVC animated:YES];
    }
    else if (indexPath.row == 1){
        SMAHRDetailViewController *hrDetailVC = [[SMAHRDetailViewController alloc] init];
        hrDetailVC.hidesBottomBarWhenPushed=YES;
        hrDetailVC.date = self.date;
        [self.navigationController pushViewController:hrDetailVC animated:YES];

    }
    else{
        SMASleepDetailViewController *slDetailVC = [[SMASleepDetailViewController alloc] init];
        slDetailVC.hidesBottomBarWhenPushed=YES;
        slDetailVC.date = self.date;
        [self.navigationController pushViewController:slDetailVC animated:YES];
    }
}

#pragma mark *******BLConnectDelegate

- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    if (mode == CUFFSLEEPDATA) {
        self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncSucc");
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
            HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
            quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
            sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
        });
    }
}

- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode{
    if (mode == CUFFSPORTDATA || mode == CUFFSLEEPDATA || mode == CUFFHEARTRATE) {
        self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncFail");
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
            HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
            quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
            sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
        });
    }
}

#pragma mark *******calenderDelegate
- (void)didSelectDate:(NSDate *)date{
    self.date = date;
    titleLab.text = [self dateWithYMD];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
        HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
        quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
        sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
//    NSLog(@"date==%@",self.date.yyyyMMddNoLineWithDate);
}

- (NSString *)dateWithYMD{
    NSString *selfStr;
    if ([[NSDate date].yyyyMMddNoLineWithDate isEqualToString:self.date.yyyyMMddNoLineWithDate]) {
        selfStr = SMALocalizedString(@"device_todate");
    }
    else {
        selfStr= self.date.yyyyMMddByLineWithDate;
    }
    return selfStr;
}

- (NSMutableArray *)screeningSleepData:(NSMutableArray *)sleepData{
    NSArray * arr = [sleepData sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        if ([obj1[@"TIME"] intValue]<[obj2[@"TIME"] intValue]) {
            return NSOrderedAscending;
        }
        
        else if ([obj1[@"TIME"] intValue]==[obj2[@"TIME"] intValue])
            
            return NSOrderedSame;
        
        else
            
            return NSOrderedDescending;
        
    }];
    NSMutableArray *sortArr = [arr mutableCopy];
    if (sortArr.count > 2) {//筛选同一状态数据
        for (int i = 0; i< sortArr.count-1; i++) {
            NSDictionary *obj1 = [sortArr objectAtIndex:i];
            NSDictionary *obj2 = [sortArr objectAtIndex:i+1];
            if ([obj1[@"TYPE"] intValue] == [obj2[@"TYPE"] intValue]) {
                [sortArr removeObjectAtIndex:i+1];
                i--;
            }
        }
    }
    
    if (sortArr.count > 2) {//筛选同一时间数据
        for (int i = 0; i< sortArr.count-1; i++) {
            NSDictionary *obj1 = [sortArr objectAtIndex:i];
            NSDictionary *obj2 = [sortArr objectAtIndex:i+1];
            if ([obj1[@"TIME"] intValue] == [obj2[@"TIME"] intValue]) {
                [sortArr removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    int soberAmount=0;//清醒时间
    int simpleSleepAmount=0;//浅睡眠时长
    int deepSleepAmount=0;//深睡时长
    int prevType=2;//上一类型
    int prevTime=0;//上一时间点
    /* 	1-3深睡到未睡---深睡时间
     *   2-1清醒到深睡---浅睡时间
     *   2-3清醒到未睡---浅睡时间
     *   3-2未睡到清醒---清醒时间
     */
    for (int i = 0; i < sortArr.count; i ++) {
        NSDictionary *dic = sortArr[i];
        int atTime=[dic[@"TIME"] intValue];
        int amount=atTime-prevTime;
        if (i == 0) {
            amount = 0;
        }
        if (prevType == 2) {
            simpleSleepAmount = simpleSleepAmount+amount;
        }
        else if (prevType == 1){
            deepSleepAmount = deepSleepAmount+amount;
        }
        else{
            soberAmount = soberAmount+amount;
        }
        prevType = [dic[@"TYPE"] intValue];
        prevTime = [dic[@"TIME"] intValue];
    }
    NSLog(@"%d ***** %d **** %d",soberAmount,simpleSleepAmount,deepSleepAmount);
    int sleepHour = soberAmount + simpleSleepAmount + deepSleepAmount;
    int deepAmount = deepSleepAmount/60;
    NSString *sleepState=@"";
    if (sleepHour >= 9) {
        sleepState = SMALocalizedString(@"device_SL_typeT");
    }
    else if (sleepHour >= 6 && sleepHour <= 8 && deepAmount >= 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepHour >= 6 && sleepHour <= 8 && deepAmount >= 3 && deepAmount < 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepHour < 6 || deepAmount < 3){
        sleepState = SMALocalizedString(@"device_SL_typeF");
    }
    NSMutableArray *sleep = [NSMutableArray array];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",sleepHour/60],@"h",[NSString stringWithFormat:@"%d",sleepHour%60],@"m"] fontArr:@[FontGothamLight(20),FontGothamLight(15)]]];
    [sleep addObject:sleepState];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",deepSleepAmount/60],@"h",[NSString stringWithFormat:@"%d",deepSleepAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]]];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",simpleSleepAmount/60],@"h",[NSString stringWithFormat:@"%d",simpleSleepAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]]];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",soberAmount/60],@"h",[NSString stringWithFormat:@"%d",soberAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]]];
    [sleep addObject:[NSString stringWithFormat:@"%f",[[[sortArr firstObject] objectForKey:@"TIME"] floatValue]>=1320?([[[sortArr firstObject] objectForKey:@"TIME"] floatValue] - 720)/12:[[[sortArr firstObject] objectForKey:@"TIME"] floatValue]/12]];
    [sleep addObject:[NSString stringWithFormat:@"%f",[[[sortArr lastObject] objectForKey:@"TIME"] floatValue]>=1320?([[[sortArr firstObject] objectForKey:@"TIME"] floatValue] - 720)/12:[[[sortArr lastObject] objectForKey:@"TIME"] floatValue]/12]];
    return sleep;
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr fontArr:(NSArray *)fontArr{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:fontArr[0]};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:fontArr[1]};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}
@end
