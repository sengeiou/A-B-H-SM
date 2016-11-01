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
    UICollectionView *detailColView;
    ScattView *scattView;
    int cycle;
    NSUInteger showDataIndex;
    NSUInteger showViewTag;
    NSInteger selectTag;
    NSMutableArray *dataArr;
    NSArray *collectionArr;
    NSMutableArray *alldata;
    BOOL firstCreate;
    NSDate *dateNow;
    
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
//    alldata = [self getFullDatasForOneDay:[self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES]];
    [self screeningSleepNowData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
    [self addSubViewWithCycle:0];
    //    [self drawSPViewMode:1 spData:spArr];
}

- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:44/255.0 green:203/255.0 blue:111/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.backgroundColor = [SmaColor colorWithHexString:@"#2CCB6F" alpha:1];
    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
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
    
    detailScroll = [[ZXRollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreen.size.width, 260)];
    firstCreate = NO;
    [detailBackView addSubview:detailScroll];
    detailScroll.pageIndicatorColor = [UIColor clearColor];
    detailScroll.backgroundColor = [UIColor clearColor];
    detailScroll.currentPageIndicatorColor = [UIColor clearColor];
    detailScroll.delegate = self;
    detailScroll.autoRolling = NO;
    detailScroll.tapGesture = NO;
    detailScroll.hideIndicatorForSinglePage = YES;
    detailScroll.interitemSpacing = 0;
    if (selectTag == 101 && ![self.date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
        detailScroll.leftTopDrawing = YES;
    }
    [detailScroll reloadViews];
    
    if (cycle == 0) {
        NSArray *array = @[SMALocalizedString(@"device_SL_fallTime"),SMALocalizedString(@"device_SL_wakeTime"),SMALocalizedString(@"device_SL_sleepTime")];
        NSArray *titleArr = dataArr.count>0? @[[[dataArr lastObject] objectForKey:@"TIME"],[[dataArr firstObject] objectForKey:@"TIME"],[self sleepTimeWithFall:[[dataArr lastObject] objectForKey:@"TIME"] wakeUp:[[dataArr firstObject] objectForKey:@"TIME"]]]:@[SMALocalizedString(@"device_SL_none"),SMALocalizedString(@"device_SL_none"),[[NSAttributedString alloc] initWithString:@"0h"]];
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height*2)];
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
        
        [mainScroll addSubview:stateView];
        
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, 600 - CGRectGetHeight(detailScroll.frame) - CGRectGetHeight(stateView.frame)) style:UITableViewStylePlain];
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateView.frame)+ dataArr.count * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height*2) ? 600:CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateView.frame)+ dataArr.count * 44.0);
    }
    else{
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
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(detailColView.frame));
    }
}

- (void)addSPViewMode: (int)mode superView:(UIView *)view{
    if (scattView) {  //若没有此段，则当使用3.5寸手机切换月份时会产生两个柱状图，导致每个图都显示不全，原因不明
        [scattView removeFromSuperview];
        scattView = nil;
    }
    if (!scattView) {
        scattView = [[ScattView alloc] init];
        scattView.frame = detailScroll.bounds;//10, 134, 300, 140
        scattView.delegate = self;
        // scattView.frame = CGRectMake(50, 0, 400, 200);
        scattView.backgroundColor = [UIColor clearColor];
        [view addSubview:scattView];
    }
    scattView.HRdataArr = [NSMutableArray array];
    scattView.YgiveLsat = cycle == 0 ? YES:NO;//隐藏Y轴数据最后一位
    scattView.DrawMode = mode==0?0:1;
    scattView.lineColors =@[[CPTColor colorWithComponentRed:205/255.0 green:226/255.0 blue:251/255.0 alpha:1]];
    scattView.poinColors = [CPTColor whiteColor];
    scattView.identifiers = @[@"Sleep Pattern"];  //随便定义
    scattView.showLegend = NO;
    scattView.xCoordinateDecimal = 0.0f;
    scattView.hideYAxisLabels = YES;
    scattView.plotAreaFramePaddingLeft = -10;
    scattView.selectColor = YES;
    if (selectTag == 101) {
        scattView.selectColor = NO;
    }
    scattView.yAxisTexts = @[@""];
    scattView.xMajorIntervalLength = @"1";
}

