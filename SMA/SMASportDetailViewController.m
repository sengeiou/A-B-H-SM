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
    ZXRollView *detailScroll;
    UITableView *detailTabView;
    UICollectionView *detailColView;
    ScattView *scattView;
    int cycle;
    NSUInteger showDataIndex;
    NSInteger selectTag;
    NSMutableArray *dataArr;
    NSArray *collectionArr;
    NSMutableArray *alldata;
    BOOL firstCreate;
    NSDate *dateNow;
}
@property (nonatomic, strong) SMADatabase *dal;

@end

@implementation SMASportDetailViewController
//@synthesize detailScroll;

static NSString * const reuseIdentifier = @"SMADetailCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self ui];
    [self createUI];
    [self initializeMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    alldata = [self getFullDatasForOneDay:[self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES]];
    [self addSubViewWithCycle:0];
//    [self drawSPViewMode:1 spData:spArr];
}

- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.backgroundColor = [SmaColor colorWithHexString:@"#5790F9" alpha:1];
    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 1)];
    lineView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
    [tabBarView addSubview:lineView];
    
    NSArray *stateArr = @[SMALocalizedString(@"device_SP_day"),SMALocalizedString(@"device_SP_week"),SMALocalizedString(@"device_SP_month")];
    for (int i = 0; i < 3; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = (MainScreen.size.width - 120)/3;

        but.frame = CGRectMake(35 + (width + 25)*i, (self.tabBarController.tabBar.frame.size.height - 30)/2, width, 30);
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
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
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
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        stateView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = FontGothamLight(15);
        timeLab.text = SMALocalizedString(@"device_SP_time");
//        timeLab.backgroundColor = [UIColor greenColor];
        [stateView addSubview:timeLab];
        
        UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 150, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.text = SMALocalizedString(@"device_SP_state");
        stateLab.font = FontGothamLight(15);
//        stateLab.backgroundColor = [UIColor greenColor];
        [stateView addSubview:stateLab];
        
        [mainScroll addSubview:stateView];
        
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, 600 - CGRectGetHeight(detailScroll.frame) - CGRectGetHeight(stateView.frame)) style:UITableViewStylePlain];
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateLab.frame)+ dataArr.count * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? 600:CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateLab.frame)+ dataArr.count * 44.0);
    }
    else{
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
                alldata  = [self getFullDatasForOneDay:[self.dal readSportDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate lastData:YES]];
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
                [self getDetalilDataWithNowDate:dateNow month:YES updateUI:YES];
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
    }
    else if (indexPath.row == dataArr.count - 1){
        cell.botLine.hidden = YES;
    }
    cell.timeLab.text = [self getHourAndMin:[[dataArr  objectAtIndex:indexPath.row] objectForKey:@"TIME"]];
    cell.distanceLab.text = [NSString stringWithFormat:@"%@%@",[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"TIME"] intValue] ] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")];
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
        cell.detailLab.text = [NSString stringWithFormat:@"%d",[[[alldata objectAtIndex:2] objectAtIndex:showDataIndex] intValue]/[[[alldata objectAtIndex:3] objectAtIndex:showDataIndex] intValue]];
    }
    else if (indexPath.row == 1){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[alldata objectAtIndex:2] valueForKeyPath:@"@sum.intValue"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[alldata objectAtIndex:2] objectAtIndex:showDataIndex]intValue] ] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[SMACalculate notRounding:[SMACalculate countCalWithSex:[SMAAccountTool userInfo].userSex userWeight:[[SMAAccountTool userInfo].userWeigh floatValue] step:[[[alldata objectAtIndex:2] objectAtIndex:showDataIndex] intValue]/[[[alldata objectAtIndex:3] objectAtIndex:showDataIndex] intValue]] afterPoint:1],SMALocalizedString(@"device_SP_cal")]];
    }
    else{
        cell.detailLab.text = @"0min";
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
    showDataIndex = idx;
    [detailColView reloadData];
}

#pragma mark <ZXRollViewDelegate>
- (NSInteger)numberOfItemsInRollView:(ZXRollView *)rollView {
        return 3;
}

