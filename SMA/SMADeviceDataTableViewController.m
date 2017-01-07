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
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [SmaNotificationCenter addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
     [SmaNotificationCenter addObserver:self selector:@selector(updateData) name:@"updateData" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [SmaNotificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [SmaNotificationCenter removeObserver:self name:@"updateData" object:nil];
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
    SmaBleMgr.BLdelegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate];
        spArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate]];
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
    
    
//    SDDemoItemView *roundView =[[SDDemoItemView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
//    [self.view addSubview:roundView];
//    roundView.progressViewClass = [SDLoopProgressView class];
}

- (void)updateUI{
    SmaBleMgr.BLdelegate = self;
    if (![[SMADefaultinfos getValueforKey:UPDATEDATE] isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        self.date = [NSDate date];
        [calendarView removeFromSuperview];
        [SMADefaultinfos putKey:UPDATEDATE andValue:[NSDate date].yyyyMMddNoLineWithDate];
        [self updateData];
    }
    titleLab.text = [self dateWithYMD];
    if (!SmaBleMgr.syncing) {
        [self.tableView headerEndRefreshing];
        self.tableView.scrollEnabled = YES;
    }
    [self.tableView reloadData];
}

- (void)updateData{
    NSLog(@"更新数据");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        spArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate]];
        HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
        quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
        sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
        });
    });
}

