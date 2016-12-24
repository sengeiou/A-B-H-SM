//
//  SMASportDetailViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASportDetailViewController.h"

@interface SMASportDetailViewController ()
{
    UIScrollView *mainScroll;
    UITableView *detailTabView;
    UICollectionView *detailColView;
    WYScrollView *WYLocalScrollView;
    int cycle;
    NSUInteger showDataIndex;
    NSInteger selectTag;
    NSArray *collectionArr;
    NSDate *dateNow;
    NSDate *dateRun;
    NSDate *leftDate;
    NSDate *rightDate;
    NSMutableArray *aggregateData;
    int oldDirection ;
    int aggregateIndex;
    CGFloat tableHeight;
    UIView *tabBarView;
    int dateStep;
    UILabel *disLab; UILabel *calLab;
}
@property (nonatomic, strong) SMADatabase *dal;

@end

@implementation SMASportDetailViewController
//@synthesize detailScroll;

static NSString * const reuseIdentifier = @"SMADetailCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initializeMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)initializeMethod{
    //加载绘图区域所需要数据（左中右三页）
    dateNow = self.date;
    dateRun = self.date;
    leftDate = self.date.yesterday;
    rightDate = [self.date timeDifferenceWithNumbers:1];
    NSMutableArray *nowData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate ]];
    NSMutableArray *leftData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:leftDate.yyyyMMddNoLineWithDate toDate:leftDate.yyyyMMddNoLineWithDate ]];
    NSMutableArray *rightData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:rightDate.yyyyMMddNoLineWithDate toDate:rightDate.yyyyMMddNoLineWithDate ]];
    if (aggregateData) {
        [aggregateData removeAllObjects];
        aggregateData = nil;
    }
    aggregateData = [NSMutableArray array];
    [aggregateData addObject:leftData];
    [aggregateData addObject:nowData];
    [aggregateData addObject:rightData];
    [self addSubViewWithCycle:0];
}

- (void)createUI{
    self.title = [self dateWithYMDWithDate:self.date];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"icon-yundong" highIcon:@"icon-yundong" frame:CGRectMake(0, 0, 45, 30) target:self action:@selector(runButton) transfrom:0];
    self.view.backgroundColor = [UIColor whiteColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.backgroundColor = [SmaColor colorWithHexString:@"#5790F9" alpha:1];
    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 1)];
    lineView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
    [tabBarView addSubview:lineView];
    
    NSArray *stateArr = @[SMALocalizedString(@"device_SP_day"),SMALocalizedString(@"device_SP_week"),SMALocalizedString(@"device_SP_month")];
    for (int i = 0; i < 3; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = (MainScreen.size.width - 100)/3;
        but.frame = CGRectMake((MainScreen.size.width - width*3 - 50)/2 + (width + 25)*i, (self.tabBarController.tabBar.frame.size.height - 30)/2, width, 30);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 10;
        but.layer.borderColor = [SmaColor colorWithHexString:@"#5A94F9" alpha:1].CGColor;
        but.layer.borderWidth = 1;
        but.tag = 101 + i;
        if (i == 0) {
            but.selected = YES;
            selectTag = but.tag;
        }
        [but setTitle:stateArr[i] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#5A94F9" alpha:1] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateSelected];
        [but setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 30)] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageWithColor:[SmaColor colorWithHexString:@"#5A94F9" alpha:1] size:CGSizeMake(width, 30)] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(tapBut:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:but];
    }
    [self.view addSubview:tabBarView];
}

