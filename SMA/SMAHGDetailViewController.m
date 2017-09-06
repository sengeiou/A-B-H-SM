//
//  SMAHGDetailViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAHGDetailViewController.h"

@interface SMAHGDetailViewController ()
{
    UIScrollView *mainScroll;
    UITableView *detailTabView;
    UICollectionView *detailColView;
    WYScrollView *WYLocalScrollView;
    UILabel *quiethrLab;
    NSInteger selectTag;
    NSUInteger showDataIndex;
    NSMutableArray *quietArr;
    NSArray *collectionArr;
    NSDate *quietDate;
    NSDate *dateNow;
    NSDate *leftDate;
    NSDate *rightDate;
    NSMutableArray *aggregateData;
    int cycle;
    int oldDirection ;
    CGFloat tableHeight;
    UIView *tabBarView;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMAHGDetailViewController
static NSString * const reuseIdentifier = @"SMAHGDetailCollectionCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
//    [self addSubViewWithCycle:0];
     [self initializeMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)initializeMethod{
    
//    self.title = [self dateWithYMDWithDate:self.date];
    dateNow = self.date;
    leftDate = self.date.yesterday;
    rightDate = [self.date timeDifferenceWithNumbers:1];
    NSMutableArray *nowData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:dateNow.yyyyMMddNoLineWithDate toDate:dateNow.yyyyMMddNoLineWithDate detailData:YES] withDate:dateNow];
    NSMutableArray *leftData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:leftDate.yyyyMMddNoLineWithDate toDate:leftDate.yyyyMMddNoLineWithDate detailData:YES] withDate:leftDate];
    NSMutableArray *rightData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:rightDate.yyyyMMddNoLineWithDate toDate:rightDate.yyyyMMddNoLineWithDate detailData:YES] withDate:rightDate];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252/255.0 green:78/255.0 blue:27/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
//    self.view.backgroundColor = [UIColor blueColor];
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    mainScroll.contentSize = CGSizeMake(MainScreen.size.width, 600);
    mainScroll.delegate = self;
    mainScroll.backgroundColor = [UIColor colorWithRed:252/255.0 green:78/255.0 blue:27/255.0 alpha:1];
    [self.view addSubview:mainScroll];
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 1)];
    lineView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
    [tabBarView addSubview:lineView];
    
    NSArray *stateArr = @[SMALocalizedString(@"device_SP_day"),SMALocalizedString(@"device_SP_week"),SMALocalizedString(@"device_SP_month")];
    for (int i = 0; i < 3; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = (MainScreen.size.width - 60)/3;
        but.frame = CGRectMake(10 + (width + 20) * i, (self.tabBarController.tabBar.frame.size.height - 30)/2, width, 30);
        but.titleLabel.font = FontGothamLight(17);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 10;
        but.layer.borderColor = [SmaColor colorWithHexString:@"#ffb446" alpha:1].CGColor;
        but.layer.borderWidth = 1;
        but.tag = 101 + i;
        if (i == 0) {
            but.selected = YES;
            selectTag = but.tag;
        }
        [but setTitle:stateArr[i] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#ffb446" alpha:1] forState:UIControlStateNormal];
        [but setTitleColor:[SmaColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateSelected];
        [but setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 30)] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageWithColor:[SmaColor colorWithHexString:@"#ffb446" alpha:1] size:CGSizeMake(width, 30)] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(hrTapBut:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:but];
    }
    [self.view addSubview:tabBarView];
}

- (void)addSubViewWithCycle:(int)Cycle{
    self.view.frame = CGRectMake(0, 64, MainScreen.size.width, MainScreen.size.height);
    cycle = Cycle;
    for (UIView *view in mainScroll.subviews) {
        [view removeFromSuperview];
    }
    UIView *detailBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreen.size.width, MainScreen.size.height * 0.372)];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = detailBackView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:252/255.0 green:78/255.0 blue:27/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:255/255.0 green:180/255.0 blue:70/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [detailBackView.layer insertSublayer:_gradientLayer atIndex:0];
    
    [mainScroll addSubview:detailBackView];
    /** 设置本地scrollView的Frame及所需图片*/