- (void)rollView:(nonnull ZXRollView *)rollView setViewForRollView:(nonnull UIView *)view atIndex:(NSInteger)index {
     [self addSPViewMode:1 superView:view];
    switch (index) {
        case 0: {
             if (!firstCreate) {
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
             alldata = [self getFullDatasForOneDay:[self.dal readSportDataWithDate:changeDate.yyyyMMddNoLineWithDate toDate:changeDate.yyyyMMddNoLineWithDate lastData:YES]];
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
        case 103:
        {
            NSDate *firstdate = [NSDate date];
            for (int j = 0; j < -index ; j ++) {
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = firstdate;
                    firstdate = [nextDate dayOfMonthToDateIndex:0];
                    firstdate = firstdate.yesterday;
                    if (j == - index - 1) {
                        [self getDetalilDataWithNowDate:firstdate month:YES updateUI:NO];
                    }
                }
            }
            if (index == 0) {
                [self getDetalilDataWithNowDate:[NSDate date] month:YES updateUI:NO];
            }
        }
            break;
        default:
            break;
    }
    [self drawScattViewWithSpArr:alldata];
}

- (void)getDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month updateUI:(BOOL)update{
    NSDate *firstdate = date;
    NSMutableArray *weekDate = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        int step = 0;
        int dataNum = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        NSMutableArray *weekData = [self.dal readSportDataWithDate:firstdate.yyyyMMddNoLineWithDate toDate:nextDate.yyyyMMddNoLineWithDate lastData:YES];
        if (weekData.count > 0) {
            for (int i = 0; i < (int)weekData.count - 1; i ++) {
                dataNum ++;
                step = [[weekData[i] objectForKey:@"STEP"] intValue] + step;
                if (i == weekData.count - 2) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:nextDate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM", nil];
                    [weekDate addObject:dic];
                }
            }
        }
        else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"STEP",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:nextDate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]],@"DATE",[NSString stringWithFormat:@"%d",dataNum],@"NUM", nil];
            [weekDate addObject:dic];
        }
        firstdate = firstdate.yesterday;
        dateNow = firstdate;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    alldata = [NSMutableArray array];
    NSMutableArray *numArr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++ ) {
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
            [numArr addObject:@"0"];
        }
        else{
            [xText addObject:month?[self getMonthText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"]]:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"]];
            [yBaesValues addObject:@"0"];
            [yValue addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"STEP"]];
            [numArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"NUM"]];
        }
    }
    [alldata addObject:xText];
    [alldata addObject:yBaesValues];
    [alldata addObject:yValue];
    [alldata addObject:numArr];
    showDataIndex = 4;
    if (update) {
        [self addSubViewWithCycle:1];
    }
}

- (id)getFullDatasForOneDay:(NSMutableArray *)spDatas{
    dataArr = [[[[spDatas lastObject] reverseObjectEnumerator] allObjects] mutableCopy];
    NSMutableArray *fullDatas = [[NSMutableArray alloc] init];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    for (int i = 0; i < 24; i ++) {
        BOOL found = NO;
        int time = -1 ;
        if (spDatas.count > 1) {
            for (NSDictionary *dic in [spDatas lastObject]) {
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
                        [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[[spDatas lastObject] lastObject] objectForKey:@"DATE"],@"DATE", nil]];
                    }
                }
            }
        }
        else{
            [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"TIME",@"0",@"STEP",[[[spDatas lastObject] lastObject] objectForKey:@"DATE"],@"DATE", nil]];
        }
    }
    
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    for (int i = 0; i < 25; i ++) {
        if (i == 0 || i == 12 || i == 23) {
            [xText addObject:[NSString stringWithFormat:@"%@%d:00",i<10?@"":@"",i]];
        }
        else{
            [xText addObject:@""];
        }
    }
    for (int i = 0; i < 26; i ++) {
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
    [dayAlldata addObject:xText];
    [dayAlldata addObject:yBaesValues];
    [dayAlldata addObject:yValue];
    return dayAlldata;
}

- (NSString *)getMonthText:(NSString *)str{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *monArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@"%@%@",[monArr firstObject],SMALocalizedString(@"device_SP_month")];
}

- (NSString *)getHourAndMin:(NSString *)time{
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