- (void)addSubViewWithCycle:(int)Cycle{
    cycle = Cycle;
    for (UIView *view in mainScroll.subviews) {
        [view removeFromSuperview];
    }
    UIView *detailBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreen.size.width, MainScreen.size.height * 0.372)];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = detailBackView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [detailBackView.layer insertSublayer:_gradientLayer atIndex:0];
    
    [mainScroll addSubview:detailBackView];
    /** 设置本地scrollView的Frame及所需图片*/
    WYLocalScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height * 0.372) WithLocalImages:aggregateData];
    /** 设置滚动延时*/
    WYLocalScrollView.AutoScrollDelay = 0;
    WYLocalScrollView.selectColor = selectTag == 101 ? YES : NO;
    WYLocalScrollView.xRangeLength = selectTag == 101 ? 25 : 4;
    WYLocalScrollView.xCoordinateDecimal = selectTag == 101 ? 0 : 0.5;
    WYLocalScrollView.identifiers = @[@"sport detail"];
    WYLocalScrollView.mode = CPTGraphBarPlot;
    //柱状图线颜色
    WYLocalScrollView.lineColors = @[[CPTColor colorWithComponentRed:205/255.0 green:226/255.0 blue:251/255.0 alpha:1]];
    WYLocalScrollView.banRightSlide = selectTag == 101 ? ([self.date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate] ? YES : NO) : YES;
    WYLocalScrollView.yValueHiden = selectTag == 101 ? NO : NO;
    /** 获取本地图片的index*/
    WYLocalScrollView.localDelagate = self;
    /** 添加到当前View上*/
    [detailBackView addSubview:WYLocalScrollView];
    [WYLocalScrollView setMaxImageCount];
    WYLocalScrollView.yDraw = NO;
    [self setViewTop:0 preference:YES];
    
    // 促使视图切换时候保证图像不变化
    [mainScroll setContentOffset:CGPointMake(0, 0)];
    if (selectTag == 101) {
        WYLocalScrollView.yDraw = YES;
        NSMutableArray *stepArr = [aggregateData[1][2] mutableCopy];
        [stepArr removeObjectIdenticalTo:@"0"];
        WYLocalScrollView.coordsLab = [SMAAccountTool userInfo].userGoal;
        NSInteger max = [[stepArr valueForKeyPath:@"@max.intValue"] integerValue];
        if (max <= [SMAAccountTool userInfo].userGoal.integerValue) {
            max = [SMAAccountTool userInfo].userGoal.integerValue;
        }
        WYLocalScrollView.coordsPlace = 10 + (CGRectGetHeight(WYLocalScrollView.frame) - 10) * 0.86 * (1 - [SMAAccountTool userInfo].userGoal.floatValue/max);
        
        UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(WYLocalScrollView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        calView.backgroundColor =[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1];
        UIView *calTitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(calView.frame)/3 + 5)];
        calTitView.backgroundColor = [SmaColor colorWithHexString:@"#5A94F9" alpha:1];
        [calView addSubview:calTitView];
        UILabel *calTitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(calTitView.frame))];
        calTitLab.textAlignment = NSTextAlignmentCenter;
        calTitLab.textColor = [UIColor whiteColor];
        calTitLab.text = SMALocalizedString(@"device_SP_heat");
        calTitLab.font = FontGothamLight(12);
        
        UIView *disTitView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(calView.frame)/2 + 1, 0, CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(calView.frame)/3 + 5)];
        disTitView.backgroundColor = [SmaColor colorWithHexString:@"#5A94F9" alpha:1];
        [calView addSubview:disTitView];
        
        UILabel *disTitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(disTitView.frame))];
        disTitLab.textAlignment = NSTextAlignmentCenter;
        disTitLab.text = SMALocalizedString(@"device_SP_sumDista");
        disTitLab.font = FontGothamLight(12);
        disTitLab.textColor = [UIColor whiteColor];
        [calTitView addSubview:calTitLab];
        [disTitView addSubview:disTitLab];
        
        calLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calTitView.frame), CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(calView.frame)/3 * 2)];
        calLab.textAlignment = NSTextAlignmentCenter;
        calLab.textColor = [UIColor whiteColor];
        calLab.backgroundColor = [SmaColor colorWithHexString:@"#5A94F9" alpha:1];
        calLab.attributedText = [self putCalWithStep:[[stepArr lastObject] intValue]];
        
        disLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(calView.frame)/2 + 1, CGRectGetMaxY(disTitView.frame), CGRectGetWidth(calView.frame)/2 - 0.5, CGRectGetHeight(calView.frame)/3 * 2)];
        disLab.textAlignment = NSTextAlignmentCenter;
        disLab.textColor = [UIColor whiteColor];
        disLab.backgroundColor = [SmaColor colorWithHexString:@"#5A94F9" alpha:1];
        disLab.attributedText = [self putDistanceWithStep:[[stepArr lastObject] intValue]];
        [calView addSubview:calLab];
        [calView addSubview:disLab];
        [mainScroll addSubview:calView];
        
        mainScroll.scrollEnabled = NO;
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        stateView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = FontGothamLight(15);
        timeLab.text = SMALocalizedString(@"device_SP_time");
        [stateView addSubview:timeLab];
        
        UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 150, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.text = SMALocalizedString(@"device_SP_state");
        stateLab.font = FontGothamLight(15);
        [stateView addSubview:stateLab];
        [mainScroll addSubview:stateView];
        
        //        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame)) style:UITableViewStylePlain];
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame)) style:UITableViewStylePlain];
        
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTabView.backgroundColor = [UIColor whiteColor];
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        //        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        //        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(stateLab.frame)+ [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145):CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(stateLab.frame)+ [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0);
        tableHeight = (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame);
        
    }
    else{
        mainScroll.scrollEnabled = YES;
        NSInteger selectIndex;
        selectIndex = [[aggregateData[1] objectAtIndex:4] integerValue];
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if (!collectionArr) {
            collectionArr = @[SMALocalizedString(@"device_SP_avgStep"),SMALocalizedString(@"device_SP_sumDista"),SMALocalizedString(@"device_SP_avgCal"),SMALocalizedString(@"device_SP_sit")];
        }
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-1)/2, ([UIScreen mainScreen].bounds.size.width-1)/2);
        
        //创建collectionView 通过一个布局策略layout来创建
        detailColView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(WYLocalScrollView.frame) + 1, MainScreen.size.width, [UIScreen mainScreen].bounds.size.width-1) collectionViewLayout:layout];
        detailColView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
        detailColView.delegate= self;
        detailColView.dataSource = self;
        detailColView.scrollEnabled = NO;
        [detailColView registerNib:[UINib nibWithNibName:@"SMADetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        [mainScroll addSubview:detailColView];
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(detailColView.frame));
    }
}

- (void)runButton{
    SMARunTableViewController *runVC = [[SMARunTableViewController alloc] init];
    runVC.date = dateRun;
    [self.navigationController pushViewController:runVC animated:YES];
}