//    WYLocalScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height * 0.372) WithLocalImages:aggregateData];
    WYLocalScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height * 0.372) WithLocalImages:aggregateData];
    /** 设置滚动延时*/
//    WYLocalScrollView.AutoScrollDelay = 0;
//    WYLocalScrollView.selectColor = selectTag == 101 ? YES : NO;
//    WYLocalScrollView.xRangeLength = selectTag == 101 ? 31 : 4;
//    WYLocalScrollView.xCoordinateDecimal = selectTag == 101 ? 0 : 0.5;
//    WYLocalScrollView.mode = selectTag == 101 ? CPTGraphScatterPlot : CPTGraphBarPlot;
//    WYLocalScrollView.identifiers = @[@"heartDate",@"heartDate1"];
//    WYLocalScrollView.categorymode = 2;
//    WYLocalScrollView.barOffset = selectTag == 101 ? 0 : 0.005;
//    WYLocalScrollView.barIntermeNumber = @[selectTag == 101?@"0.97":@"0.03",@"0.97"];
//    WYLocalScrollView.showBarGoap = selectTag == 101 ? NO : YES;
//    WYLocalScrollView.lineColors = @[selectTag == 101?[CPTColor colorWithComponentRed:205/255.0 green:226/255.0 blue:251/255.0 alpha:0.8]:[CPTColor colorWithComponentRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1],[CPTColor colorWithComponentRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0]];
    WYLocalScrollView.HGDayDraw = YES;
//    WYLocalScrollView.yValueHiden = selectTag == 101 ? NO : NO;
//    WYLocalScrollView.banRightSlide = selectTag == 101 ? ([_date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate] ? YES : NO) : YES;
//    /** 获取本地图片的index*/
//    WYLocalScrollView.localDelagate = self;
    /** 添加到当前View上*/
    WYLocalScrollView.HGPolylineDraw = Cycle;
    [detailBackView addSubview:WYLocalScrollView];
    [WYLocalScrollView setMaxImageCount];
    WYLocalScrollView.yDraw = NO;
    // 促使视图切换时候保证图像不变化
    [mainScroll setContentOffset:CGPointMake(0, 0)];
