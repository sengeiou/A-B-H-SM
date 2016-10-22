//
//  SMAHRDetailViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAHRDetailViewController.h"

@interface SMAHRDetailViewController ()
{
    UIScrollView *mainScroll;
    ZXRollView *detailScroll;
    UITableView *detailTabView;
    UICollectionView *detailColView;
    ScattView *scattView;
    NSInteger selectTag;
    NSUInteger showDataIndex;
    BOOL firstCreate;
    BOOL indexChange;
    NSMutableArray *dataArr;
    NSMutableArray *alldata;
    NSArray *collectionArr;
    int cycle;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMAHRDetailViewController
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
    alldata = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES]];
    [self addSubViewWithCycle:0];
}

- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    mainScroll.backgroundColor = [UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1];
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
        but.layer.borderColor = [SmaColor colorWithHexString:@"#EA2277" alpha:1].CGColor;
        but.layer.borderWidth = 1;
        but.tag = 101 + i;
        if (i == 0) {
            but.selected = YES;
            selectTag = but.tag;
        }
        [but setTitle:stateArr[i] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#EA2277" alpha:1] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateSelected];
        [but setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 30)] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageWithColor:[SmaColor colorWithHexString:@"#EA2277" alpha:1] size:CGSizeMake(width, 30)] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(hrTapBut:) forControlEvents:UIControlEventTouchUpInside];
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
                             (id)[[UIColor colorWithRed:234/255.0 green:31/255.0 blue:117/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:249/255.0 green:162/255.0 blue:192/255.0 alpha:1]  CGColor],  nil];
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
        UIView *quietView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailScroll.frame), MainScreen.size.width,44)];
        quietView.backgroundColor = [SmaColor colorWithHexString:@"#EA1F75" alpha:1];
        UIButton *quietBut = [UIButton buttonWithType:UIButtonTypeCustom];
        quietBut.frame = CGRectMake(0, 0, MainScreen.size.width, CGRectGetHeight(quietView.frame));
        quietBut.tag = 104;
        [quietBut addTarget:self action:@selector(hrTapBut:) forControlEvents:UIControlEventTouchUpInside];
        [quietView addSubview:quietBut];
        
        UIImageView *indexView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20, CGRectGetHeight(quietView.frame)/2-7.5, 9, 15)];
        indexView.image = [UIImage imageNamed:@"icon_next"];
        [quietView addSubview:indexView];
        
        UILabel *quiethrLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(indexView.frame) - 90, 0, 80, CGRectGetHeight(quietView.frame))];
        quiethrLab.attributedText = [self attributedStringWithArr:@[@"256",@"bmp"] fontArr:@[FontGothamLight(20),FontGothamLight(16)]];
        quiethrLab.textAlignment = NSTextAlignmentRight;
        [quietView addSubview:quiethrLab];
        
        UILabel *quietLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreen.size.width - CGRectGetWidth(quiethrLab.frame) - CGRectGetWidth(indexView.frame) - 45, CGRectGetHeight(quietView.frame))];
        quietLab.font = FontGothamLight(16);
        quietLab.text = @"静息心率";
        [quietView addSubview:quietLab];
        
        [mainScroll addSubview:quietView];
        
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(quietView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        stateView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = FontGothamLight(15);
        timeLab.text = SMALocalizedString(@"device_SP_time");
        //        timeLab.backgroundColor = [UIColor greenColor];
        [stateView addSubview:timeLab];
        
        UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 150, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.text = SMALocalizedString(@"心率");
        stateLab.font = FontGothamLight(15);
        //        stateLab.backgroundColor = [UIColor greenColor];
        [stateView addSubview:stateLab];
        
        [mainScroll addSubview:stateView];
        
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, 600 - CGRectGetHeight(detailScroll.frame) - CGRectGetHeight(stateView.frame) - CGRectGetHeight(quietView.frame)) style:UITableViewStylePlain];
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTabView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateLab.frame)+ dataArr.count * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? 600:CGRectGetHeight(detailScroll.frame) + CGRectGetHeight(stateLab.frame)+ dataArr.count * 44.0);
    }
    else{
        if (!collectionArr) {
            collectionArr = @[SMALocalizedString(@"平均心率"),SMALocalizedString(@"平均静息"),SMALocalizedString(@"平均最大"),SMALocalizedString(@"平均监测")];
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

- (void)addSPViewMode:(int)mode superView:(UIView *)view{
    if (scattView) {  //若没有此段，则当使用3.5寸手机切换月份时会产生两个柱状图，导致每个图都显示不全，原因不明
        [scattView removeFromSuperview];
        scattView = nil;
    }
    
    if (!scattView) {
        scattView = [[ScattView alloc] init];
        scattView.frame = detailScroll.bounds;//10, 134, 300, 140
        //         scattView.frame = CGRectMake(0, 0,  MainScreen.size.width, 260);
        scattView.backgroundColor = [UIColor clearColor];
        [view addSubview:scattView];
        
    }
    scattView.delegate = self;
    scattView.HRdataArr = [NSMutableArray array];
    scattView.YgiveLsat = cycle == 0 ? YES:NO;//隐藏Y轴数据最后一位
    scattView.DrawMode = mode==0?0:1;
    scattView.allowsUserInteraction =  mode==0?1:0;
    scattView.poinColors = [CPTColor whiteColor];
    scattView.showLegend = NO;
    scattView.isZoom = NO;
    scattView.xCoordinateDecimal = 0.0f;
    scattView.hideYAxisLabels = YES;
    scattView.showBarGoap = YES;
    scattView.plotAreaFramePaddingLeft = -10;
    scattView.yAxisTexts = @[@""];
    scattView.xMajorIntervalLength = @"1";
}

- (void)drawScattViewWithSpArr:(NSMutableArray *)spArr{
    if ([spArr[2] count]<30 && selectTag == 101) {
        detailScroll.scrollView.scrollEnabled = YES;
    }
    scattView.identifiers = selectTag == 101?@[@"Sleep Pattern",@"Sleep Pattern1"]:@[@"Sleep Pattern",@"Sleep Pattern1"];  //随便定义
    scattView.xAxisTexts = [spArr firstObject];
    scattView.yValues = selectTag == 101?@[spArr[2],spArr[1]]:@[spArr[2],spArr[3]];
    scattView.yBaesValues = selectTag == 101?@[]:@[spArr[1],spArr[4]];
    scattView.barLineWidth = [spArr[2] count] >10 ?7.0f:5;
    scattView.selectIdx = [spArr[2] count] - 1;//
    scattView.ylabelLocation = [[spArr[2] valueForKeyPath:@"@max.intValue"] intValue];//可以yValue最大值为基准
    scattView.barIntermeNumber = @[selectTag == 101?@"0.97":@"0.08",@"0.97"];
    scattView.selectColor = selectTag == 101?NO:YES;
    scattView.lineColors =@[selectTag == 101?[CPTColor colorWithComponentRed:205/255.0 green:226/255.0 blue:251/255.0 alpha:0.8]:[CPTColor colorWithComponentRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8],[CPTColor colorWithComponentRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0]];
    [scattView initGraph];
    [detailColView reloadData];
    [detailTabView reloadData];
}

- (void)hrTapBut:(UIButton *)sender{
    if (sender.tag == 104) {
        
        return;
    }
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
                alldata = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:self.date.yyyyMMddNoLineWithDate toDate:self.date.yyyyMMddNoLineWithDate detailData:YES]];
                [self addSubViewWithCycle:0];
            }
                break;
            case 102:
            {
                [self gethrDetalilDataWithNowDate:[NSDate date] month:NO updateUI:YES];
            }
                break;
            case 103:
            {
                [self gethrDetalilDataWithNowDate:[NSDate date] month:YES updateUI:YES];
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
    cell.timeLab.text = [[dataArr  objectAtIndex:indexPath.row] objectForKey:@"TIME"];
    cell.statelab.text = @"";
    cell.distanceLab.text = [NSString stringWithFormat:@"%@bmp",[[dataArr  objectAtIndex:indexPath.row] objectForKey:@"REAT"]];
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
        
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[[alldata lastObject] objectAtIndex:showDataIndex],@"bmp"] fontArr:@[FontGothamLight(35),FontGothamLight(18)]];
    }
    else if (indexPath.row == 1){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[@"0",@"bpm"] fontArr:@[FontGothamLight(35),FontGothamLight(18)]];
        //        cell.detailLab.attributedText = [self attributedStringWithArr:@[[SMAAccountTool userInfo].unit.intValue?[SMACalculate notRounding:[SMACalculate convertToMile:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[alldata objectAtIndex:2] valueForKeyPath:@"@sum.intValue"] intValue]]] afterPoint:1]:[SMACalculate notRounding:[SMACalculate countKMWithHeigh:[[SMAAccountTool userInfo].userHeight floatValue] step:[[[alldata objectAtIndex:2] objectAtIndex:showDataIndex]intValue] ] afterPoint:1],[SMAAccountTool userInfo].unit.intValue?SMALocalizedString(@"device_SP_mile"):SMALocalizedString(@"device_SP_km")]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[alldata objectAtIndex:2][showDataIndex],@"bmp"] fontArr:@[FontGothamLight(35),FontGothamLight(18)]];
    }
    else{
        cell.detailLab.textColor = [SmaColor colorWithHexString:@"#EA1F75" alpha:1];
        if ([[[alldata lastObject] objectAtIndex:showDataIndex] intValue] < 60) {
            cell.detailLab.text = SMALocalizedString(@"偏低");
        }
        else if ([[[alldata lastObject] objectAtIndex:showDataIndex] intValue] >= 60 && [[[alldata lastObject] objectAtIndex:showDataIndex] intValue] <= 100){
            cell.detailLab.text = SMALocalizedString(@"正常");
        }
        else{
            cell.detailLab.text = SMALocalizedString(@"偏高");
        }
        //
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

- (void)plotTouchDownAtRecordPoit:(CGPoint)poit{
    if ([alldata.firstObject count]>30 && selectTag == 101) {
        detailScroll.scrollView.scrollEnabled = NO;
        mainScroll.scrollEnabled = NO;
    }
}

- (void)plotTouchUpAtRecordPoit:(CGPoint)poit{
    mainScroll.scrollEnabled = YES;
    
}

- (void)prepareForDrawingPlotLine:(CGPoint)poit{
    //    NSLog(@"prepareForDrawingPlotLine %@",NSStringFromCGPoint(poit));
    if (poit.x == 0) {
        detailScroll.scrollView.scrollEnabled = YES;
        //         [detailScroll becomeFirstResponder];
    }
    else if (poit.x <= -670){
        detailScroll.scrollView.scrollEnabled = YES;
    }
}

#pragma mark <ZXRollViewDelegate>
- (NSInteger)numberOfItemsInRollView:(ZXRollView *)rollView {
    return 3;
}


- (void)rollView:(nonnull ZXRollView *)rollView setViewForRollView:(nonnull UIView *)view atIndex:(NSInteger)index {
    if (firstCreate) {
        indexChange = YES;
    }
    if (selectTag == 101) {
        [self addSPViewMode:0 superView:view];
    }
    else{
        [self addSPViewMode:1 superView:view];
    }
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
    if (indexChange) {
        indexChange = NO;
        switch (selectTag) {
            case 101:
            {
                NSDate *changeDate = [self.date timeDifferenceWithNumbers:index];
                alldata = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:changeDate.yyyyMMddNoLineWithDate toDate:changeDate.yyyyMMddNoLineWithDate detailData:YES]];
                if ([changeDate.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
                    self.date = changeDate ;
                    [self addSubViewWithCycle:0];
                }
                else{
                    [self drawScattViewWithSpArr:alldata];
                }
                
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
                            [self gethrDetalilDataWithNowDate:firstdate month:NO updateUI:NO];
                        }
                    }
                }
                if (index == 0) {
                    [self gethrDetalilDataWithNowDate:[NSDate date] month:NO updateUI:NO];
                }
                [self drawScattViewWithSpArr:alldata];
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
                            [self gethrDetalilDataWithNowDate:firstdate month:YES updateUI:NO];
                        }
                    }
                }
                if (index == 0) {
                    [self gethrDetalilDataWithNowDate:[NSDate date] month:YES updateUI:NO];
                }
                [self drawScattViewWithSpArr:alldata];
            }
                break;
            default:
                break;
        }
    }
}