- (void)tapBut:(UIButton *)sender{
//    NSMutableArray *aggregateNowData = SmaAggregate.aggregateSlWeekData;
//    if (aggregateNowData.count < 3) {
//        return;
//    }
    
    for (int i = 0; i < 3; i ++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:101 + i];
        but.selected = NO;
    }
    sender.selected = !sender.selected;
    if (selectTag != sender.tag) {
        selectTag = sender.tag;
        switch (sender.tag) {
            case 101:
            {
                dateNow = self.date;
                dateRun = self.date;
                self.title = [self dateWithYMDWithDate:dateNow];
                leftDate = self.date.yesterday;
                rightDate = [self.date timeDifferenceWithNumbers:1];
                NSMutableArray *nowData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate ]];
                NSMutableArray *leftData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:leftDate.yyyyMMddNoLineWithDate toDate:leftDate.yyyyMMddNoLineWithDate ]];
                NSMutableArray *rightData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:rightDate.yyyyMMddNoLineWithDate toDate:rightDate.yyyyMMddNoLineWithDate ]];
                if (aggregateData) {
                    [aggregateData removeAllObjects];
                    aggregateData = nil;
                }
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:leftData];
                [aggregateData addObject:nowData];
                [aggregateData addObject:rightData];
                [self addSubViewWithCycle:0];
            }
                break;
            case 102:
            {
                dateNow = [NSDate date];
                leftDate = [dateNow timeDifferenceWithNumbers:-28];
                rightDate = [dateNow timeDifferenceWithNumbers:28];
//                NSMutableArray *obligateArr = [self getDetalilObligateDataWithDate:leftDate month:NO];
                //                NSMutableArray *obligateArr2 = [self getDetalilObligateDataWithDate:dateNow month:NO];
                //                NSMutableArray *obligateArr3 = [self getDetalilObligateDataWithDate:rightDate month:NO];
                
                //                NSMutableArray *lDataArr = [self getDetalilDataWithNowDate:leftDate month:NO];
                //                NSMutableArray *MDataArr = [self getDetalilDataWithNowDate:dateNow month:NO];
                //                NSMutableArray *RDataArr = [self getDetalilDataWithNowDate:rightDate month:NO];
                
                NSMutableArray *lDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:leftDate month:NO];
                NSMutableArray *MDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:dateNow month:NO];
                NSMutableArray *RDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:rightDate month:NO];
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:lDataArr];
                [aggregateData addObject:MDataArr];
                [aggregateData addObject:RDataArr];
                
                //                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpWeekData;
                //                aggregateData = [NSMutableArray array];
                //                aggregateIndex = 1;
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
                //                NSLog(@"aggregateData102== %@ %d",aggregateData,aggregateNowData.count);
                [self addSubViewWithCycle:1];
            }
                break;
            case 103:
            {
                dateNow = [NSDate date];
                NSDate *lastdate = dateNow;
                for (int i = 0; i < 4; i ++) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:YES];
                    lastdate = [lastdate timeDifferenceWithNumbers:1];
                    if (i == 3) {
                     rightDate = lastdate;
                    }
                }
                
                lastdate = dateNow;
                for (int i = 0; i < 4; i ++) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:NO];
                    lastdate = lastdate.yesterday;
                    if (i == 3) {
                        leftDate = lastdate;
                    }
                }
////                NSDate *lastdate = dateNow;
////                for (int i = 0; i < 4; i ++ ) {
////                    NSDate *nextDate = lastdate;
////                    lastdate = [nextDate dayOfMonthToDateIndex:32];
////                    lastdate = [lastdate timeDifferenceWithNumbers:1];
////                    if (i == 3) {
////                        rightDate = lastdate; //由于当天位于视图中央，因此获取数据应从当天的四个月之后开始
////                    }
////                }
//                NSDate *first = [dateNow dayOfMonthLastDate:YES];
//                NSDate *last = [dateNow dayOfMonthLastDate:NO];
                NSMutableArray *lDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:leftDate month:YES];
                NSMutableArray *MDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:dateNow month:YES];
                NSMutableArray *RDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:rightDate month:YES];
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:lDataArr];
                [aggregateData addObject:MDataArr];
                [aggregateData addObject:RDataArr];
//                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpMonthData;
//                aggregateData = [NSMutableArray array];
//                aggregateIndex = 1;
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData103== %d",aggregateData,aggregateNowData.count);
                [self addSubViewWithCycle:1];
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)setViewTop:(CGFloat)viewTop preference:(BOOL)presfer{
    CGFloat drawHeight = ([[[aggregateData objectAtIndex:1] objectAtIndex:3]  count] * 44 - tableHeight)/2;//由于tableview上滑会隐藏cell导致产生量，大概偏差为CELL的一半
    if (drawHeight > 100) {
        drawHeight = 100;
    }
    if (viewTop <= - drawHeight) {
        viewTop = - drawHeight;
    }
    if (viewTop >= 0) {
        viewTop = 0;
    }
    CGFloat height = [[[aggregateData objectAtIndex:1] objectAtIndex:3]  count] * 44;
    if (height < tableHeight && !presfer) {
        return;
    }
    self.view.frame = CGRectMake(0, 64 + viewTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - viewTop);
    mainScroll.frame = CGRectMake(mainScroll.frame.origin.x, mainScroll.frame.origin.y, mainScroll.frame.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height - viewTop);
    tabBarView.frame = CGRectMake(tabBarView.frame.origin.x,CGRectGetMaxY(mainScroll.frame), tabBarView.frame.size.width, tabBarView.frame.size.height);
    detailTabView.frame = CGRectMake(0, detailTabView.frame.origin.y, detailTabView.frame.size.width, tableHeight - viewTop);
}

#pragma mark ******UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[aggregateData objectAtIndex:1] objectAtIndex:3]  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        cell = (SMADetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMADetailCell" owner:nil options:nil] lastObject];
    }
    cell.oval.strokeColor = [SmaColor colorWithHexString:@"#F688EB" alpha:1].CGColor;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    else if (indexPath.row == [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] - 1){
        cell.botLine.hidden = YES;
    }
    cell.timeLab.text = [[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"TIME"];
    cell.statelab.text = @"";
    cell.stateIma.image = [UIImage imageNamed:[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"MODE"]];
    cell.distanceLab.text = [NSString stringWithFormat:@"%@%@",[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"DURATION"],[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"DURATION"] intValue] > 1 ? SMALocalizedString(@"device_SP_steps"):SMALocalizedString(@"device_SP_step")];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark *******UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    if (scrollView == mainScroll && scrollView.contentOffset.y < 145 && cycle == 0) {
    //        detailTabView.scrollEnabled = NO;
    //        [detailTabView setContentOffset:CGPointMake(0.0, 0) animated:NO];
    //    }
    //    if (scrollView.contentOffset.y >= 145 && scrollView == mainScroll && cycle == 0) {
    //        scrollView.contentOffset = CGPointMake(0, 145);
    //        detailTabView.scrollEnabled = YES;
    //        return;
    //    }
    
    if (cycle == 0 && scrollView == detailTabView) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat viewTop =  0 - y;
        [self setViewTop:viewTop preference:NO];
    }
}