- (void)addSleepOneDateWithSuperView:(UIView *)view{
    MTKSleepView *sleepView = [[MTKSleepView alloc] initWithFrame:CGRectMake(0, 10,MainScreen.size.width ,250)];//画图两边各有5像素缩进，为了X轴坐标能显示，故需要在理想长度再增加10像素
    [view addSubview:sleepView];
    sleepView.xTexts = @[@"22:00",@"2:00",@"6:00",@"10:00"];
//  sleepView.xValues = [alldata copy];
    sleepView.backgroundColor = [UIColor clearColor];
}

- (void)drawSleepOneDateView{
    for (UIView *view in detailScroll.scrollView.subviews) {
        NSLog(@"view.tag = %d",view.tag);
        if (view.tag == showViewTag) {
            for (MTKSleepView *sleepView in view.subviews) {
                sleepView.xValues = [alldata copy];
                [sleepView setNeedsDisplay];
            }
        }
    }
//    sleepView.xValues = [alldata copy];
}

- (void)drawScattViewWithSpArr:(NSMutableArray *)spArr{
    scattView.xAxisTexts = [spArr firstObject];
    scattView.yValues = @[spArr[2]];
    scattView.yBaesValues = @[spArr[1]];
    scattView.barLineWidth = [spArr[2] count] >10 ?7.0f:5;
    scattView.selectIdx = [spArr[2] count] - 1;
    scattView.selectColor = [spArr[2] count] >10 ?NO:YES;
    scattView.ylabelLocation = [[spArr[2] valueForKeyPath:@"@max.intValue"] intValue];//可以yValue最大值为基准
    [scattView initGraph];
    [detailColView reloadData];
    [detailTabView reloadData];
}

- (void)tapBut:(UIButton *)sender{
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
                [self screeningSleepNowData:[self.dal readSleepDataWithDate:self.date.yyyyMMddNoLineWithDate]];
                [self addSubViewWithCycle:0];
            }
                break;
            case 102:
            {
                dateNow = [NSDate date];
                [self getDetalilDataWithNowDate:dateNow month:NO updateUI:YES];
            }
                break;
            case 103:
            {
                dateNow = [NSDate date];
//                [self getDetalilDataWithNowDate:dateNow month:YES updateUI:YES];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark ******UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArr  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SMADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        cell = (SMADetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMADetailCell" owner:nil options:nil] lastObject];
    }
    cell.oval.strokeColor = [SmaColor colorWithHexString:@"#F688EB" alpha:1].CGColor;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
        cell.distanceLab.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    else if (indexPath.row == dataArr.count - 1){
        cell.botLine.hidden = YES;
        cell.distanceLab.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    else{
        cell.distanceLab.attributedText = [[dataArr  objectAtIndex:indexPath.row] objectForKey:@"LAST"];
    }
    cell.timeLab.text = [[dataArr  objectAtIndex:indexPath.row] objectForKey:@"TIME"];
    cell.statelab.text = [[dataArr  objectAtIndex:indexPath.row] objectForKey:@"TYPE"];
//    cell.distanceLab.text = [NSString stringWithFormat:@"%@%@",[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue] ] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark *******UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == mainScroll && scrollView.contentOffset.y < 145 && cycle == 0) {
        detailTabView.scrollEnabled = NO;
        [detailTabView setContentOffset:CGPointMake(0.0, 0) animated:NO];
    }
    if (scrollView.contentOffset.y >= 145 && scrollView == mainScroll && cycle == 0) {
        scrollView.contentOffset = CGPointMake(0, 145);
        detailTabView.scrollEnabled = YES;
        return;
    }
}