- (IBAction)calendarSelector:(id)sender{
    calendarView = [[SMACalendarView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    calendarView.delegate = self;
    calendarView.date = self.date;
    [calendarView getDataDayModel:self.date];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:calendarView];
    
//    SmaAnalysisWebServiceTool *webSer = [[SmaAnalysisWebServiceTool alloc] init];
//    [webSer acloudDownLDataWithAccount:[SMAAccountTool userInfo].userID];
    
//    NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:1479375000000000/1000 withFormatStr:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    
//   NSTimeInterval timeInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:[NSDate date].yyyyMMddHHmmSSNoLineWithDate timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSTimeInterval timeInterval1 = [SMADateDaultionfos msecIntervalSince1970Withdate:@"20000101000000" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSLog(@"fef==%@",date);
}

- (IBAction)shareselector:(id)sender{
//    SmaAnalysisWebServiceTool *webSer = [[SmaAnalysisWebServiceTool alloc] init];
//    [webSer acloudSyncAllDataWithAccount:[SMAAccountTool userInfo].userID];
//    Byte buf[4];
//    buf[0] = 0x1f + 0x80;
//    buf[1] = 0xc5;
//    buf[2] = 0xea;
//    buf[3] = 0xea;
//    NSLog(@"ff==%@",[NSData dataWithBytes:buf length:4]);
//    if (buf[0] > 0x7f) {
//        buf[0] = buf[0] - 0x8f;
//    }
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
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    NSArray *shareArr;
    NSArray *shareImaArr;
    if (![preferredLang isEqualToString:@"zh"]) {
        shareArr = @[SMALocalizedString(@"twitter")/*,SMALocalizedString(@"tumblr")*/,SMALocalizedString(@"instagram"),SMALocalizedString(@"facebook")];
        shareImaArr = @[[UIImage imageNamed:@"home_twitter"]/*,[UIImage imageNamed:@"home_tumblr"]*/,[UIImage imageNamed:@"home_instagram"],[UIImage imageNamed:@"home_facebook"]];
    }
    else{
        shareArr = @[SMALocalizedString(@"device_share_wechat"),SMALocalizedString(@"device_share_Timeline"),SMALocalizedString(@"device_share_qq"),SMALocalizedString(@"device_share_Qzone"),SMALocalizedString(@"device_share_webo")];
        shareImaArr = @[[UIImage imageNamed:@"icon_weixin"],[UIImage imageNamed:@"home_pyq"],[UIImage imageNamed:@"icon_qq"],[UIImage imageNamed:@"home_kongjian"],[UIImage imageNamed:@"icon_weibo"]];
    }
    SMAShareView *shareView = [[SMAShareView alloc] initWithButtonTitles:shareArr butImage:shareImaArr shareImage:image];
    shareView.shareVC = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:shareView];
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
            self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncing");
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
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.pulldownView.hidden = NO;
            cell.roundView.progressViewClass = [SDLoopProgressView class];
            cell.roundView.progressView.progress = [[spArr lastObject] count] > 0 ? [[[[spArr lastObject] lastObject] objectForKey:@"STEP"] floatValue]/([SMAAccountTool userInfo].userGoal.intValue == 0 ? 1.000:[SMAAccountTool userInfo].userGoal.floatValue):0.0;
            cell.roundView.progressView.titleLab = [[spArr lastObject] count] > 0 ? [[[spArr lastObject] lastObject] objectForKey:@"STEP"]:@"0";
            cell.titLab.text = SMALocalizedString(@"device_SP_goal");
            cell.titLab.textColor = [UIColor colorWithRed:31/255.0 green:144/255.0 blue:234/255.0 alpha:1];
            cell.dialLab.text = [SMAAccountTool userInfo].userGoal;
            cell.stypeLab.text = [SMAAccountTool userInfo].userGoal.intValue < 2? SMALocalizedString(@"device_SP_step"):SMALocalizedString(@"device_SP_steps");

//            cell.detailsTitLab1.text = SMALocalizedString(@"device_SP_sit");WALK
//            cell.detailsTitLab2.text = SMALocalizedString(@"device_SP_walking");RUN
//            cell.detailsTitLab3.text = SMALocalizedString(@"device_SP_running");SIT
            cell.detailsLab1.attributedText = [self returnTimeWithMinute:[[[spArr firstObject] objectForKey:@"WALK"] intValue] textColor:[SmaColor colorWithHexString:@"#1F90EA" alpha:1] unitColor:[SmaColor colorWithHexString:@"#000000" alpha:1]];
            cell.detailsLab2.attributedText = [self returnTimeWithMinute:[[[spArr firstObject] objectForKey:@"RUN"] intValue] textColor:[SmaColor colorWithHexString:@"#1F90EA" alpha:1] unitColor:[SmaColor colorWithHexString:@"#000000" alpha:1]];
            cell.detailsLab3.attributedText = [self returnTimeWithMinute:[[[spArr firstObject] objectForKey:@"SIT"] intValue] textColor:[SmaColor colorWithHexString:@"#1F90EA" alpha:1] unitColor:[SmaColor colorWithHexString:@"#000000" alpha:1]];
            [cell tapRoundView:^(UIButton *button,UIView *view) {
                CGSize remindSize;
                NSString *remindStr;
                if (button.tag == 101) {
                    remindStr = SMALocalizedString(@"device_SP_walking");
                }
                else if(button.tag == 102){
                    remindStr = SMALocalizedString(@"device_SP_running");
                }
                else{
                    remindStr = SMALocalizedString(@"device_SP_sit");
                }
                remindSize = [self sizeWithText:remindStr];
                SMARemindView *remindView = [[SMARemindView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) - 8, CGRectGetMinY(button.frame) - 18, remindSize.width + 8, 20) title:remindStr];
                remindView.backIma.image = [UIImage imageNamed:@"home_yundong"];
                [view addSubview:remindView];
            }];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#1F90EA" alpha:1],[SmaColor colorWithHexString:@"#1F90EA" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#7DBEF9" alpha:1],[SmaColor colorWithHexString:@"#7DBEF9" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5B6B78" alpha:1],[SmaColor colorWithHexString:@"#5B6B78" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                dispatch_async(dispatch_get_main_queue(), ^{
//           // 绘制操作完成
            [cell.roundBut1 setImage:[UIImage imageNamed:@"icon_buxing"] forState:UIControlStateNormal];
            [cell.roundBut2 setImage:[UIImage imageNamed:@"icon_paobu"] forState:UIControlStateNormal];
            [cell.roundBut3 setImage:[UIImage imageNamed:@"icon_jingzuo"] forState:UIControlStateNormal];