#pragma mark *******UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMADetailCollectionCell *cell = (SMADetailCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (showDataIndex == 0) {
        showDataIndex = [[[aggregateData objectAtIndex:1] objectAtIndex:4] integerValue];
    }
    if (indexPath.row == 0) {
        cell.detailLab.text = [NSString stringWithFormat:@"%d",[[[[aggregateData objectAtIndex:1] objectAtIndex:2] objectAtIndex:showDataIndex] intValue]];
    }
    else if (indexPath.row == 1){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[[aggregateData objectAtIndex:1] objectAtIndex:2] valueForKeyPath:@"@sum.intValue"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[[aggregateData objectAtIndex:1] objectAtIndex:2] objectAtIndex:showDataIndex] intValue]/[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] intValue]] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[SMACalculate notRounding:[SMACalculate countCalWithSex:[SMAAccountTool userInfo].userSex userWeight:[[SMAAccountTool userInfo].userWeigh floatValue] step:[[[[aggregateData objectAtIndex:1] objectAtIndex:2] objectAtIndex:showDataIndex] intValue]/[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] intValue]] afterPoint:1],SMALocalizedString(@"device_SP_cal")]];
    }
    else{
        int avgSit = [[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:showDataIndex] intValue]/[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] intValue];
        cell.detailLab.text = [NSString stringWithFormat:@"%@%@%@%@",avgSit >= 60 ? [NSString stringWithFormat:@"%d",avgSit/60]:@"",avgSit >= 60 ? @"h":@"",[NSString stringWithFormat:@"%d",avgSit%60],@"m"];
    }
    cell.titleLab.text = collectionArr[indexPath.row];
    return cell;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//设置纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}
//设置单元格间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}

#pragma mark *****************WYScrollViewLocalDelegate
//绘图区域滑动接近边沿时预加载各项数据
- (void)scrollViewWillToBorderAtDirection:(int)direction{
    if (selectTag == 101) {
        if (oldDirection != direction) {
            if (direction == -1) {
                leftDate = [dateNow timeDifferenceWithNumbers:-2];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *leftData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:leftDate.yyyyMMddNoLineWithDate toDate:leftDate.yyyyMMddNoLineWithDate ]];
                    [aggregateData insertObject:leftData atIndex:0];
                    [aggregateData removeLastObject];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
            else if (direction == 1){
                rightDate = [dateNow timeDifferenceWithNumbers:2];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *rightData = [self getFullDatasForOneDay:[self.dal readSportDetailDataWithDate:rightDate.yyyyMMddNoLineWithDate toDate:rightDate.yyyyMMddNoLineWithDate ]];
                    [aggregateData addObject:rightData];
                    [aggregateData removeObjectAtIndex:0];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
        }
    }
    else if (selectTag == 102){
        if (oldDirection != direction) {
            if (direction == -1) {
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                leftDate = [dateNow timeDifferenceWithNumbers:-56];
                dateNow = [leftDate timeDifferenceWithNumbers:28];
                rightDate = [dateNow timeDifferenceWithNumbers:28];
                NSMutableArray *obligateArr = [SMAAggregateTool getDetalilObligateDataWithDate:leftDate month:NO];
//                NSMutableArray *obligateArr2 = [SMAAggregateTool getDetalilObligateDataWithDate:dateNow month:NO];
//                NSMutableArray *obligateArr3 = [SMAAggregateTool getDetalilObligateDataWithDate:rightDate month:NO];
                //                    NSMutableArray *lDataArr = [self getDetalilDataWithNowDate:leftDate month:NO];
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:obligateArr];
//                [aggregateData addObject:obligateArr2];
//                [aggregateData addObject:obligateArr3];
                                    [aggregateData insertObject:obligateArr atIndex:0];
                                    [aggregateData removeLastObject];
                
                //                aggregateIndex = aggregateIndex + 1;
                //                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpWeekData;
                //                aggregateData = [NSMutableArray array];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
                //                NSLog(@"aggregateData102-1 == %@  %d",aggregateData,aggregateNowData.count);
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                //                });
            }
            else if (direction == 1){
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                rightDate = [dateNow timeDifferenceWithNumbers:56];
                dateNow = [rightDate timeDifferenceWithNumbers:-28];
                leftDate = [dateNow timeDifferenceWithNumbers:-28];
//                NSMutableArray *obligateArr = [SMAAggregateTool getDetalilObligateDataWithDate:leftDate month:NO];
//                NSMutableArray *obligateArr2 = [SMAAggregateTool getDetalilObligateDataWithDate:dateNow month:NO];
                NSMutableArray *obligateArr3 = [SMAAggregateTool getDetalilObligateDataWithDate:rightDate month:NO];
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:obligateArr];
//                [aggregateData addObject:obligateArr2];
//                [aggregateData addObject:obligateArr3];
                                [aggregateData addObject:obligateArr3];
                                [aggregateData removeObjectAtIndex:0];
                
                
                //                NSMutableArray *RDataArr = [self getDetalilDataWithNowDate:rightDate month:NO];
                //                NSMutableArray *obligateArr3 = [SMAAggregateTool getDetalilObligateDataWithDate:rightDate month:NO];
                //                [aggregateData addObject:obligateArr3];
                //                [aggregateData removeObjectAtIndex:0];
                //                aggregateIndex = aggregateIndex - 1;
                //                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpWeekData;
                //                aggregateData = [NSMutableArray array];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
                //                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
                //                NSLog(@"aggregateData102+1== %@  %d",aggregateData,aggregateNowData.count);
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                //                });
            }
        }
    }
    else if (selectTag == 103){
        if (oldDirection != direction) {
            if (direction == -1) {
                NSDate *lastdate = leftDate;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:NO];
                    lastdate = lastdate.yesterday;
                    if (i == 3) {
                        leftDate = lastdate;
                    }
                }

                lastdate = leftDate;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:YES];
                    lastdate = [lastdate timeDifferenceWithNumbers:1];
                    if (i == 3) {
                        dateNow = lastdate;
                    }
                }
                lastdate = dateNow;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:YES];
                    lastdate = [lastdate timeDifferenceWithNumbers:1];
                    if (i == 3) {
                        rightDate = lastdate;
                    }
                }
                
                NSMutableArray *obligateArr = [SMAAggregateTool getDetalilObligateDataWithDate:leftDate month:YES];
