//
//  SMASleepDetailViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/26.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASleepDetailViewController.h"

@interface SMASleepDetailViewController ()
{
    UIScrollView *mainScroll;
    ZXRollView *detailScroll;
    UITableView *detailTabView;
    UIView *stateView;
    UICollectionView *detailColView;
    ScattView *scattView;
    WYScrollView *WYLocalScrollView;
    int cycle;
    NSUInteger showDataIndex;
    NSUInteger showViewTag;
    NSInteger selectTag;
    NSMutableArray *dataArr;
    NSArray *collectionArr;
    NSMutableArray *alldata;
    int updateUI;  // 0 准备更新  1 允许更新  2 更新完成
    NSDate *dateNow;
    NSDate *leftDate;
    NSDate *rightDate;
    NSDate *aggregateDate;
    NSMutableArray *aggregateData;
    NSMutableArray *aggregateLData;
    NSMutableArray *aggregateRData;
    NSMutableArray *aggregateAllData;
    int oldDirection;
    int aggregateIndex;
    NSTimer *aggregateTimer; //预加载定时器
    BOOL aggregate; //允许预加载
    BOOL tapWeek; //允许点击周按钮
    UIView *tabBarView;
     CGFloat tableHeight;
}

@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMASleepDetailViewController
static NSString * const reuseIdentifier = @"SMADetailCollectionCell";

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initializeMethod];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (aggregateTimer) {
        [aggregateTimer invalidate];
        aggregateTimer = nil;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    [self screeningSleepNowData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
    //加载绘图区域所需要数据（左中右三页）
    dateNow = self.date;
    leftDate = self.date.yesterday;
    rightDate = [self.date timeDifferenceWithNumbers:1];
    NSMutableArray *nowData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
    NSMutableArray *leftData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:leftDate.yyyyMMddNoLineWithDate]];
    NSMutableArray *rightData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:rightDate.yyyyMMddNoLineWithDate]];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:44/255.0 green:203/255.0 blue:111/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.backgroundColor = [SmaColor colorWithHexString:@"#2CCB6F" alpha:1];
//    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 1)];
    lineView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
    [tabBarView addSubview:lineView];
    
    NSArray *stateArr = @[SMALocalizedString(@"device_SP_day"),SMALocalizedString(@"device_SP_week"),SMALocalizedString(@"device_SP_month")];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = (MainScreen.size.width - 120)/2;
        
        but.frame = CGRectMake((MainScreen.size.width - width*2 - 65)/2 + (width + 65)*i, (self.tabBarController.tabBar.frame.size.height - 30)/2, width, 30);
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
    UIView *detailBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreen.size.width, 260)];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    //    _gradientLayer.bounds = detailScroll.bounds;
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = detailBackView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:44/255.0 green:203/255.0 blue:111/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:89/255.0 green:217/255.0 blue:164/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [detailBackView.layer insertSublayer:_gradientLayer atIndex:0];
    
    [mainScroll addSubview:detailBackView];
    
    /** 设置本地scrollView的Frame及所需图片*/
    WYLocalScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 260) WithLocalImages:aggregateData];
    /** 设置滚动延时*/
    WYLocalScrollView.AutoScrollDelay = 0;
    WYLocalScrollView.selectColor = selectTag == 101 ? YES : NO;
    WYLocalScrollView.xRangeLength = selectTag == 101 ? 25 : 4;
    WYLocalScrollView.xCoordinateDecimal = selectTag == 101 ? 0 : 0.5;
    WYLocalScrollView.identifiers = @[@"sport detail"];
    WYLocalScrollView.mode = CPTGraphBarPlot;
    WYLocalScrollView.categorymode = 1;
    WYLocalScrollView.sleepDayDraw = selectTag == 101 ? YES : NO;
    //柱状图线颜色
    WYLocalScrollView.lineColors = @[[CPTColor colorWithComponentRed:205/255.0 green:226/255.0 blue:251/255.0 alpha:1]];
    WYLocalScrollView.banRightSlide = selectTag == 101 ? ([self.date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate] ? YES : NO) : YES;
    WYLocalScrollView.yValueHiden = selectTag == 101 ? NO : NO;
    /** 获取本地图片的index*/
    WYLocalScrollView.localDelagate = self;
    /** 添加到当前View上*/
    [detailBackView addSubview:WYLocalScrollView];
    [WYLocalScrollView setMaxImageCount];
    
    // 促使视图切换时候保证图像不变化