- (NSMutableArray *)gethrFullDatasForOneDay:(NSMutableArray *)dayArr{
    
    //    NSMutableArray *fulldata = [NSMutableArray array];
    NSMutableArray *fullDatas = [[NSMutableArray alloc] init];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    SmaHRHisInfo *hrinfo = [SMAAccountTool HRHisInfo];
    int hrCycle =  hrinfo.tagname.intValue;
    if (!hrinfo) {
        hrCycle = 30;
    }
    hrCycle = 15;
    int cyTime = hrCycle==15?96:hrCycle==30?48:hrCycle==60?24:12;
    for (int i = 0; i < cyTime; i ++) {
        BOOL found = NO;
        int time = -1 ;
        if (dayArr.count > 0 && [[[dayArr lastObject] objectForKey:@"TIME"] intValue]/(1440/cyTime)>=i) {
            for (NSDictionary *dic in dayArr) {
                if ([[dic objectForKey:@"TIME"] intValue]/(1440/cyTime) == i) {
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
                        [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i*hrCycle],@"TIME",[[fullDatas lastObject] objectForKey:@"REAT"]?[[fullDatas lastObject] objectForKey:@"REAT"]:@"0",@"REAT",[dic objectForKey:@"DATE"],@"DATE", nil]];
                    }
                }
            }
        }
        else{
            [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i*hrCycle],@"TIME",@"0",@"REAT",self.date.yyyyMMddNoLineWithDate,@"DATE", nil]];
        }
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    for (int i = 0; i < cyTime; i ++) {
        if (i == 0) {
            [xText addObject:[NSString stringWithFormat:@"%d",i]];
        }
        else if ((cyTime/2 == i && cyTime%2 == 0)){
            [xText addObject:[NSString stringWithFormat:@"%d",12]];
        }
        else if (i == cyTime - 1){
            [xText addObject:[NSString stringWithFormat:@"%d",23]];
        }
        else{
            [xText addObject:@""];
        }
    }
    for (int i = 0; i < cyTime + 1; i ++) {
        if (i == 0) {
            [yValue addObject:@"0"];
        }
        else{
            NSDictionary *dic = [fullDatas objectAtIndex:i - 1];
            [yValue addObject:[dic objectForKey:@"REAT"]];
            if ([[dic objectForKey:@"REAT"] intValue] > 0) {
                NSMutableDictionary *dict = [dic mutableCopy];
                [dict setObject:[self getHourAndMin:[dic objectForKey:@"TIME"]] forKey:@"TIME"];
                [dataArr addObject:dict];
            }
        }
        [yBaesValues addObject:@"0"];
    }
    [dayAlldata addObject:xText];
    [dayAlldata addObject:yBaesValues];
    [dayAlldata addObject:yValue];
    return dayAlldata;
}