//                NSMutableArray *obligateArr2 = [SMAAggregateTool getDetalilObligateDataWithDate:dateNow month:NO];
//                NSMutableArray *obligateArr3 = [SMAAggregateTool getDetalilObligateDataWithDate:rightDate month:NO];
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:obligateArr];
//                [aggregateData addObject:obligateArr2];
//                [aggregateData addObject:obligateArr3];
                [aggregateData insertObject:obligateArr atIndex:0];
                [aggregateData removeLastObject];
                
                //                //获取所需要预加载的日期（dateNow 的前八个月）
                //                NSDate *firstdate1 = dateNow;
                //                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //                [formatter setDateFormat:@"yyyyMMdd"];
                //                NSString *nowMonth = [[formatter stringFromDate:firstdate1] substringWithRange:NSMakeRange(4, 2)];
                //                int goalMonth;
                //                NSString *goalDate;
                //                if (nowMonth.intValue - 8 < 1){
                //                    goalMonth = nowMonth.intValue - 8 + 12;
                //                    goalDate = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%d",[[[formatter stringFromDate:firstdate1] substringToIndex:4] intValue] - 1],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                //                }
                //                else{
                //                    goalMonth = nowMonth.intValue - 8;
                //                    goalDate = [NSString stringWithFormat:@"%@%@%@",[[formatter stringFromDate:firstdate1] substringToIndex:4],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                //                }
                //                leftDate = [formatter dateFromString:goalDate];
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                    NSMutableArray *lDataArr = [self getDetalilDataWithNowDate:leftDate month:YES];
                //                    [aggregateData insertObject:lDataArr atIndex:0];
                //                    [aggregateData removeLastObject];
//                aggregateIndex = aggregateIndex + 1;
//                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpMonthData;
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData103-1 == %@ %d",aggregateData,aggregateNowData.count);
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                //                });
            }
            else if (direction == 1){
                NSDate *lastdate = rightDate;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:YES];
                    lastdate = [lastdate timeDifferenceWithNumbers:1];
                    if (i == 3) {
                        rightDate = lastdate;
                    }
                }
                
                lastdate = rightDate;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:NO];
                    lastdate = lastdate.yesterday;
                    if (i == 3) {
                        dateNow = lastdate;
                    }
                }
                lastdate = dateNow;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthLastDate:NO];
                    lastdate = lastdate.yesterday;
                    if (i == 3) {
                        leftDate = lastdate;
                    }
                }
                NSMutableArray *obligateArr3 = [SMAAggregateTool getDetalilObligateDataWithDate:rightDate month:YES];
                [aggregateData addObject:obligateArr3];
                [aggregateData removeObjectAtIndex:0];
                
//                aggregateIndex = aggregateIndex - 1;
//                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSpMonthData;
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData103+1 == %@  %d",aggregateData,aggregateNowData.count);
                //                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //                [formatter setDateFormat:@"yyyyMMdd"];
                //                NSString *nowMonth = [[formatter stringFromDate:dateNow] substringWithRange:NSMakeRange(4, 2)];
                //                int goalMonth;
                //                NSString *goalDate;
                //                if (nowMonth.intValue + 8 > 12) {
                //                    goalMonth = nowMonth.intValue + 8 - 12;
                //                    goalDate = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%d",[[[formatter stringFromDate:dateNow] substringToIndex:4] intValue] + 1],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                //                }
                //                else{
                //                    goalMonth = nowMonth.intValue + 8;
                //                    goalDate = [NSString stringWithFormat:@"%@%@%@",[[formatter stringFromDate:dateNow] substringToIndex:4],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                //                }
                //                rightDate = [formatter dateFromString:goalDate];
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                    NSMutableArray *RDataArr = [self getDetalilDataWithNowDate:rightDate month:YES];
                //                    [aggregateData addObject:RDataArr];
                //                    [aggregateData removeObjectAtIndex:0];
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                //                });
            }
        }
    }
    oldDirection = direction;
}

