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
    UILabel *titleLab;
}
@property (nonatomic, strong) SMADatabase *dal;
@property (nonatomic, strong) NSDate *date;
@end

@implementation SMADeviceDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeMethod];
    [self updateUI];
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

- (void)initializeMethod{
    spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
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
  HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
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
                cell.detailsLab1.text = @"228bpm";
                cell.detailsLab2.text = [NSString stringWithFormat:@"%dbmp",[[[HRArr lastObject] objectForKey:@"avgHR"] intValue]];
                cell.detailsLab3.text = [NSString stringWithFormat:@"%@bmp",[[HRArr lastObject] objectForKey:@"maxHR"]];
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
                cell.roundView.progressView.startTime = 12;
                cell.roundView.progressView.endTime = 53;
                cell.titLab.text = SMALocalizedString(@"device_SL_qualith");
                cell.stypeLab.text = SMALocalizedString(@"device_SL_typeS");
                cell.dialLab.text = SMALocalizedString(@"00h33m");
                cell.detailsTitLab1.text = SMALocalizedString(@"device_SL_deep");
                cell.detailsTitLab2.text = SMALocalizedString(@"device_SL_light");
                cell.detailsTitLab3.text = SMALocalizedString(@"device_SL_awake");
                cell.detailsLab1.text = @"00h33m";
                cell.detailsLab2.text = @"00h33m";
                cell.detailsLab3.text = @"00h88m";
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
}

#pragma mark *******BLConnectDelegate

- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    if (mode == CUFFSLEEPDATA) {
        self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncSucc");
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
        HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
        [self.tableView reloadData];
    }
}

- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode{
    if (mode == CUFFSPORTDATA || mode == CUFFSLEEPDATA || mode == CUFFHEARTRATE) {
        self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncFail");
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
        HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
        [self.tableView reloadData];
    }
}

#pragma mark *******calenderDelegate
- (void)didSelectDate:(NSDate *)date{
    self.date = date;
    titleLab.text = [self dateWithYMD];
    spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES];
    HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
    [self.tableView reloadData];
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

@end