//    [self setViewTop:0 preference:YES];
    if (cycle == 0) {
        mainScroll.scrollEnabled = NO;
        //        WYLocalScrollView.yDraw = YES;
        //         NSMutableArray *HRArr = [aggregateData[1][2] mutableCopy];
        //        NSInteger max = [[HRArr valueForKeyPath:@"@max.intValue"] integerValue];
        //        WYLocalScrollView.coordsLab = [NSString stringWithFormat:@"%lD",max/2];
        //        WYLocalScrollView.coordsPlace = CGRectGetHeight(WYLocalScrollView.frame)/2;
        
//        UIView *quietView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(WYLocalScrollView.frame), MainScreen.size.width,44)];
//        quietView.backgroundColor = [SmaColor colorWithHexString:@"#EA1F75" alpha:1];
//        UIButton *quietBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        quietBut.frame = CGRectMake(0, 0, MainScreen.size.width, CGRectGetHeight(quietView.frame));
//        quietBut.tag = 104;
//        [quietBut addTarget:self action:@selector(hrTapBut:) forControlEvents:UIControlEventTouchUpInside];
//        [quietView addSubview:quietBut];
//        
//        UIImageView *indexView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20, CGRectGetHeight(quietView.frame)/2-7.5, 9, 15)];
//        indexView.image = [UIImage imageNamed:@"icon_next"];
//        [quietView addSubview:indexView];
//        
//        quiethrLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(indexView.frame) - 90, 0, 80, CGRectGetHeight(quietView.frame))];
//        quiethrLab.attributedText = [self attributedStringWithArr:@[quietArr.count > 0?[[quietArr firstObject] objectForKey:@"HEART"]:@"0",@"bpm"] fontArr:@[FontGothamLight(20),FontGothamLight(16)] textColor:[UIColor greenColor]];
//        quiethrLab.textAlignment = NSTextAlignmentRight;
//        [quietView addSubview:quiethrLab];
//        
//        UILabel *quietLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreen.size.width - CGRectGetWidth(quiethrLab.frame) - CGRectGetWidth(indexView.frame) - 45, CGRectGetHeight(quietView.frame))];
//        quietLab.font = FontGothamLight(16);
//        quietLab.textColor = [UIColor greenColor];
//        quietLab.text = SMALocalizedString(@"device_HR_quiet");
//        [quietView addSubview:quietLab];
        
//        [mainScroll addSubview:quietView];
        
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        stateView.backgroundColor = [UIColor greenColor];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = FontGothamLight(15);
        timeLab.text = SMALocalizedString(@"device_SP_time");
        [stateView addSubview:timeLab];
        
        UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 150, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.text = SMALocalizedString(@"收缩压/舒张压");
        stateLab.font = FontGothamLight(15);
        //        stateLab.backgroundColor = [UIColor greenColor];
        [stateView addSubview:stateLab];
        
        [mainScroll addSubview:stateView];
        
        //        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(stateView.frame) - CGRectGetHeight(quietView.frame)) style:UITableViewStylePlain];
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame)+1, MainScreen.size.width, (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(detailBackView.frame)) style:UITableViewStylePlain];
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        detailTabView.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:0];
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        detailTabView.tableFooterView = [[UIView alloc] init];
        //        detailTabView.scrollEnabled = NO;
        [mainScroll addSubview:detailTabView];
        CGFloat scrollHeight = MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height;
        tableHeight = (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(WYLocalScrollView.frame) - CGRectGetHeight(detailBackView.frame) - CGRectGetHeight(stateView.frame);
        //        [self setViewTop:0 preference:YES];
        //        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(stateLab.frame)+ [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145):CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(stateLab.frame)+ [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0);
        
        //        NSLog(@"f2fgrhg==%f  %f  %@  %f", (CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(stateLab.frame)+ [[[aggregateData objectAtIndex:1] objectAtIndex:3] count] * 44.0),(MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height),NSStringFromCGSize(mainScroll.contentSize),MainScreen.size.height);
    }
    else{
        
        mainScroll.scrollEnabled = YES;
        NSInteger selectIndex;
//        selectIndex = [[aggregateData[1] objectAtIndex:7] integerValue];
//        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:selectIndex-1];
        if (!collectionArr) {
            collectionArr = @[SMALocalizedString(@"device_HR_mean"),SMALocalizedString(@"device_HR_avgQuiet"),SMALocalizedString(@"device_HR_avgMax"),SMALocalizedString(@"device_HR_avgMonitor")];
        }
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-1)/2, ([UIScreen mainScreen].bounds.size.width-1)/2);
        
        //创建collectionView 通过一个布局策略layout来创建
        detailColView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame) + 1, MainScreen.size.width, [UIScreen mainScreen].bounds.size.width-1) collectionViewLayout:layout];
        detailColView.backgroundColor = [SmaColor colorWithHexString:@"#FFFFFF" alpha:0];
        detailColView.delegate= self;
        detailColView.dataSource = self;
        detailColView.scrollEnabled = NO;
        [detailColView registerNib:[UINib nibWithNibName:@"SMADetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        [mainScroll addSubview:detailColView];
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, CGRectGetHeight(WYLocalScrollView.frame) + CGRectGetHeight(detailColView.frame));
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

- (void)hrTapBut:(UIButton *)sender{
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
//                self.title = [self dateWithYMDWithDate:dateNow];
//                leftDate = self.date.yesterday;
//                rightDate = [self.date timeDifferenceWithNumbers:1];
//                NSMutableArray *nowData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:dateNow.yyyyMMddNoLineWithDate toDate:dateNow.yyyyMMddNoLineWithDate detailData:YES] withDate:dateNow];
//                NSMutableArray *leftData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:leftDate.yyyyMMddNoLineWithDate toDate:leftDate.yyyyMMddNoLineWithDate detailData:YES] withDate:leftDate];
//                NSMutableArray *rightData = [self gethrFullDatasForOneDay:[self.dal readHearReatDataWithDate:rightDate.yyyyMMddNoLineWithDate toDate:rightDate.yyyyMMddNoLineWithDate detailData:YES] withDate:rightDate];
//                if (aggregateData) {
//                    [aggregateData removeAllObjects];
//                    aggregateData = nil;
//                }
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:leftData];
//                [aggregateData addObject:nowData];
//                [aggregateData addObject:rightData];
                
                //                quietDate = self.date;
//                quietDate = [NSDate date];
//                quietArr = [self.dal readQuietHearReatDataWithDate:[quietDate timeDifferenceWithNumbers:-10].yyyyMMddNoLineWithDate toDate:quietDate.yyyyMMddNoLineWithDate];
                [self addSubViewWithCycle:0];
            }
                break;
            case 102:
            {
//                dateNow = [NSDate date];
//                leftDate = [dateNow timeDifferenceWithNumbers:-28];
//                rightDate = [dateNow timeDifferenceWithNumbers:28];
//                NSMutableArray *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:NO];
//                NSMutableArray *MDataArr = [self gethrDetalilDataWithNowDate:dateNow month:NO];
//                NSMutableArray *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:NO];
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:lDataArr];
//                [aggregateData addObject:MDataArr];
//                [aggregateData addObject:RDataArr];
//                NSLog(@"aggregateData 102== %@",aggregateData);
                [self addSubViewWithCycle:1];
            }
                break;
            case 103:
            {
//                dateNow = [NSDate date];
//                NSDate *firstdate = dateNow;
//                for (int i = 0; i < 4; i ++ ) {
//                    NSDate *nextDate = firstdate;
//                    firstdate = [nextDate dayOfMonthToDateIndex:0];
//                    firstdate = firstdate.yesterday;
//                    if (i == 3) {
//                        leftDate = firstdate;
//                    }
//                }
//                NSDate *lastdate = dateNow;
//                for (int i = 0; i < 4; i ++ ) {
//                    NSDate *nextDate = lastdate;
//                    lastdate = [nextDate dayOfMonthToDateIndex:32];
//                    lastdate = [lastdate timeDifferenceWithNumbers:1];
//                    if (i == 3) {
//                        rightDate = lastdate;
//                    }
//                }
//                NSMutableArray *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:YES];
//                NSMutableArray *MDataArr = [self gethrDetalilDataWithNowDate:dateNow month:YES];
//                NSMutableArray *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:YES];
//                aggregateData = [NSMutableArray array];
//                [aggregateData addObject:lDataArr];
//                [aggregateData addObject:MDataArr];
//                [aggregateData addObject:RDataArr];
                
                [self addSubViewWithCycle:1];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark ******UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[aggregateData objectAtIndex:1] objectAtIndex:5]  count];
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
    else if (indexPath.row == [[[aggregateData objectAtIndex:1] objectAtIndex:5] count] - 1){
        cell.botLine.hidden = YES;
    }
    cell.timeLab.text = [self getHourAndMin:[[[[aggregateData objectAtIndex:1] objectAtIndex:5]  objectAtIndex:indexPath.row] objectForKey:@"TIME"]] ;
    cell.statelab.text = @"";
    cell.distanceLab.text = [NSString stringWithFormat:@"%@bpm",[[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:indexPath.row] objectForKey:@"REAT"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr fontArr:(NSArray *)fontArr textColor:(UIColor *)color{
    NSMutableAttributedString *sportStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:fontArr[0]};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:fontArr[1]};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [sportStr appendAttributedString:str];
    }
    return sportStr;
}