//顶部绘图区域滑动完成（翻页）刷新UI
- (void)WYScrollViewDidEndDecelerating:(WYScrollView *)scrollView{
    if (selectTag == 101) {
        if (oldDirection == -1) {
            dateNow = [leftDate timeDifferenceWithNumbers:1];
            rightDate = [dateNow timeDifferenceWithNumbers:1];
        }
        else if (oldDirection == 1){
            dateNow = [rightDate timeDifferenceWithNumbers:-1];
            leftDate = [dateNow timeDifferenceWithNumbers:-1];
        }
        self.title = [self dateWithYMDWithDate:dateNow];
        dateRun = dateNow;
        if ([self.title isEqualToString:SMALocalizedString(@"device_todate")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
        NSMutableArray *stepArr = [aggregateData[1][2] mutableCopy];
        [stepArr removeObjectIdenticalTo:@"0"];
        calLab.attributedText = [self putCalWithStep:[[stepArr lastObject] intValue]];
        disLab.attributedText = [self putDistanceWithStep:[[stepArr lastObject] intValue]];
        
        WYLocalScrollView.yDraw = YES;
        WYLocalScrollView.coordsLab = [SMAAccountTool userInfo].userGoal;
        NSInteger max = [[stepArr valueForKeyPath:@"@max.intValue"] integerValue];
        if (max <= [SMAAccountTool userInfo].userGoal.integerValue) {
            max = [SMAAccountTool userInfo].userGoal.integerValue;
        }
        WYLocalScrollView.coordsPlace = 10 + (CGRectGetHeight(WYLocalScrollView.frame) - 10) * 0.86 * (1 - [SMAAccountTool userInfo].userGoal.floatValue/max);
        [WYLocalScrollView setNeedsDisplay];
        
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height + [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145):CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height + [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0);
    }
    else if (selectTag == 102){
        //        if (oldDirection == -1) {
        //            dateNow = [leftDate timeDifferenceWithNumbers:28];
        //            rightDate = [dateNow timeDifferenceWithNumbers:28];
        //        }
        //        else if (oldDirection == 1){
        //            dateNow = [rightDate timeDifferenceWithNumbers:-28];
        //            leftDate = [dateNow timeDifferenceWithNumbers:-28];
        //        }
        NSInteger selectIndex;
        __block NSMutableArray *MDataArr;
//        __block NSMutableArray *MDataArr = [SMAAggregateTool getDetalilObligateDataWithDate:dateNow month:NO];
        if (scrollView.updateUI) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:dateNow month:NO];
                [aggregateData replaceObjectAtIndex:1 withObject:MDataArr];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [scrollView changeImageLeft:0 center:0 right:0];
//                });
//            });
        }
        //        else{
        //             [aggregateData replaceObjectAtIndex:1 withObject:MDataArr];
        //            [scrollView changeImageLeft:0 center:0 right:0];
        //        }
        //        NSMutableArray *MDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:dateNow month:NO];
        selectIndex = [[aggregateData[1] objectAtIndex:4] integerValue];
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if ([self.title isEqualToString:SMALocalizedString(@"device_SL_thisWeek")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
    }
    else if (selectTag == 103){
//        if (oldDirection == -1) {
//            NSDate *lastdate = leftDate;
//            for (int i = 0; i < 4; i ++ ) {
//                NSDate *nextDate = lastdate;
//                lastdate = [nextDate dayOfMonthToDateIndex:32];
//                lastdate = [lastdate timeDifferenceWithNumbers:1];
//                if (i == 3) {
//                    dateNow = lastdate;
//                }
//            }
//            lastdate = dateNow;
//            for (int i = 0; i < 4; i ++ ) {
//                NSDate *nextDate = lastdate;
//                lastdate = [nextDate dayOfMonthToDateIndex:32];
//                lastdate = [lastdate timeDifferenceWithNumbers:1];
//                if (i == 3) {
//                    rightDate = lastdate;
//                }
//            }
//        }
//        else if (oldDirection == 1){
//            NSDate *firstdate = rightDate;
//            for (int i = 0; i < 4; i ++ ) {
//                NSDate *nextDate = firstdate;
//                firstdate = [nextDate dayOfMonthToDateIndex:0];
//                firstdate = firstdate.yesterday;
//                if (i == 3) {
//                    dateNow = firstdate;
//                }
//            }
//            firstdate = dateNow;
//            for (int i = 0; i < 4; i ++ ) {
//                NSDate *nextDate = firstdate;
//                firstdate = [nextDate dayOfMonthToDateIndex:0];
//                firstdate = firstdate.yesterday;
//                if (i == 3) {
//                    leftDate = firstdate;
//                }
//            }
//        }
            
            __block NSMutableArray *MDataArr;
            if (scrollView.updateUI) {
                MDataArr = [SMAAggregateTool getSPDetalilDataWithNowDate:dateNow month:YES];
                [aggregateData replaceObjectAtIndex:1 withObject:MDataArr];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [scrollView changeImageLeft:0 center:0 right:0];
//                });
            }

        NSInteger selectIndex;
        selectIndex = [[aggregateData[1] objectAtIndex:4] integerValue];
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if ([self.title isEqualToString:SMALocalizedString(@"device_SL_thisMonth")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
    }
    oldDirection = 0;
    scrollView.imageArray = aggregateData;
    [detailTabView reloadData];
    [detailColView reloadData];
    NSLog(@"scrollViewDidEndDecelerating = %@",scrollView);
}

- (void)WYbarTouchDownAtRecordIndex:(NSUInteger)idx{
    if (selectTag != 101) {
        showDataIndex = idx;
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:showDataIndex-1];
        [detailColView reloadData];
    }
}

- (NSMutableArray *)getDetalilObligateDataWithDate:(NSDate *)date month:(BOOL)month{
    NSLog(@"FFG==");
    NSMutableArray *alldataArr = [NSMutableArray array];
    NSDate *firstdate = date;
    NSMutableArray *weekDate = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        NSDate *lastdate;
        int step = 0;
        int dataNum = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            lastdate = [nextDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],lastdate?[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"] : @""],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
        [weekDate addObject:dic];
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
            [numArr addObject:@"0"];
        }
        else{
            [xText addObject:month?[self getMonthText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]:[self getWeekText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"]];
            if ([[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"] intValue] > 0) {
                showDataIndex = i;
            }
            [numArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"NUM"]];
        }
    }
    [alldataArr addObject:xText];        //图像底部坐标
    [alldataArr addObject:yBaesValues];  //图像底部起始点（柱状图）
    [alldataArr addObject:yValue];       //图像每个轴高度
    [alldataArr addObject:numArr];       //图像所包含数据量（含多少天数据，用于计算平均值）
    [alldataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)(showDataIndex == 0 ? 4 : showDataIndex)]];  //图像（周）最后一第含有数据的项（若没有，默认为最后一项）
    NSLog(@"FFG==1111");
    showDataIndex = 0;
    return alldataArr;
}

- (NSMutableArray *)getDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month{
    NSDate *firstdate = date;
    NSMutableArray *weekDate = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        NSDate *lastdate;
        int step = 0;
        int dataNum = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            lastdate = [nextDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        NSMutableArray *weekData = [self.dal readSportDataWithDate:firstdate.yyyyMMddNoLineWithDate toDate:nextDate.yyyyMMddNoLineWithDate];
        //        NSString * prevMode;//上一类型
        //        NSString *prevTime;//上一时间点
        //        int atTypeTime = 0;//相同状态下起始时间
        //        int prevTypeTime=0;//运动状态下持续时长
        if (weekData.count > 0) {
            for (int i = 0; i < (int)weekData.count - 1; i ++) {
                dataNum ++;
                step = [[weekData[i] objectForKey:@"STEP"] intValue] + step;
                if (i == weekData.count - 2) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step/dataNum],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],lastdate ? [SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"] : @""],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
                    [weekDate addObject:dic];
                }
            }
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],lastdate?[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"] : @""],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM",[firstdate.yyyyMMddNoLineWithDate substringToIndex:4],@"YEAR", nil];
            [weekDate addObject:dic];
        }
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *alldataArr = [NSMutableArray array];
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
            [numArr addObject:@"0"];
        }
        else{
            [xText addObject:month?[self getMonthText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]:[self getWeekText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"] year:[[weekDate objectAtIndex:4 - i] objectForKey:@"YEAR"]]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"]];
            if ([[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"] intValue] > 0) {
                showDataIndex = i;
            }
            [numArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"NUM"]];
        }
    }
    [alldataArr addObject:xText];        //图像底部坐标
    [alldataArr addObject:yBaesValues];  //图像底部起始点（柱状图）
    [alldataArr addObject:yValue];       //图像每个轴高度
    [alldataArr addObject:numArr];       //图像所包含数据量（含多少天数据，用于计算平均值）
    [alldataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)(showDataIndex == 0 ? 4 : showDataIndex)]];  //图像（周）最后一第含有数据的项（若没有，默认为最后一项）
    showDataIndex = 0;
    return alldataArr;
}