//                    cell.roundView1.image = [UIImage imageNamed:@"icon_buxing"];
//                    cell.roundView2.image = [UIImage imageNamed:@"icon_paobu"];
//                    cell.roundView3.image = [UIImage imageNamed:@"icon_jingzuo"];
//                });
//            });
        }
        else if (indexPath.row == 1){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDRotationLoopProgressView class];
                cell.roundView.progressView.progress = [[[HRArr firstObject] objectForKey:@"REAT"] intValue]/200.0;
                cell.titLab.text = SMALocalizedString(@"setting_heart_monitor");
                cell.titLab.textColor = [UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1];
                cell.dialLab.textColor = [UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1];
                cell.dialLab.font = FontGothamLight(18);
                cell.dialLab.text = [self hrMode:[[[HRArr firstObject] objectForKey:@"REAT"] intValue]];
                cell.stypeLab.text = @"";
//                cell.detailsTitLab1.text = SMALocalizedString(@"device_HR_rest");
//                cell.detailsTitLab2.text = SMALocalizedString(@"device_HR_mean");
//                cell.detailsTitLab3.text = SMALocalizedString(@"device_HR_max");
                cell.detailsLab3.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[quietArr lastObject] objectForKey:@"HEART"] intValue]],@"bpm"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[UIColor blackColor]]];
                cell.detailsLab1.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[HRArr lastObject] objectForKey:@"avgHR"] intValue]],@"bpm"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[UIColor blackColor]]];
                cell.detailsLab2.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[HRArr lastObject] objectForKey:@"maxHR"] intValue]],@"bpm"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[UIColor blackColor]]];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#F8A3BD" alpha:1],[SmaColor colorWithHexString:@"#F8A3BD" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#D7B7EF" alpha:1],[SmaColor colorWithHexString:@"#D7B7EF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#EA1F75" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // 绘制操作完成
            [cell tapRoundView:^(UIButton *button,UIView *view) {
                CGSize remindSize;
                NSString *remindStr;
                if (button.tag == 103) {
                    remindStr = SMALocalizedString(@"device_HR_quiet");
                }
                else if(button.tag == 101){
                    remindStr = SMALocalizedString(@"device_HR_mean");
                }
                else{
                    remindStr = SMALocalizedString(@"device_HR_max");
                }
                remindSize = [self sizeWithText:remindStr];
                SMARemindView *remindView = [[SMARemindView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) - 8, CGRectGetMinY(button.frame) - 18, remindSize.width + 8, 20) title:remindStr];
                remindView.backIma.image = [UIImage imageNamed:@"home_xinlv"];
                [view addSubview:remindView];
            }];
            [cell.roundBut1 setImage:[UIImage imageNamed:@"icon_heart_jingxi"] forState:UIControlStateNormal];
            [cell.roundBut2 setImage:[UIImage imageNamed:@"icon_heart-pingjun"] forState:UIControlStateNormal];
            [cell.roundBut3 setImage:[UIImage imageNamed:@"icon_heart_big"] forState:UIControlStateNormal];
//                    });
//                });
            }
        else if (indexPath.row == 2){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDPieLoopProgressView class];
                cell.roundView.progressView.progress = 0.001;
                cell.roundView.progressView.startTime = [[sleepArr objectAtIndex:5] floatValue];
                cell.roundView.progressView.endTime = [[sleepArr objectAtIndex:6] floatValue];
                cell.titLab.text = [sleepArr objectAtIndex:1];
                cell.titLab.textColor = [UIColor colorWithRed:44/255.0 green:203/255.0 blue:111/255.0 alpha:1];
                cell.stypeLab.text = @"";
                cell.stypeLab.font = FontGothamLight(18);
                cell.stypeLab.textColor = [SmaColor colorWithHexString:@"#2CCB6F" alpha:1];
                cell.dialLab.attributedText = [sleepArr objectAtIndex:0];