#pragma mark *******UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"gwgg==%f  %@",scrollView.contentOffset.y,NSStringFromCGSize(mainScroll.contentSize));
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
//        showDataIndex = [[[aggregateData objectAtIndex:1] objectAtIndex:7] integerValue];
    }
    if (indexPath.row == 0) {
        
//        cell.detailLab.attributedText = [self attributedStringWithArr:@[[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:showDataIndex],@"bpm"] fontArr:@[FontGothamLight(35),FontGothamLight(18)] textColor:[UIColor blackColor]];
    }
    else if (indexPath.row == 1){
//        cell.detailLab.attributedText = [self attributedStringWithArr:@[[[[aggregateData objectAtIndex:1] objectAtIndex:6] objectAtIndex:showDataIndex],@"bpm"] fontArr:@[FontGothamLight(35),FontGothamLight(18)] textColor:[UIColor blackColor]];
    }
    else if (indexPath.row == 2){
//        cell.detailLab.attributedText = [self attributedStringWithArr:@[[[aggregateData objectAtIndex:1] objectAtIndex:2][showDataIndex],@"bpm"] fontArr:@[FontGothamLight(35),FontGothamLight(18)] textColor:[UIColor blackColor]];
    }
    else{
        cell.detailLab.textColor = [SmaColor colorWithHexString:@"#EA1F75" alpha:1];
//        if ([[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:showDataIndex] intValue] < 60) {
//            cell.detailLab.text = SMALocalizedString(@"device_HR_typeS");
//        }
//        else if ([[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:showDataIndex] intValue] >= 60 && [[[[aggregateData objectAtIndex:1] objectAtIndex:5] objectAtIndex:showDataIndex] intValue] <= 100){
//            cell.detailLab.text = SMALocalizedString(@"device_HR_typeF");
//        }
//        else{
//            cell.detailLab.text = SMALocalizedString(@"device_HR_typeT");
//        }
    }