//整理当天数据
- (id)getFullDatasForOneDay:(NSMutableArray *)spDatas{
    NSMutableArray *detailArr = [NSMutableArray array];
    //    int sitAmount = 0;//静坐时间
    //    int walkAmount = 0;//浅睡眠时长
    //    int runSleepAmount = 0;//深睡时长
    
    NSString * prevMode;//上一类型
    NSString *prevTime;//上一时间点
    int atTypeTime = 0;//相同状态下起始时间
    int atTypeStep = 0;//相同状态下起始步数
    int prevTypeTime=0;//运动状态下持续时长
    /* 	16-17 静坐开始到步行开始---静坐时间
     *  16-18 静坐开始到跑步开始---静坐时间
     *  17-16 步行开始到静坐开始---步行时间
     *  17-18 步行开始到跑步开始---步行时间
     *  18-16 跑步开始到静坐开始---跑步时间
     *  18-17 跑步开始到步行开始---跑步时间
     */
    dateStep = [[spDatas lastObject][@"STEP"] intValue];
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
                    if (prevMode) {
                        if (prevMode.intValue == atMode.intValue) {
                            if (prevTypeTime == 0) {
                                atTypeTime = prevTime.intValue;
                            }
                            prevTypeTime = prevTypeTime + amount;
                            if (i == detail.count - 1) {
                                //                        prevTypeTime = prevTypeTime + amount; [NSString stringWithFormat:@"%d%@%@%@",[[NSString stringWithFormat:@"%d",prevTypeTime/60] intValue], @"h",[NSString stringWithFormat:@"%@%d",prevTypeTime%60 < 10 ? @"0":@"",prevTypeTime%60],@"m"]
                                NSDictionary *spDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%d",[dic[@"STEP"] intValue] - atTypeStep],@"DURATION", nil];
                                [detailArr addObject:spDic];
                            }
                        }
                        else{
                            if (prevTypeTime != 0) {
                                prevTypeTime = prevTypeTime + amount;
                                NSDictionary *spDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%d",[dic[@"STEP"] intValue] - atTypeStep],@"DURATION", nil];
                                [detailArr addObject:spDic];
                            }
                            else{
                                prevTypeTime =  amount;
                                NSDictionary *spDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime.intValue]],[self getHourAndMin:atTime]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%d",[dic[@"STEP"] intValue] - atTypeStep],@"DURATION", nil];
                                [detailArr addObject:spDic];
                            }
                        }
                        if (![prevMode isEqualToString:atMode]) {
                            atTypeStep = [dic[@"STEP"] intValue];
                            prevTypeTime = 0;
                        }
                    }
                    if (!prevMode) {
                        atTypeStep = [dic[@"STEP"] intValue] ;
                    }
                    prevMode = dic[@"MODE"];
                    prevTime = dic[@"TIME"] ;
                }
            }
        }
        if (prevMode.intValue != 0 && prevTime.intValue != [[SMADateDaultionfos minuteFormDate:[[NSDate date] yyyyMMddHHmmSSNoLineWithDate]] intValue] && [[[spDatas lastObject] objectForKey:@"DATE"] isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
            NSString *nowMinute = [SMADateDaultionfos minuteFormDate:[[NSDate date] yyyyMMddHHmmSSNoLineWithDate]];
            int sustainTime = nowMinute.intValue - prevTime.intValue;
            int sustainStep = [[[detail lastObject] objectForKey:@"STEP"] intValue] - atTypeStep;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime.intValue]],[self getHourAndMin:nowMinute]],@"TIME",[self sportMode:prevMode.intValue],@"MODE",[NSString stringWithFormat:@"%d",sustainStep],@"DURATION", nil];
            [detailArr addObject:dic];
        }
    }
    
    NSMutableArray *fullDatas = [[NSMutableArray alloc] init];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    for (int i = 0; i < 24; i ++) {
        BOOL found = NO;
        int time = -1 ;
        if (spDatas.count > 0) {
            for (NSDictionary *dic in spDatas) {
                if ([[dic objectForKey:@"TIME"] intValue]/60 == i) {
                    if (time == i) {
                        [fullDatas removeLastObject];
                    }
                    time = i;
                    [fullDatas addObject:dic];
                    found = YES;
                }
                else{
                    if (!found) {
                        if (time == i) {
                            [fullDatas removeLastObject];
                        }
                        time = i;
                        [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[spDatas  lastObject] objectForKey:@"DATE"],@"DATE", nil]];
                    }
                }
            }
        }
        else{
            [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[spDatas lastObject] objectForKey:@"DATE"],@"DATE", nil]];
        }
    }
    
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    for (int i = 0; i < 24; i ++) {
        if (i == 0 || i == 12 || i == 23) {
            [xText addObject:[NSString stringWithFormat:@"%@%d:00",i<10?@"":@"",i]];
        }
        else{
            [xText addObject:@""];
        }
    }
    for (int i = 0; i < 25; i ++) {
        if (i == 0) {
            [yValue addObject:@"0"];
        }
        else if(i == 25){
            [yValue addObject:[NSString stringWithFormat:@"%d",[[yValue valueForKeyPath:@"@max.intValue"] intValue] + 10]];
        }
        else{
            NSDictionary *dic = [fullDatas objectAtIndex:i-1];
            [yValue addObject:[dic objectForKey:@"STEP"]];
        }
        [yBaesValues addObject:@"0"];
    }
    NSArray *invertedArr = [[detailArr reverseObjectEnumerator] allObjects];
    [dayAlldata addObject:xText];       //图像底部坐标
    [dayAlldata addObject:yBaesValues]; //图像底部起始点（柱状图）
    [dayAlldata addObject:yValue];      //图像每个轴高度
    [dayAlldata addObject:invertedArr];   //运动数据详情（用于显示cell）
    return dayAlldata;
}