//    [mainScroll setContentOffset:CGPointMake(0, 0)];
//    [self setViewTop:0 preference:YES];
    if (cycle == 0) {
        mainScroll.scrollEnabled = YES;
        NSArray *array = @[SMALocalizedString(@"device_SL_fallTime"),SMALocalizedString(@"device_SL_wakeTime"),SMALocalizedString(@"device_SL_sleepTime")];
        NSArray *titleArr = [[aggregateData[1] objectAtIndex:1] count] > 0? @[[[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"],[[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"],[self sleepTimeWithFall:[[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"] wakeUp:[[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"]]]:@[SMALocalizedString(@"device_SL_none"),SMALocalizedString(@"device_SL_none"),[[NSAttributedString alloc] initWithString:@"0h"]];
        stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height*2)];
        stateView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 3; i ++) {
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0 + i * MainScreen.size.width/3, 0, MainScreen.size.width/3, self.tabBarController.tabBar.frame.size.height)];
            titleLab.font = FontGothamLight(20);
            if (i !=2) {
                titleLab.text = titleArr[i];
            }
            else{
                titleLab.attributedText = titleArr[i];
            }
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.tag = 201 + i;
            [stateView addSubview:titleLab];
            
            UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(0 + i * MainScreen.size.width/3, self.tabBarController.tabBar.frame.size.height, MainScreen.size.width/3, self.tabBarController.tabBar.frame.size.height)];
            detailLab.font = FontGothamLight(13);
            detailLab.text = array[i];
            detailLab.textAlignment = NSTextAlignmentCenter;
            [stateView addSubview:detailLab];
        }
        
//        [mainScroll addSubview:stateView];
        
//        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame)) style:UITableViewStylePlain];
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame) + 1, MainScreen.size.width, 300) style:UITableViewStylePlain];
//        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        
        tableHeight = MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame) - 1;
        float contentHigh = CGRectGetHeight(WYLocalScrollView.frame) + 300;
        float standardHigh = MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height - contentHigh;
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, contentHigh);
    }
    else{
        mainScroll.scrollEnabled = YES;
        NSInteger selectIndex;
        selectIndex = [[aggregateData[1] objectAtIndex:4] integerValue];
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if (!collectionArr) {
            collectionArr = @[SMALocalizedString(@"device_SL_avgAwake"),SMALocalizedString(@"device_SL_avgDeep"),SMALocalizedString(@"device_SL_avgLight"),SMALocalizedString(@"device_HR_avgMonitor")];
        }
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-1)/2, ([UIScreen mainScreen].bounds.size.width-1)/2);
        
        //创建collectionView 通过一个布局策略layout来创建
        detailColView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 260 + 1, MainScreen.size.width, [UIScreen mainScreen].bounds.size.width-1) collectionViewLayout:layout];
        detailColView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
        detailColView.delegate= self;
        detailColView.dataSource = self;
        detailColView.scrollEnabled = NO;
        [detailColView registerNib:[UINib nibWithNibName:@"SMADetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        [mainScroll addSubview:detailColView];
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(detailColView.frame));
    }
}

- (void)tapBut:(UIButton *)sender{
//    NSMutableArray *aggregateNowData = SmaAggregate.aggregateSlWeekData;
//    if (aggregateNowData.count < 3) {
//        return;
//    }
    for (int i = 0; i < 2; i ++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:101 + i];
        but.selected = NO;
    }
     sender.selected = !sender.selected;
    if (selectTag != sender.tag) {
        selectTag = sender.tag;
        switch (sender.tag) {
            case 101:
            {
                self.title = [self dateWithYMDWithDate:self.date];
                dateNow = self.date;
                leftDate = self.date.yesterday;
                rightDate = [self.date timeDifferenceWithNumbers:1];
                NSMutableArray *nowData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
                NSMutableArray *leftData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:leftDate.yyyyMMddNoLineWithDate]];
                NSMutableArray *rightData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:rightDate.yyyyMMddNoLineWithDate]];
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
                NSMutableArray *lDataArr = [SMAAggregateTool getSleepWeekDetalilDataWithNowDate:leftDate month:NO];
                NSMutableArray *MDataArr = [SMAAggregateTool getSleepWeekDetalilDataWithNowDate:dateNow month:NO];
                NSMutableArray *RDataArr = [SMAAggregateTool getSleepWeekDetalilDataWithNowDate:rightDate month:NO];
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:lDataArr];
                [aggregateData addObject:MDataArr];
                [aggregateData addObject:RDataArr];