//    cell.titleLab.text = collectionArr[indexPath.row];
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

- (NSMutableArray *)gethrFullDatasForOneDay:(NSMutableArray *)dayArr withDate:(NSDate *)date{
    NSMutableArray *fullDatas = [[NSMutableArray alloc] init];
    NSMutableArray *dayAlldata = [NSMutableArray array];
    SmaHRHisInfo *hrinfo = [SMAAccountTool HRHisInfo];
    int hrCycle =  hrinfo.tagname.intValue;
    if (!hrinfo) {
        hrCycle = 30;
    }
    int cyTime = hrCycle==15?96:hrCycle==30?48:hrCycle==60?24:12;
    for (int i = 0; i < cyTime; i ++) {
        BOOL found = NO;
        int time = -1 ;
        if (dayArr.count > 0 && [[[dayArr lastObject] objectForKey:@"TIME"] intValue]/(1440/cyTime)>=i) {
            for (NSDictionary *dic in dayArr) {
                int add = [[dic objectForKey:@"TIME"] intValue]/(1440/cyTime);
                //                if ([[dic objectForKey:@"TIME"] intValue]%(1440/cyTime) != 0) {
                //                    add ++;
                //                }
                if (add == i) {
                    if (time == i) {
                        [fullDatas removeLastObject];
                    }
                    time = i;
                    NSMutableDictionary *newDic = [dic mutableCopy];
                    [newDic setObject:[NSString stringWithFormat:@"%d",i*hrCycle] forKey:@"TIME"];
                    [fullDatas addObject:newDic];
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
            [fullDatas addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i*hrCycle],@"TIME",@"0",@"REAT",date.yyyyMMddNoLineWithDate,@"DATE", nil]];
        }
    }
    NSMutableArray *xText = [NSMutableArray array];
    NSMutableArray *yValue = [NSMutableArray array];
    NSMutableArray *yBaesValues = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray array];
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
    NSArray *invertedArr = [[dataArr reverseObjectEnumerator] allObjects];
    [dayAlldata addObject:xText];
    [dayAlldata addObject:yBaesValues];
    [dayAlldata addObject:yValue];
    [dayAlldata addObject:invertedArr];
    [dayAlldata addObject:date.yyyyMMddNoLineWithDate];
    [dayAlldata addObject:dayArr];
    return dayAlldata;
}


- (NSString *)getHourAndMin:(NSString *)time{
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

@end