- (NSString *)getWeekText:(NSString *)str year:(NSString *)year{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *weekArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    NSArray *weekArr1 = [[dayArr lastObject] componentsSeparatedByString:@"."];
    NSString *weekStr;
    weekStr = str;
    if ([[weekArr firstObject] intValue] == 12 && [[weekArr1 firstObject] intValue] == 1) {
        weekStr = [NSString stringWithFormat:@"%@ %@ - %@ %@",year,[dayArr firstObject],[NSString stringWithFormat:@"%d",year.intValue + 1],[dayArr lastObject]];
    }
    //本周第一天
    NSString *nowFirstDate = [[NSDate date] firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSString class]];
    NSString *monDayStr = [SMADateDaultionfos monAndDateStringFormDateStr:nowFirstDate format:@"yyyyMMdd"];
    if ([[dayArr firstObject] isEqualToString:monDayStr]) {
        weekStr = SMALocalizedString(@"device_SL_thisWeek");
    }
    return weekStr;
}

- (NSString *)getMonthText:(NSString *)str year:(NSString *)year{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *monArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    NSString *monStr;
    monStr = [NSString stringWithFormat:@"%@%@",[monArr firstObject],SMALocalizedString(@"device_SP_month")];
    if ([[monArr firstObject] intValue] == 1) {
        monStr = [NSString stringWithFormat:@"%@ %@%@",year,[monArr firstObject],SMALocalizedString(@"device_SP_month")];
    }
    if ([[monArr firstObject] intValue] == [[[[NSDate date] yyyyMMddNoLineWithDate] substringWithRange:NSMakeRange(4, 2)] intValue] && [year isEqualToString:[[[NSDate date] yyyyMMddNoLineWithDate] substringToIndex:4]]) {
        monStr = SMALocalizedString(@"device_SL_thisMonth");
    }
    return monStr;
}

- (NSString *)getHourAndMin:(NSString *)time{
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10 ? @"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(35)};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(18)};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}

- (NSString *)dateWithYMDWithDate:(NSDate *)date{
    NSString *selfStr;
    if ([[NSDate date].yyyyMMddNoLineWithDate isEqualToString:date.yyyyMMddNoLineWithDate]) {
        selfStr = SMALocalizedString(@"device_todate");
    }
    else {
        selfStr= date.yyyyMMddByLineWithDate;
    }
    return selfStr;
}

- (NSString *)sportMode:(int)mode{
    NSString *modeStr;
    switch (mode) {
        case 16:
            //            modeStr = SMALocalizedString(@"device_SP_sit");
            modeStr = SMALocalizedString(@"icon_jingzuo");
            break;
        case 17:
            //            modeStr = SMALocalizedString(@"device_SP_walking");
            modeStr = SMALocalizedString(@"icon_buxing");
            break;
        default:
            //            modeStr = SMALocalizedString(@"device_SP_running");
            modeStr = SMALocalizedString(@"icon_paobu");
            break;
    }
    return modeStr;
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
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(22)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(14)};
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
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(22)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontGothamLight(14)};
    NSAttributedString *disAtt = [[NSAttributedString alloc] initWithString:calStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    NSMutableAttributedString *disAttStr = [[NSMutableAttributedString alloc] init];
    [disAttStr appendAttributedString:disAtt];
    [disAttStr appendAttributedString:unitAtt];
    return disAttStr;
}
@end