#pragma mark *******UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMADetailCollectionCell *cell = (SMADetailCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
    cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"soberSleep"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"soberSleep"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else if (indexPath.row == 1){
         cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"simpleSleep"] intValue]/60],@"h",[NSString stringWithFormat:@"%d",[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"simpleSleep"] intValue]%60],@"m"] fontArr:@[FontGothamLight(35),FontGothamLight(15)]];
    }
    else{
         cell.detailLab.attributedText = [[NSAttributedString alloc] initWithString:[self avgSleepType:[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"sleepHour"] intValue] deepAmount:[[[dataArr objectAtIndex:showDataIndex] objectForKey:@"deepSleep"] intValue]] attributes:@{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#2CCB6F" alpha:1],NSFontAttributeName:FontGothamLight(30)}];
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

#pragma mark******corePlotViewDelegate
- (void)barTouchDownAtRecordIndex:(NSUInteger)idx{
    showDataIndex = idx - 1;
    [detailColView reloadData];
}

#pragma mark <ZXRollViewDelegate>
- (NSInteger)numberOfItemsInRollView:(ZXRollView *)rollView {
    return 3;
}

- (void)rollView:(nonnull ZXRollView *)rollView setViewForRollView:(nonnull UIView *)view atIndex:(NSInteger)index {
//     view.tag = 301 + index;
    showViewTag = view.tag;
    if (selectTag != 101) {
          [self addSPViewMode:1 superView:view];
    }
    else{
        [self addSleepOneDateWithSuperView:view];
    }
    NSLog(@"fwqfewf==%d  %d",index,view.tag);
    switch (index) {
        case 0: {
            if (!firstCreate && selectTag != 101) {
                [self drawScattViewWithSpArr:alldata];
                firstCreate = YES;
            }
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(ZXRollView *)scrollView AtIndex:(NSInteger)index{
    switch (selectTag) {
        case 101:
        {
            NSDate *changeDate = [self.date timeDifferenceWithNumbers:index];
            if ([changeDate.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
                self.date = changeDate ;
                [self addSubViewWithCycle:0];
            }
            [self screeningSleepNowData:[self.dal readSleepDataWithDate:changeDate.yyyyMMddNoLineWithDate]];
            [self drawSleepOneDateView];
        }
            break;
        case 102:
        {
            NSDate *firstdate = [NSDate date];
            for (int j = 0; j < -index ; j ++) {
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = firstdate;
                    firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
                    firstdate = firstdate.yesterday;
                    if (j == - index - 1) {
                        [self getDetalilDataWithNowDate:firstdate month:NO updateUI:NO];
                    }
                }
            }
            if (index == 0) {
                [self getDetalilDataWithNowDate:[NSDate date] month:NO updateUI:NO];
            }
        }
            break;
        default:
            break;
    }
    if (selectTag != 101) {
        [self drawScattViewWithSpArr:alldata];
    }
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
    /* 	1-3深睡到未睡---深睡时间
     *   2-1清醒到深睡---浅睡时间
     *   2-3清醒到未睡---浅睡时间
     *   3-2未睡到清醒---清醒时间
     */
    NSMutableArray *detailDataArr = [NSMutableArray array];
     NSMutableArray *detailSLArr = [NSMutableArray array];
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
        if (i == 0) {
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"入睡")}];
        }
        else if (i == sortArr.count - 1){
            [detailDataArr addObject:@{@"TIME":[self getHourAndMin:dic[@"TIME"]],@"TYPE":SMALocalizedString(@"醒来")}];
        }
        else{
            [detailSLArr addObject:@{@"TIME":[NSString stringWithFormat:@"%d",prevTime<600?(prevTime+120):(prevTime - 1320)],@"QUALITY":[NSString stringWithFormat:@"%d",prevType],@"SLEEPTIME":[NSString stringWithFormat:@"%d",amount]}];
            [detailDataArr addObject:@{@"TIME":[NSString stringWithFormat:@"%@-%@",[self getHourAndMin:[NSString stringWithFormat:@"%d",prevTime]],[self getHourAndMin:dic[@"TIME"]]],@"TYPE":[self sleepType:prevType],@"LAST":[self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",amount/60],@"h",[NSString stringWithFormat:@"%d",amount%60],@"m"] fontArr:@[FontGothamLight(19),FontGothamLight(15)]]}];
        }
        prevType = [dic[@"TYPE"] intValue];
        prevTime = [dic[@"TIME"] intValue];
    }
    NSArray *orderArr = [[detailDataArr reverseObjectEnumerator] allObjects];
    dataArr = [orderArr mutableCopy];
    alldata = detailSLArr;
    int sleepHour = soberAmount + simpleSleepAmount + deepSleepAmount;
       NSMutableArray *sleep = [NSMutableArray array];
    [sleep addObject:[NSString stringWithFormat:@"%d",sleepHour]];
    [sleep addObject:[NSString stringWithFormat:@"%d",deepSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",simpleSleepAmount]];
    [sleep addObject:[NSString stringWithFormat:@"%d",soberAmount]];
    return sleep;
}

- (void)getDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month updateUI:(BOOL)update{
    NSDate *firstdate = date;
    NSMutableArray *weekDataArr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        int sleepHourSum = 0;
        int deepSleepAmountSum = 0;
        int simpleSleepAmountSum = 0;
        int soberAmountSum = 0;
        int account = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        for (int j = 0; j < 7; j ++) {
          
            NSMutableArray *weekData =  [self screeningSleepNowData:[self.dal readSleepDataWithDate:[firstdate timeDifferenceWithNumbers:j].yyyyMMddNoLineWithDate]];
            if ([[weekData firstObject] intValue]!= 0) {
                account ++;
                sleepHourSum = [[weekData objectAtIndex:0] intValue] + sleepHourSum;
                 deepSleepAmountSum = [[weekData objectAtIndex:1] intValue] + deepSleepAmountSum;
                 simpleSleepAmountSum = [[weekData objectAtIndex:2] intValue] + simpleSleepAmountSum;
                 soberAmountSum = [[weekData objectAtIndex:3] intValue] + soberAmountSum;
            }
            if (j == 6) {
                NSString *date;
                if ([firstdate.yyyyMMddNoLineWithDate isEqualToString:[[NSDate date] firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSString class]]]) {
                    date = SMALocalizedString(@"本周");
                }
                else{
                    date = [NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:nextDate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]];
                }
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",sleepHourSum/account],@"sleepHour",[NSString stringWithFormat:@"%d",deepSleepAmountSum/account],@"deepSleep",[NSString stringWithFormat:@"%d",simpleSleepAmountSum/account],@"simpleSleep",[NSString stringWithFormat:@"%d",soberAmountSum/account],@"soberSleep",date,@"DATE", nil];
                [weekDataArr addObject:dic];
            }
            
        }
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    alldata = [NSMutableArray array];
    dataArr = [[[weekDataArr reverseObjectEnumerator] allObjects] mutableCopy];
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
        }
        else{
            [xText addObject:[[weekDataArr objectAtIndex:4 - i] objectForKey:@"DATE"]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDataArr objectAtIndex:4 - i] objectForKey:@"sleepHour"]];
        }
    }
    [alldata addObject:xText];
    [alldata addObject:yBaesValues];
    [alldata addObject:yValue];
    showDataIndex = 3;
    if (update) {
        [self addSubViewWithCycle:1];
    }
}

- (NSString *)getHourAndMin:(NSString *)time{
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
    if (sleepTime >= 9) {
        sleepState = SMALocalizedString(@"device_SL_typeT");
    }
    else if (sleepTime >= 6 && sleepTime <= 8 && deepTime >= 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepTime >= 6 && sleepTime <= 8 && deepTime >= 3 && deepTime < 4){
        sleepState = SMALocalizedString(@"device_SL_typeS");
    }
    else if (sleepTime < 6 || deepTime < 3){
        sleepState = SMALocalizedString(@"device_SL_typeF");
    }
    return sleepState;
}

- (NSMutableAttributedString *)sleepTimeWithFall:(NSString *)fall wakeUp:(NSString *)wake{
    int fallTime = [[[fall componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[fall componentsSeparatedByString:@":"] lastObject] intValue];
    int wakeTime = [[[wake componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[wake componentsSeparatedByString:@":"] lastObject] intValue];
    int sleepTime = wakeTime - fallTime;
    return [self attributedStringWithArr:@[[NSString stringWithFormat:@"%d",sleepTime/60],@"h",[NSString stringWithFormat:@"%d",sleepTime%60],@"m"] fontArr:@[FontGothamLight(20),FontGothamLight(15)]];
}

@end