//                aggregateData = [NSMutableArray array];
//                aggregateIndex = 1;
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData102== %@ %d",aggregateData,aggregateNowData.count);
                [self addSubViewWithCycle:1];
            }
                break;
            default:
                break;
        }
    }
}

- (void)setSleepStateViewSubviews{
    NSArray *titleArr = [[aggregateData[1] objectAtIndex:1] count] > 0 ? @[[[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"],[[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"],[self sleepTimeWithFall:[[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"] wakeUp:[[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"]]]:@[SMALocalizedString(@"device_SL_none"),SMALocalizedString(@"device_SL_none"),[[NSAttributedString alloc] initWithString:@"0h"]];
    for (UILabel *lable in stateView.subviews) {
        
        if (lable.tag == 201) {
            lable.text = titleArr[0];
        }
        else if (lable.tag == 202){
            lable.text = titleArr[1];
        }
        else if (lable.tag == 203){
            lable.attributedText = titleArr[2];
        }
    }
}

- (void)setViewTop:(CGFloat)viewTop preference:(BOOL)presfer{
    CGFloat drawHeight = ([[aggregateData[1] objectAtIndex:1]  count] * 44 - tableHeight)/2;//由于tableview上滑会隐藏cell导致产生量，大概偏差为CELL的一半
    if (drawHeight > 100) {
        drawHeight = 100;
    }
    if (viewTop <= - drawHeight) {
        viewTop = - drawHeight;
         NSLog(@"fwgggggggg000000===%f",viewTop);
    }
    if (viewTop >= 0) {
        viewTop = 0;
    }
    CGFloat height = [[aggregateData[1] objectAtIndex:1]  count] * 44;
    if (height < tableHeight && !presfer) {
        return;
    }
    self.view.frame = CGRectMake(0, 64 + viewTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - viewTop);
    mainScroll.frame = CGRectMake(mainScroll.frame.origin.x, mainScroll.frame.origin.y, mainScroll.frame.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height - viewTop);
    tabBarView.frame = CGRectMake(tabBarView.frame.origin.x,CGRectGetMaxY(mainScroll.frame), tabBarView.frame.size.width, tabBarView.frame.size.height);
    detailTabView.frame = CGRectMake(0, detailTabView.frame.origin.y, detailTabView.frame.size.width, tableHeight - viewTop);
      NSLog(@"fwgggggggg=22222==%@  %@  %f  %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(detailTabView.frame),drawHeight,NSStringFromCGSize(detailColView.contentSize));
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark ******UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SMADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
//    if (!cell) {
//        cell = (SMADetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMADetailCell" owner:nil options:nil] lastObject];
//    }
//    cell.oval.strokeColor = [SmaColor colorWithHexString:@"#F688EB" alpha:1].CGColor;
//    if (indexPath.row == 0) {
//        cell.topLine.hidden = YES;
//        cell.distanceLab.attributedText = [[NSAttributedString alloc] initWithString:@""];
//    }
//    else if (indexPath.row == [[aggregateData[1] objectAtIndex:1] count] - 1){
//        cell.botLine.hidden = YES;
//        cell.distanceLab.attributedText = [[NSAttributedString alloc] initWithString:@""];
//    }
//    else{
//        cell.distanceLab.attributedText = [[[aggregateData[1] objectAtIndex:1]  objectAtIndex:indexPath.row] objectForKey:@"LAST"];
//    }
//    cell.timeLab.text = [[[aggregateData[1] objectAtIndex:1]  objectAtIndex:indexPath.row] objectForKey:@"TIME"];
//    cell.statelab.text = [[[aggregateData[1] objectAtIndex:1]  objectAtIndex:indexPath.row] objectForKey:@"TYPE"];
//    //    cell.distanceLab.text = [NSString stringWithFormat:@"%@%@",[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue] ] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SMASleepDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        cell = (SMASleepDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMASleepDetailCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        NSString *sleepTime = [[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"] ? [[[aggregateData[1] objectAtIndex:1] lastObject] objectForKey:@"TIME"]:@"00:00";
        cell.timeLab1.text = sleepTime;
        cell.titleLab1.text = SMALocalizedString(@"device_SL_fallTime");
        
        cell.timeLab2.text = [[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"] ? [[[aggregateData[1] objectAtIndex:1] firstObject] objectForKey:@"TIME"]:@"00:00";
        cell.titleLab2.text = SMALocalizedString(@"device_SL_wakeTime");
    }
    else if (indexPath.row == 1){
        
        NSString *soberTime = [aggregateData[1] objectAtIndex:2][3];
        NSString *sleepTime = [aggregateData[1] objectAtIndex:2][0];
        cell.timeLab1.attributedText = [self attributedStringWithArr:soberTime.intValue > 60 ? @[[NSString stringWithFormat:@"%d",soberTime.intValue/60],@"h",[NSString stringWithFormat:@"%d",soberTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")]:@[[NSString stringWithFormat:@"%d",soberTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")] fontArr:@[FontGothamLight(25),FontGothamLight(17)]];
        cell.titleLab1.text = SMALocalizedString(@"device_SL_soberDuration");
        
        cell.timeLab2.attributedText = [self attributedStringWithArr:sleepTime.intValue > 60 ? @[[NSString stringWithFormat:@"%d",sleepTime.intValue/60],@"h",[NSString stringWithFormat:@"%d",sleepTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")]:@[[NSString stringWithFormat:@"%d",sleepTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")] fontArr:@[FontGothamLight(25),FontGothamLight(17)]];
        cell.titleLab2.text = SMALocalizedString(@"device_SL_sleepTime");
    }
    else if (indexPath.row == 2){
        NSString *deepTime = [aggregateData[1] objectAtIndex:2][1];
        NSString *lightTime = [aggregateData[1] objectAtIndex:2][2];
        cell.timeLab1.attributedText = [self attributedStringWithArr:deepTime.intValue > 60 ? @[[NSString stringWithFormat:@"%d",deepTime.intValue/60],@"h",[NSString stringWithFormat:@"%d",deepTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")]:@[[NSString stringWithFormat:@"%d",deepTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")] fontArr:@[FontGothamLight(25),FontGothamLight(17)]];
        cell.titleLab1.text = SMALocalizedString(@"device_SL_deepDuration");
        
        cell.timeLab2.attributedText = [self attributedStringWithArr:lightTime.intValue > 60 ? @[[NSString stringWithFormat:@"%d",lightTime.intValue/60],@"h",[NSString stringWithFormat:@"%d",lightTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")]:@[[NSString stringWithFormat:@"%d",lightTime.intValue%60],SMALocalizedString(@"setting_sedentary_deMinute")] fontArr:@[FontGothamLight(25),FontGothamLight(17)]];
        cell.titleLab2.text = SMALocalizedString(@"device_SL_lightDuration");
    }
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
//     NSLog(@"gwgg==%f  %@",scrollView.contentOffset.y,NSStringFromCGSize(mainScroll.contentSize));
    if (cycle == 0 && scrollView == detailTabView) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat viewTop =  0 - y;
//        [self setViewTop:viewTop preference:NO];
    }
}

#pragma mark *******UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMADetailCollectionCell *cell = (SMADetailCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath]; if (showDataIndex == 0) {
        showDataIndex = [[[aggregateData objectAtIndex:1] objectAtIndex:4] integerValue] - 1;
    }

    if (indexPath.row == 0) {
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"sleepHour"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"sleepHour"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else if (indexPath.row == 1){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"simpleSleep"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"simpleSleep"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else{
        cell.detailLab.attributedText = [[NSAttributedString alloc] initWithString:[self avgSleepType:[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"sleepHour"] intValue] deepAmount:[[[[[aggregateData objectAtIndex:1] objectAtIndex:3] objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]] attributes:@{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#2CCB6F" alpha:1],NSFontAttributeName:FontGothamLight(30)}];
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
                    NSMutableArray *leftData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:leftDate.yyyyMMddNoLineWithDate]];
                    [aggregateData insertObject:leftData atIndex:0];
                    [aggregateData removeLastObject];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
            else if (direction == 1){
                rightDate = [dateNow timeDifferenceWithNumbers:2];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *rightData = [self screeningSleepNowData:[self.dal readSleepDataWithDate:rightDate.yyyyMMddNoLineWithDate]];
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
                leftDate = [dateNow timeDifferenceWithNumbers:-56];
                dateNow = [leftDate timeDifferenceWithNumbers:28];
                rightDate = [dateNow timeDifferenceWithNumbers:28];
                NSMutableArray *obligateArr = [SMAAggregateTool getSLDetalilObligateDataWithDate:leftDate month:NO];
                [aggregateData insertObject:obligateArr atIndex:0];
                [aggregateData removeLastObject];
//                aggregateIndex = aggregateIndex + 1;
//                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSlWeekData;
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData102-1 == %@ %d",aggregateData,aggregateNowData.count);
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
            }
            else if (direction == 1){
                rightDate = [dateNow timeDifferenceWithNumbers:56];
                dateNow = [rightDate timeDifferenceWithNumbers:-28];
                leftDate = [dateNow timeDifferenceWithNumbers:-28];
                NSMutableArray *obligateArr3 = [SMAAggregateTool getSLDetalilObligateDataWithDate:rightDate month:NO];
                [aggregateData addObject:obligateArr3];
                [aggregateData removeObjectAtIndex:0];
                
//                aggregateIndex = aggregateIndex - 1;
//                NSMutableArray *aggregateNowData = SmaAggregate.aggregateSlWeekData;
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 2)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - (aggregateIndex + 1)]];
//                [aggregateData addObject:[aggregateNowData objectAtIndex:aggregateNowData.count - aggregateIndex]];
//                NSLog(@"aggregateData102+1== %@ %d",aggregateData,aggregateNowData.count);
                NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
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
        if ([self.title isEqualToString:SMALocalizedString(@"device_todate")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
//        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height*2 + [aggregateData[1][1] count] * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height*2) ? ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145):CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height*2 + [aggregateData[1][1] count] * 44.0);
        [self setSleepStateViewSubviews];
    }
    else if (selectTag == 102){
        __block NSMutableArray *MDataArr;
        if (scrollView.updateUI) {
            MDataArr = [SMAAggregateTool getSleepWeekDetalilDataWithNowDate:dateNow month:NO];
            [aggregateData replaceObjectAtIndex:1 withObject:MDataArr];
             [scrollView changeImageLeft:0 center:0 right:0];

        }
        NSInteger selectIndex;
        selectIndex = [[aggregateData[1] objectAtIndex:4] integerValue];
        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if ([self.title isEqualToString:SMALocalizedString(@"device_SL_thisWeek")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
    }
    scrollView.imageArray = aggregateData;
    [detailTabView reloadData];
    oldDirection = 0;
    [detailColView reloadData];
    NSLog(@"scrollViewDidEndDecelerating = %@",scrollView);
}


#pragma mark******corePlotViewDelegate
- (void)WYbarTouchDownAtRecordIndex:(NSUInteger)idx{
    showDataIndex = idx - 1;
    [detailColView reloadData];
}

- (NSMutableArray *)screeningSleepNowData:(NSMutableArray *)sleepData{
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
    int atTypeTime = 0;//相同状态下起始时间
    int prevTypeTime=0;//睡眠状态下持续时长
    /* 	1-3深睡到未睡---深睡时间
     *   2-1清醒到深睡---浅睡时间
     *   2-3清醒到未睡---浅睡时间
     *   3-2未睡到清醒---清醒时间
     */
    NSMutableArray *detailDataArr = [NSMutableArray array];
    NSMutableArray *detailSLArr = [NSMutableArray array];
    NSMutableArray *alldataArr = [NSMutableArray array];
    for (int i = 0; i < sortArr.count; i ++) {
        NSDictionary *dic = sortArr[i];
        int atTime= [dic[@"TIME"] intValue];
        int atType = [dic[@"TYPE"] intValue];
        int amount=atTime-prevTime;
        if (i == 0) {
            amount = 0;
        }
        if (prevType == 2) {
            simpleSleepAmount = simpleSleepAmount + amount;
        }
        else if (prevType == 1){
            deepSleepAmount = deepSleepAmount + amount;
        }
        else{
            soberAmount = soberAmount + amount;
        }
        if (i == 0) {
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"device_SL_fallTime")}];
        }
        else if (i == sortArr.count - 1){
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"device_SL_wakeTime")}];
        }
        else{
            [detailSLArr addObject:@{@"TIME":[NSString stringWithFormat:@"%d",prevTime<600?(prevTime+120):(prevTime - 1320)],@"QUALITY":[NSString stringWithFormat:@"%d",prevType],@"SLEEPTIME":[NSString stringWithFormat:@"%d",amount]}];
            //筛选相同睡眠状态数据整合成一条
            if (prevType == atType) {
                if (prevTypeTime == 0) {
                    atTypeTime = prevTime;
                }
                prevTypeTime = prevTypeTime + amount;
            }
            else{
                if (prevTypeTime != 0) {
                    prevTypeTime = prevTypeTime + amount;
                    [detailDataArr addObject:@{@"TIME":[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",atTypeTime]],[self getHourAndMin:dic[@"TIME"]]],@"TYPE":[self sleepType:prevType],@"LAST":[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",prevTypeTime/60],@"h",[NSString stringWithFormat:@"%@%d",prevTypeTime%60 < 10 ? @"0":@"",prevTypeTime%60],@"m"] fontArr:@[FontGothamLight(19),FontGothamLight(15)]]}];
                    prevTypeTime = 0;
                }
                else{
                    prevTypeTime =  amount;
                    [detailDataArr addObject:@{@"TIME":[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime]],[self getHourAndMin:dic[@"TIME"]]],@"TYPE":[self sleepType:prevType],@"LAST":[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",prevTypeTime/60],@"h",[NSString stringWithFormat:@"%@%d",prevTypeTime%60 < 10 ? @"0":@"",prevTypeTime%60],@"m"] fontArr:@[FontGothamLight(19),FontGothamLight(15)]]}];
                    prevTypeTime = 0;
                }
            }
            if (prevType != atType) {
                prevTypeTime = 0;
            }
        }
        prevType = [dic[@"TYPE"] intValue];
        prevTime = [dic[@"TIME"] intValue];
    }
    NSArray *orderArr = [[[detailDataArr reverseObjectEnumerator] allObjects] mutableCopy];
    alldata = detailSLArr;
    
    int sleepHour = soberAmount + simpleSleepAmount + deepSleepAmount;
    NSMutableArray *sleep = [NSMutableArray array];
    [sleep addObject:[NSString stringWithFormat:@"%d",sleepHour]];
    [sleep addObject:[NSString stringWithFormat:@"%d",deepSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",simpleSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",soberAmount]];
    [alldataArr addObject:detailSLArr];
    [alldataArr addObject:orderArr];
    [alldataArr addObject:sleep];
    return alldataArr;
}

- (NSString *)getHourAndMin:(NSString *)time{
    if (time.intValue > 1440) {
        time = [NSString stringWithFormat:@"%d",time.intValue - 1440];
    }
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
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

- (NSString *)sleepType:(int)type{
    NSString *typeStr;
    switch (type) {
        case 1:
            typeStr = SMALocalizedString(@"device_SL_deep");
            break;
        case 2:
            typeStr = SMALocalizedString(@"device_SL_light");
            break;
        default:
            typeStr = SMALocalizedString(@"device_SL_awake");
            break;
    }
    return typeStr;
}

- (NSString *)avgSleepType:(int)sleepTime deepAmount:(int)deepTime{
    NSString *sleepState=@"";
    if (sleepTime/60 >= 9) {
        sleepState = SMALocalizedString(@"device_SL_typeT");
    }
    else if (sleepTime/60 >= 6 && sleepTime/60 <= 8 && deepTime/60 >= 4){
        sleepState = SMALocalizedString(@"device_SL_typeG");
    }
    else if (sleepTime/60 >= 6 && sleepTime/60 <= 8 && deepTime/60 >= 3 && deepTime/60 < 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepTime/60 < 6 || deepTime/60 < 3){
        sleepState = SMALocalizedString(@"device_SL_typeF");
    }
    return sleepState;
}

- (NSMutableAttributedString *)sleepTimeWithFall:(NSString *)fall wakeUp:(NSString *)wake{
    int fallTime = [[[fall componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[fall componentsSeparatedByString:@":"] lastObject] intValue];
    int wakeTime = [[[wake componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[wake componentsSeparatedByString:@":"] lastObject] intValue];
    if (fallTime <= 600) {
        fallTime = fallTime + 1440;
    }
    if (wakeTime <= 600) {
        wakeTime = wakeTime + 1440;
    }
    int sleepTime = wakeTime - fallTime;
    return [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",sleepTime/60],@"h",[NSString stringWithFormat:@"%d",sleepTime%60],@"m"] fontArr:@[FontGothamLight(20),FontGothamLight(15)]];
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

@end