- (void)gethrDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month updateUI:(BOOL)update{
    NSDate *firstdate = date;
    NSMutableArray *weekDate = [NSMutableArray array];
    int allMax = 0;
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        int maxHR = 0;
        int avgHR = 0;
        int minHR = 0;
        int dataNum = 0;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
        }
        NSMutableArray *weekData = [self.dal readHearReatDataWithDate:firstdate.yyyyMMddNoLineWithDate toDate:nextDate.yyyyMMddNoLineWithDate detailData:NO];
        if (weekData.count > 0) {
            for (int i = 0; i < (int)weekData.count; i ++) {
                dataNum ++;
                maxHR = [[weekData[i] objectForKey:@"maxHR"] intValue] + maxHR;
                avgHR = [[weekData[i] objectForKey:@"avgHR"] intValue] + avgHR;
                minHR = [[weekData[i] objectForKey:@"minHR"] intValue] + minHR;
                if (i == weekData.count - 1) {
                    if (allMax < maxHR/dataNum) {
                        allMax = maxHR/dataNum;
                    }
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",maxHR/dataNum],@"maxHR",[NSString stringWithFormat:@"%d",avgHR/dataNum],@"avgHR",[NSString stringWithFormat:@"%d",minHR/dataNum],@"minHR",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:nextDate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]],@"DATE", nil];
                    [weekDate addObject:dic];
                }
            }
        }
        else{
            if (allMax < maxHR/dataNum) {
                allMax = maxHR/dataNum;
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",maxHR/dataNum],@"maxHR",[NSString stringWithFormat:@"%d",avgHR/dataNum],@"avgHR",[NSString stringWithFormat:@"%d",minHR/dataNum],@"minHR",[NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:nextDate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]],@"DATE", nil];
            [weekDate addObject:dic];
        }
        firstdate = firstdate.yesterday;
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yValue1 = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *yBaesValues1 = [NSMutableArray array];
    NSMutableArray *avgArr = [NSMutableArray array];
    alldata = [NSMutableArray array];
    for (int i = 0; i < 5; i ++ ) {
        [yValue1 addObject:[NSString stringWithFormat:@"%d",allMax + 10]];
        [yBaesValues1 addObject:@"0"];
        if (i == 0) {
            [yBaesValues addObject:@"0"];
            [yValue addObject:@"0"];
            [avgArr addObject:@"0"];
        }
        else{
            [xText addObject:month?[self getMonthText:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"]]:[[weekDate objectAtIndex:4 - i] objectForKey:@"DATE"]];
            [yBaesValues addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"minHR"]];
            [yValue addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"maxHR"]];
            [avgArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"avgHR"]];
            //            [numArr addObject:[[weekDate objectAtIndex:4 - i] objectForKey:@"NUM"]];
        }
    }
    [alldata addObject:xText];
    [alldata addObject:yBaesValues];
    [alldata addObject:yValue];
    [alldata addObject:yValue1];
    [alldata addObject:yBaesValues1];
    [alldata addObject:avgArr];
    showDataIndex = 4;
    if (update) {
        [self addSubViewWithCycle:1];
    }
    
}

- (NSString *)getMonthText:(NSString *)str{
    NSArray *dayArr = [str componentsSeparatedByString:@"-"];
    NSArray *monArr = [[dayArr firstObject] componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@"%@%@",[monArr firstObject],SMALocalizedString(@"device_SP_month")];
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

- (NSString *)getHourAndMin:(NSString *)time{
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}
@end