//                cell.detailsTitLab1.text = SMALocalizedString(@"device_SL_deep");
//                cell.detailsTitLab2.text = SMALocalizedString(@"device_SL_light");
//                cell.detailsTitLab3.text = SMALocalizedString(@"device_SL_awake");
                cell.detailsLab3.attributedText = [sleepArr objectAtIndex:4];
                cell.detailsLab1.attributedText = [sleepArr objectAtIndex:3];
                cell.detailsLab2.attributedText = [sleepArr objectAtIndex:2];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#8DE3BF" alpha:1],[SmaColor colorWithHexString:@"#8DE3BF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#00C6AE" alpha:1],[SmaColor colorWithHexString:@"#00C6AE" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#2CCB6F" alpha:1],[SmaColor colorWithHexString:@"#2CCB6F" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // 绘制操作完成
            [cell tapRoundView:^(UIButton *button,UIView *view) {
                CGSize remindSize;
                NSString *remindStr;
                if (button.tag == 103) {
                    remindStr = SMALocalizedString(@"device_SL_awake");
                }
                else if(button.tag == 101){
                    remindStr = SMALocalizedString(@"device_SL_light");
                }
                else{
                    remindStr = SMALocalizedString(@"device_SL_deep");
                }
                remindSize = [self sizeWithText:remindStr];
                SMARemindView *remindView = [[SMARemindView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) - 8, CGRectGetMinY(button.frame) - 18, remindSize.width + 8, 20) title:remindStr];
                remindView.backIma.image = [UIImage imageNamed:@"home_shuimian"];
                [view addSubview:remindView];
            }];
            [cell.roundBut1 setImage:[UIImage imageNamed:@"icon_qingxin"] forState:UIControlStateNormal];
            [cell.roundBut2 setImage:[UIImage imageNamed:@"icon_qianshui"] forState:UIControlStateNormal];
            [cell.roundBut3 setImage:[UIImage imageNamed:@"icon_shenshui"] forState:UIControlStateNormal];
            //                    });
//                });
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
    NSLog(@"bledidDisposeMode  ==%d",mode);
    if (mode == CUFFSLEEPDATA) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate];
            spArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate]];
            HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
            quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
            sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncSucc");
                [self.tableView headerEndRefreshing];
                self.tableView.scrollEnabled = YES;
                 [self.tableView reloadData];
            });
        });
    }
}

- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode{
    if (mode == CUFFSPORTDATA || mode == CUFFSLEEPDATA || mode == CUFFHEARTRATE) {
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate];
            spArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate]];
            HRArr = [self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:NO];
            quietArr = [self.dal readQuietHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES];
            sleepArr =[self screeningSleepData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.headerRefreshingText = SMALocalizedString(@"device_syncFail");
                [self.tableView headerEndRefreshing];
                self.tableView.scrollEnabled = YES;
                 [self.tableView reloadData];
            });
        });
    }
}

#pragma mark *******calenderDelegate
- (void)didSelectDate:(NSDate *)date{
    self.date = date;
    titleLab.text = [self dateWithYMD];
    [[NSDate date] lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSString class]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        spArr = [self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate];
        spArr = [self getSPDatasModeContinueForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate]];
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

- (id)getSPDatasModeContinueForOneDay:(NSMutableArray *)spDatas{
    NSMutableArray *detailArr = [NSMutableArray array];
    int sitAmount=0;//静坐时长
    int walkAmount=0;//步行时长
    int runAmount=0;//跑步时长
    NSString * prevMode;//上一类型
    NSString *prevTime;//上一时间点
    int atTypeTime = 0;//相同状态下起始时间
    int prevTypeTime=0;//运动状态下持续时长
    /* 	16-17 静坐开始到步行开始---静坐时间
     *  16-18 静坐开始到跑步开始---静坐时间
     *  17-16 步行开始到静坐开始---步行时间
     *  17-18 步行开始到跑步开始---步行时间
     *  18-16 跑步开始到静坐开始---跑步时间
     *  18-17 跑步开始到步行开始---跑步时间
     */
    if (spDatas.count > 0) {
        NSMutableArray *detail = spDatas;
        for (int i = 0; i < detail.count; i ++) {
            NSDictionary *dic = detail[i];
            NSString *atTime = dic[@"TIME"];
            NSString *atMode = dic[@"MODE"];
            int amount = atTime.intValue - prevTime.intValue;
            if (i == 0) {
                amount = 0;
                if (atMode.intValue != 0) {
                    prevMode = dic[@"MODE"];
                    prevTime = dic[@"TIME"] ;
                }
            }
            else{
                if (atMode.intValue != 0) {
                    if (prevMode.intValue == 16) {
                        sitAmount = sitAmount + amount;
                    }
                    else if (prevMode.intValue == 17){
                        walkAmount = walkAmount + amount;
                    }
                    else if (prevMode.intValue == 18){
                        runAmount = runAmount + amount;
                    }
                    if (prevMode) {
                        if (prevMode.intValue == atMode.intValue) {
                            if (prevTypeTime == 0) {
                                atTypeTime = prevTime.intValue;
                            }
                            prevTypeTime = prevTypeTime + amount;
                            if (i == detail.count - 1) {
                                //                        prevTypeTime = prevTypeTime + amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                        }
                        else{
                            if (prevTypeTime != 0) {
                                prevTypeTime = prevTypeTime + amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                            else{
                                prevTypeTime =  amount;
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime.intValue]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%@%@%@%@",prevTypeTime >= 60 ? [NSString stringWithFormat:@"%d",prevTypeTime/60]:@"",prevTypeTime >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",prevTypeTime%60],@"m"],@"DURATION", nil];
                                [detailArr addObject:dic];
                            }
                        }
                        if (![prevMode isEqualToString:atMode]) {
                            prevTypeTime = 0;
                        }
                    }
                    prevMode = dic[@"MODE"];
                    prevTime = dic[@"TIME"] ;
                }
            }
        }
        if (prevMode.intValue != 0 && prevTime.intValue != [[SMADateDaultionfos minuteFormDate:[[NSDate date] yyyyMMddHHmmSSNoLineWithDate]] intValue] && [self.date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
            int amount = 0;
            NSString *nowMinute = [SMADateDaultionfos minuteFormDate:[[NSDate date] yyyyMMddHHmmSSNoLineWithDate]];
            amount = nowMinute.intValue - prevTime.intValue;
            if (prevMode.intValue == 16) {
                sitAmount = sitAmount + amount;
            }
            else if (prevMode.intValue == 17){
                walkAmount = walkAmount + amount;
            }
            else if (prevMode.intValue == 18){
                runAmount = runAmount + amount;
            }

//            NSString *nowMinute = [SMADateDaultionfos minuteFormDate:[[NSDate date] yyyyMMddHHmmSSNoLineWithDate]];
//            int sustainTime = nowMinute.intValue - prevTime.intValue;
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime.intValue]],[self getHourAndMin:nowMinute]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%d%@%@%@",[[NSString stringWithFormat:@"%d",sustainTime /60] intValue], @"h",[NSString stringWithFormat:@"%@%d",sustainTime%60 < 10 ? @"0":@"",sustainTime%60],@"m"],@"DURATION", nil];
//            [detailArr addObject:dic];
        }
    }
    
    NSDictionary *modeDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:sitAmount],@"SIT",[NSNumber numberWithInt:walkAmount],@"WALK",[NSNumber numberWithInt:runAmount],@"RUN", nil];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    [dayAlldata addObject:modeDic];
    [dayAlldata addObject:detailArr];   //运动数据详情（用于显示cell）
    [dayAlldata addObject:spDatas ];
    return dayAlldata;
}



- (NSMutableArray *)screeningSleepData:(NSMutableArray *)sleepData{
//    NSArray * arr = [sleepData sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
//        if ([obj1[@"TIME"] intValue]<[obj2[@"TIME"] intValue]) {
//            return NSOrderedAscending;
//        }
//        
//        else if ([obj1[@"TIME"] intValue]==[obj2[@"TIME"] intValue])
//            
//            return NSOrderedSame;
//        
//        else
//            
//            return NSOrderedDescending;
//        
//    }];
    NSMutableArray *sortArr = sleepData;
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
    if (sleepHour/60 >= 9) {
        sleepState = SMALocalizedString(@"device_SL_typeT");
    }
    else if (sleepHour/60 >= 6 && sleepHour/60 <= 8 && deepAmount >= 4){
        sleepState = SMALocalizedString(@"device_SL_typeG");
    }
    else if (sleepHour/60 >= 6 && sleepHour/60 <= 8 && deepAmount >= 3 && deepAmount < 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepHour/60 < 6 || deepAmount < 3){
        sleepState = SMALocalizedString(@"device_SL_typeF");
    }
    NSMutableArray *sleep = [NSMutableArray array];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",sleepHour/60],@"h",[NSString stringWithFormat:@"%@%d",sleepHour%60 < 60 ? @"0":@"",sleepHour%60],@"m"] fontArr:@[FontGothamLight(20),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"2CCB6F" alpha:1],[UIColor blackColor]]]];
    [sleep addObject:sleepState];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",deepSleepAmount/60],@"h",[NSString stringWithFormat:@"%@%d",deepSleepAmount%60 < 10 ? @"0": @"",deepSleepAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"2CCB6F" alpha:1],[UIColor blackColor]]]];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",simpleSleepAmount/60],@"h",[NSString stringWithFormat:@"%@%d",simpleSleepAmount%60 < 10 ? @"0":@"",simpleSleepAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"2CCB6F" alpha:1],[UIColor blackColor]]]];
    [sleep addObject:[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",soberAmount/60],@"h",[NSString stringWithFormat:@"%@%d",soberAmount%60 < 10 ? @"0":@"",soberAmount%60],@"m"] fontArr:@[FontGothamLight(15),FontGothamLight(15)]colorArr:@[[SmaColor colorWithHexString:@"2CCB6F" alpha:1],[UIColor blackColor]]]];
    [sleep addObject:[NSString stringWithFormat:@"%f",[[[sortArr firstObject] objectForKey:@"TIME"] floatValue]>=1320?([[[sortArr firstObject] objectForKey:@"TIME"] floatValue] - 720)/12:[[[sortArr firstObject] objectForKey:@"TIME"] floatValue]/12]];
    float endTime = [[[sortArr lastObject] objectForKey:@"TIME"] floatValue] > 1440 ? [[[sortArr lastObject] objectForKey:@"TIME"] floatValue] - 1440 : [[[sortArr lastObject] objectForKey:@"TIME"] floatValue];
    [sleep addObject:[NSString stringWithFormat:@"%f",endTime >= 1320 ? (endTime - 720)/12 : endTime/12]];
    return sleep;
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr fontArr:(NSArray *)fontArr colorArr:(NSArray *)colorArr{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:colorArr[0],NSFontAttributeName:fontArr[0]};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:colorArr[1],NSFontAttributeName:fontArr[1]};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}

- (NSString *)getHourAndMin:(NSString *)time{
    if (time.intValue > 1440) {
        time = [NSString stringWithFormat:@"%d",time.intValue - 1440];
    }
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

- (NSString *)sportMode:(int)mode{
    NSString *modeStr;
    switch (mode) {
        case 16:
            modeStr = SMALocalizedString(@"device_SP_sit");
            break;
        case 17:
            modeStr = SMALocalizedString(@"device_SP_walking");
            break;
        default:
            modeStr = SMALocalizedString(@"device_SP_running");
            break;
    }
    return modeStr;
}

- (NSString *)hrMode:(int)mode{
    NSString *modeStr;
    if (mode < 60) {
        modeStr = SMALocalizedString(@"device_HR_typeS");
    }else if (mode >=60 && mode < 100){
        modeStr = SMALocalizedString(@"device_HR_typeF");
    }
    else{
        modeStr = SMALocalizedString(@"device_HR_typeT");
    }
    return modeStr;
}

- (NSMutableAttributedString *)returnTimeWithMinute:(int)minute textColor:(UIColor *)textcolor unitColor:(UIColor *)unitColor{
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *hourStr = [[NSAttributedString alloc] initWithString:minute >= 60 ? [NSString stringWithFormat:@"%d",minute/60]:@"0" attributes:@{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:FontGothamLight(15)}];
    NSAttributedString *hourUnitStr = [[NSAttributedString alloc] initWithString:@"h" attributes:@{NSForegroundColorAttributeName:unitColor,NSFontAttributeName:FontGothamLight(15)}];
    NSAttributedString *minStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",minute%60 < 10 ? @"0":@"",minute%60] attributes:@{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:FontGothamLight(15)}];
    NSAttributedString *minUnitStr = [[NSAttributedString alloc] initWithString:@"m" attributes:@{NSForegroundColorAttributeName:unitColor,NSFontAttributeName:FontGothamLight(15)}];
    [timeStr appendAttributedString:hourStr];
    [timeStr appendAttributedString:hourUnitStr];
    [timeStr appendAttributedString:minStr];
    [timeStr appendAttributedString:minUnitStr];
    return timeStr;
}

- (CGSize )sizeWithText:(NSString *)text{
    return [text sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(12)}];
}

@end
