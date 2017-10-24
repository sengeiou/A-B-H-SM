//
//  SMAHGDetailViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAHGDetailViewController.h"
#import "UIBarButtonItem+CKQ.h"

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
    UIView *baseView;
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

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)initializeMethod{
    
    self.title = [self dateWithYMDWithDate:self.date];
    dateNow = self.date;
    leftDate = self.date.yesterday;
    rightDate = [self.date timeDifferenceWithNumbers:1];
    NSDictionary *nowData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:dateNow.yyyyMMddNoLineWithDate] withDate:dateNow];
    NSDictionary *leftData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:leftDate.yyyyMMddNoLineWithDate] withDate:leftDate];
    NSDictionary *rightData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:rightDate.yyyyMMddNoLineWithDate] withDate:rightDate];
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

- (void)runButton{
    baseView = [[UIView alloc] initWithFrame:MainScreen];
    NSString *titStr = SMALocalizedString(@"device_bp_remind");
    CGRect titRect = [titStr boundingRectWithSize:CGSizeMake(MainScreen.size.width - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontGothamLight(17)} context:nil];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width - 50, (titRect.size.height > MainScreen.size.height/3.2 ? MainScreen.size.height/3.2:titRect.size.height) + 40)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.center = CGPointMake(MainScreen.size.width/2, MainScreen.size.height/2);
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8.0;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 4, MainScreen.size.width - 60, (titRect.size.height > MainScreen.size.height/3.2 ? MainScreen.size.height/3.2:titRect.size.height))];
    textView.text = titStr;
    textView.font = FontGothamLight(17);
    textView.editable = NO;
    textView.selectable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.center = CGPointMake(backView.frame.size.width/2, textView.center.y);
    [backView addSubview:textView];

    UILabel *minLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame) + 4, CGRectGetWidth(textView.frame), CGRectGetHeight(backView.frame) - CGRectGetHeight(textView.frame) - 12)];
    minLab.font = FontGothamLight(14);
    minLab.textColor = [UIColor redColor];
    minLab.center = CGPointMake(backView.frame.size.width/2, minLab.center.y);
    minLab.text = SMALocalizedString(@"device_bp_remind1");
    [backView addSubview:minLab];
    baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [baseView addSubview:backView];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [baseView addGestureRecognizer:tap];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:baseView];
}

- (void)tapView{
    [baseView removeFromSuperview];
}

- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252/255.0 green:78/255.0 blue:27/255.0 alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"icon_shuoming_n" highIcon:@"icon_shuoming_h" frame:CGRectMake(0, 0, 45, 30) target:self action:@selector(runButton) transfrom:0];
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
    WYLocalScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height * 0.372) WithLocalImages:aggregateData];
    WYLocalScrollView.HGDayDraw = YES;
    WYLocalScrollView.banRightSlide = selectTag == 101 ? ([_date.yyyyMMddNoLineWithDate isEqualToString:[NSDate date].yyyyMMddNoLineWithDate] ? YES : NO) : YES;
//    /** 获取本地图片的index*/
    WYLocalScrollView.localDelagate = self;
    /** 添加到当前View上*/
    WYLocalScrollView.HGPolylineDraw = Cycle;
    [detailBackView addSubview:WYLocalScrollView];
    [WYLocalScrollView setMaxImageCount];
    WYLocalScrollView.yDraw = NO;
    // 促使视图切换时候保证图像不变化
    [mainScroll setContentOffset:CGPointMake(0, 0)];
    [self setViewTop:0 preference:YES];
    if (cycle == 0) {
        mainScroll.scrollEnabled = NO;
        
        UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailBackView.frame), MainScreen.size.width, self.tabBarController.tabBar.frame.size.height)];
        stateView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = FontGothamLight(15);
        timeLab.text = SMALocalizedString(@"device_SP_time");
        [stateView addSubview:timeLab];
        
        UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 150, 0, 150, self.tabBarController.tabBar.frame.size.height)];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.text = [NSString stringWithFormat:@"%@/%@",SMALocalizedString(@"device_bp_systolic"),SMALocalizedString(@"device_bp_diastolic")];
        stateLab.font = FontGothamLight(15);
        stateLab.numberOfLines = 0;
        stateLab.adjustsFontSizeToFitWidth = YES;
        [stateView addSubview:stateLab];
        
        [mainScroll addSubview:stateView];
        
        detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateView.frame)+1, MainScreen.size.width, (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(detailBackView.frame)) style:UITableViewStylePlain];
        detailTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
                detailTabView.backgroundColor = [UIColor whiteColor];
        detailTabView.delegate = self;
        detailTabView.dataSource = self;
        [mainScroll addSubview:detailTabView];
        tableHeight = (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) - CGRectGetHeight(detailBackView.frame) - CGRectGetHeight(stateView.frame);

    }
    else{
        mainScroll.scrollEnabled = YES;
        self.title = [aggregateData objectAtIndex:1][@"Xtext"][showDataIndex];
        if (!collectionArr) {
            collectionArr = @[SMALocalizedString(@"device_bp_avg"),SMALocalizedString(@"device_bp_max"),SMALocalizedString(@"device_bp_min"),SMALocalizedString(@"device_HR_avgMonitor")];
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
    CGFloat drawHeight = ([[aggregateData objectAtIndex:1][@"YPOINT"] count] * 44 - tableHeight)/2;//由于tableview上滑会隐藏cell导致产生量，大概偏差为CELL的一半
    if (drawHeight > 100) {
        drawHeight = 100;
    }
    if (viewTop <= - drawHeight) {
        viewTop = - drawHeight;
    }
    if (viewTop >= 0) {
        viewTop = 0;
    }
    CGFloat height = [[aggregateData objectAtIndex:1][@"YPOINT"] count] * 44;
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
                self.title = [self dateWithYMDWithDate:dateNow];
                leftDate = self.date.yesterday;
                rightDate = [self.date timeDifferenceWithNumbers:1];
                NSDictionary *nowData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:dateNow.yyyyMMddNoLineWithDate ] withDate:dateNow];
                NSDictionary *leftData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:leftDate.yyyyMMddNoLineWithDate] withDate:leftDate];
                NSDictionary *rightData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:rightDate.yyyyMMddNoLineWithDate] withDate:rightDate];
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
                NSDictionary *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:NO];
                NSDictionary *MDataArr = [self gethrDetalilDataWithNowDate:dateNow month:NO];
                NSDictionary *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:NO];
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:lDataArr];
                [aggregateData addObject:MDataArr];
                [aggregateData addObject:RDataArr];
                showDataIndex = 3;
//                NSLog(@"aggregateData 102== %@",aggregateData);
                [self addSubViewWithCycle:1];
            }
                break;
            case 103:
            {
                dateNow = [NSDate date];
                NSDate *firstdate = dateNow;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = firstdate;
                    firstdate = [nextDate dayOfMonthToDateIndex:0];
                    firstdate = firstdate.yesterday;
                    if (i == 3) {
                        leftDate = firstdate;
                    }
                }
                NSDate *lastdate = dateNow;
                for (int i = 0; i < 4; i ++ ) {
                    NSDate *nextDate = lastdate;
                    lastdate = [nextDate dayOfMonthToDateIndex:32];
                    lastdate = [lastdate timeDifferenceWithNumbers:1];
                    if (i == 3) {
                        rightDate = lastdate;
                    }
                }
                NSDictionary *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:YES];
                NSDictionary *MDataArr = [self gethrDetalilDataWithNowDate:dateNow month:YES];
                NSDictionary *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:YES];
                aggregateData = [NSMutableArray array];
                [aggregateData addObject:lDataArr];
                [aggregateData addObject:MDataArr];
                [aggregateData addObject:RDataArr];
                showDataIndex = 3;
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
    return [[aggregateData objectAtIndex:1][@"YPOINT"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        cell = (SMADetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMADetailCell" owner:nil options:nil] lastObject];
    }
    cell.oval.strokeColor = [SmaColor colorWithHexString:@"#ffb446" alpha:1].CGColor;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    else if (indexPath.row == [[aggregateData objectAtIndex:1][@"YPOINT"] count] - 1){
        cell.botLine.hidden = YES;
    }
    cell.botLine.backgroundColor = [SmaColor colorWithHexString:@"#fc4e1b" alpha:1].CGColor;
    cell.topLine.backgroundColor = [SmaColor colorWithHexString:@"#fc4e1b" alpha:1].CGColor;
    cell.timeLab.text = [self getHourAndMin:[[aggregateData objectAtIndex:1][@"XPOINT"] objectAtIndex:indexPath.row]] ;
    cell.statelab.text = @"";
    cell.distanceLab.text = [NSString stringWithFormat:@"%@/%@mmHg",[[aggregateData objectAtIndex:1][@"YPOINT1"] objectAtIndex:indexPath.row],[[aggregateData objectAtIndex:1][@"YPOINT"] objectAtIndex:indexPath.row]];
    cell.disW.constant = 120;
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
        
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%.0f/%.0f",[[aggregateData objectAtIndex:1][@"AVG"][showDataIndex][0] floatValue],[[aggregateData objectAtIndex:1][@"AVG"][showDataIndex][1] floatValue]],@"mmHg"] fontArr:@[FontGothamLight(30),FontGothamLight(17)] textColor:[UIColor blackColor]];
    }
    else if (indexPath.row == 1){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%@/%@",[aggregateData objectAtIndex:1][@"SHRINK"][showDataIndex][1],[aggregateData objectAtIndex:1][@"RELAX"][showDataIndex][1]],@"mmHg"] fontArr:@[FontGothamLight(30),FontGothamLight(17)] textColor:[UIColor blackColor]];
    }
    else if (indexPath.row == 2){
        cell.detailLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%@/%@",[aggregateData objectAtIndex:1][@"SHRINK"][showDataIndex][0],[aggregateData objectAtIndex:1][@"RELAX"][showDataIndex][0]],@"mmHg"] fontArr:@[FontGothamLight(30),FontGothamLight(17)] textColor:[UIColor blackColor]];
    }
    else{
        cell.detailLab.textColor = [SmaColor colorWithHexString:@"#ffb446" alpha:1];
        cell.detailLab.font = FontGothamLight(30);
        float avgShink = [[aggregateData objectAtIndex:1][@"AVG"][showDataIndex][0] floatValue];
        float avgRelax = [[aggregateData objectAtIndex:1][@"AVG"][showDataIndex][1] floatValue];
        NSString *modeStr = SMALocalizedString(@"device_bp_normal");
        if (avgShink > 141 || avgRelax > 91) {
            modeStr = SMALocalizedString(@"device_bp_high");
        }
        if (avgShink < 89 || avgRelax < 59) {
            modeStr = SMALocalizedString(@"device_bp_low");
        }
        cell.detailLab.text = modeStr;
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
                    NSDictionary *leftData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:leftDate.yyyyMMddNoLineWithDate] withDate:leftDate];
                    [aggregateData insertObject:leftData atIndex:0];
                    [aggregateData removeLastObject];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
            else if (direction == 1){
                rightDate = [dateNow timeDifferenceWithNumbers:2];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *rightData = [self gethrFullDatasForOneDay:[self.dal selectBPDataWihtDate:rightDate.yyyyMMddNoLineWithDate] withDate:rightDate];
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    leftDate = [dateNow timeDifferenceWithNumbers:-56];
                    NSDictionary *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:NO];
                    [aggregateData insertObject:lDataArr atIndex:0];
                    [aggregateData removeLastObject];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
            else if (direction == 1){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    rightDate = [dateNow timeDifferenceWithNumbers:56];
                    NSDictionary *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:NO];
                    [aggregateData addObject:RDataArr];
                    [aggregateData removeObjectAtIndex:0];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
        }
    }
    else if (selectTag == 103){
        if (oldDirection != direction) {
            if (direction == -1) {
                //获取所需要预加载的日期（dateNow 的前八个月）
                NSDate *firstdate1 = dateNow;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *nowMonth = [[formatter stringFromDate:firstdate1] substringWithRange:NSMakeRange(4, 2)];
                int goalMonth;
                NSString *goalDate;
                if (nowMonth.intValue - 8 < 1){
                    goalMonth = nowMonth.intValue - 8 + 12;
                    goalDate = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%d",[[[formatter stringFromDate:firstdate1] substringToIndex:4] intValue] - 1],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                }
                else{
                    goalMonth = nowMonth.intValue - 8;
                    goalDate = [NSString stringWithFormat:@"%@%@%@",[[formatter stringFromDate:firstdate1] substringToIndex:4],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                }
                leftDate = [formatter dateFromString:goalDate];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *lDataArr = [self gethrDetalilDataWithNowDate:leftDate month:YES];
                    [aggregateData insertObject:lDataArr atIndex:0];
                    [aggregateData removeLastObject];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
            }
            else if (direction == 1){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *nowMonth = [[formatter stringFromDate:dateNow] substringWithRange:NSMakeRange(4, 2)];
                int goalMonth;
                NSString *goalDate;
                if (nowMonth.intValue + 8 > 12) {
                    goalMonth = nowMonth.intValue + 8 - 12;
                    goalDate = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%d",[[[formatter stringFromDate:dateNow] substringToIndex:4] intValue] + 1],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                }
                else{
                    goalMonth = nowMonth.intValue + 8;
                    goalDate = [NSString stringWithFormat:@"%@%@%@",[[formatter stringFromDate:dateNow] substringToIndex:4],[NSString stringWithFormat:@"%@%d",goalMonth > 10 ? @"":@"0",goalMonth],@"10"];
                }
                rightDate = [formatter dateFromString:goalDate];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *RDataArr = [self gethrDetalilDataWithNowDate:rightDate month:YES];
                    [aggregateData addObject:RDataArr];
                    [aggregateData removeObjectAtIndex:0];
                    NSLog(@"scrollViewWillToBorderAtDirection = %d",direction);
                });
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
        mainScroll.contentSize = CGSizeMake(MainScreen.size.width, (CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height + [[aggregateData objectAtIndex:1][@"YPOINT"] count] * 44.0) >= (MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) ? ((MainScreen.size.height - 64 - self.tabBarController.tabBar.frame.size.height) + 145):CGRectGetHeight(WYLocalScrollView.frame) + self.tabBarController.tabBar.frame.size.height + [[aggregateData objectAtIndex:1][@"YPOINT"] count] * 44.0);
    }
    else if (selectTag == 102){
        if (oldDirection == -1) {
            dateNow = [leftDate timeDifferenceWithNumbers:28];
            rightDate = [dateNow timeDifferenceWithNumbers:28];
        }
        else if (oldDirection == 1){
            dateNow = [rightDate timeDifferenceWithNumbers:-28];
            leftDate = [dateNow timeDifferenceWithNumbers:-28];
        }
        NSInteger selectIndex;
        showDataIndex = 3;
//        selectIndex = [[aggregateData[1] objectAtIndex:7] integerValue];
        self.title = [aggregateData[1][@"Xtext"] lastObject];
        if ([self.title isEqualToString:SMALocalizedString(@"device_SL_thisWeek")]) {
            scrollView.banRightSlide = YES;
        }
        else{
            scrollView.banRightSlide = NO;
        }
    }
    else if (selectTag == 103){
        if (oldDirection == -1) {
            NSDate *lastdate = leftDate;
            for (int i = 0; i < 4; i ++ ) {
                NSDate *nextDate = lastdate;
                lastdate = [nextDate dayOfMonthToDateIndex:32];
                lastdate = [lastdate timeDifferenceWithNumbers:1];
                if (i == 3) {
                    dateNow = lastdate;
                }
            }
            lastdate = dateNow;
            for (int i = 0; i < 4; i ++ ) {
                NSDate *nextDate = lastdate;
                lastdate = [nextDate dayOfMonthToDateIndex:32];
                lastdate = [lastdate timeDifferenceWithNumbers:1];
                if (i == 3) {
                    rightDate = lastdate;
                }
            }
        }
        else if (oldDirection == 1){
            NSDate *firstdate = rightDate;
            for (int i = 0; i < 4; i ++ ) {
                NSDate *nextDate = firstdate;
                firstdate = [nextDate dayOfMonthToDateIndex:0];
                firstdate = firstdate.yesterday;
                if (i == 3) {
                    dateNow = firstdate;
                }
            }
            firstdate = dateNow;
            for (int i = 0; i < 4; i ++ ) {
                NSDate *nextDate = firstdate;
                firstdate = [nextDate dayOfMonthToDateIndex:0];
                firstdate = firstdate.yesterday;
                if (i == 3) {
                    leftDate = firstdate;
                }
            }
        }
        NSInteger selectIndex;
        showDataIndex = 3;
//      selectIndex = [[aggregateData[1] objectAtIndex:7] integerValue];
        self.title = [aggregateData[1][@"Xtext"] lastObject];
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
    //    quietDate = dateNow;
//    quietDate = [NSDate date];
//    quietArr = [self.dal readQuietHearReatDataWithDate:[quietDate timeDifferenceWithNumbers:-10].yyyyMMddNoLineWithDate toDate:quietDate.yyyyMMddNoLineWithDate];
//    quiethrLab.attributedText = [self attributedStringWithArr:@[quietArr.count > 0?[[quietArr firstObject] objectForKey:@"HEART"]:@"0",@"bpm"] fontArr:@[FontGothamLight(20),FontGothamLight(16)]textColor:[UIColor whiteColor]];
    NSLog(@"scrollViewDidEndDecelerating = %@",scrollView);
}

- (void)WYplotTouchDown{
    mainScroll.scrollEnabled = NO;
}

- (void)WYplotTouchUp{
    mainScroll.scrollEnabled = YES;
}

- (void)WYbarTouchDownAtRecordIndex:(NSUInteger)idx {
    if (selectTag != 101) {
//        showDataIndex = idx;
//        self.title = [[aggregateData[1] objectAtIndex:0] objectAtIndex:showDataIndex-1];
//        [detailColView reloadData];
//        mainScroll.scrollEnabled = YES;
    }
}

- (void)didSelectBpData:(NSDictionary *)dic selIndex:(NSInteger)index{
    NSLog(@"dic  =%@ index %d",dic,index);
    showDataIndex = index;
    [detailColView reloadData];
}

- (NSDictionary *)gethrFullDatasForOneDay:(NSMutableArray *)dayArr withDate:(NSDate *)date{
    NSMutableArray *sinkArr = [NSMutableArray array];
    NSMutableArray *relaxationArr = [NSMutableArray array];
    NSMutableArray *TimeArr = [NSMutableArray array];
//    NSString *BPdate;
    for (int i = 0; i < dayArr.count; i ++) {
        NSDictionary *dic = dayArr[i];
        [sinkArr addObject:dic[@"SHRINK"]];
        [relaxationArr addObject:dic[@"RELAXATION"]];
        [TimeArr addObject:dic[@"TIME"]];
//        date = dic[@"DATE"];
    }
    NSDictionary *dayAlldata = [NSDictionary dictionaryWithObjectsAndKeys:sinkArr,@"YPOINT1",relaxationArr,@"YPOINT",TimeArr,@"XPOINT",@[@"0",@"12",@"24"],@"Xtext",date.yyyyMMddByLineWithDate,@"DATE", nil];
    return dayAlldata;
}

- (NSDictionary *)gethrDetalilDataWithNowDate:(NSDate *)date month:(BOOL)month{
    NSDate *firstdate = date;
    NSMutableArray *XtextData = [NSMutableArray array];
    NSMutableArray *shrinkData = [NSMutableArray array];
    NSMutableArray *relaxData = [NSMutableArray array];
    NSMutableArray *avgData = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSDate *nextDate = firstdate;
        NSDate *lastdate ;
        NSString *dateStr;
        if (month) {
            firstdate = [nextDate dayOfMonthToDateIndex:0];
            lastdate = nextDate;
            NSString *longDateStr = [NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]];
            dateStr = [self getMonthText:longDateStr year:[firstdate.yyyyMMddNoLineWithDate substringToIndex:4]];
            
        }
        else{
            firstdate = [nextDate firstDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
            lastdate = [nextDate lastDayOfWeekToDateFormat:@"yyyyMMdd" callBackClass:[NSDate class]];
          NSString *longDateStr = [NSString stringWithFormat:@"%@-%@",[SMADateDaultionfos monAndDateStringFormDateStr:firstdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"],[SMADateDaultionfos monAndDateStringFormDateStr:lastdate.yyyyMMddNoLineWithDate format:@"yyyyMMdd"]];
            dateStr = [self getWeekText:longDateStr year:[firstdate.yyyyMMddNoLineWithDate substringToIndex:4]];
        }
        quietDate = [NSDate date];
        NSDictionary *weekData = [self.dal reatGatherBPDataWithDate:firstdate.yyyyMMddNoLineWithDate toDate:lastdate.yyyyMMddNoLineWithDate];
        
        [XtextData addObject:dateStr];
        [shrinkData addObject:@[weekData[@"MINSHRINK"],weekData[@"MAXSHRIMK"]]];
        [relaxData addObject:@[weekData[@"MINRELAX"],weekData[@"MAXRELAX"]]];
        [avgData addObject:@[weekData[@"AVGSHRIMK"],weekData[@"AVGRELAX"]]];
        firstdate = firstdate.yesterday;
    }
    
    NSDictionary *dic = @{@"Xtext":[[XtextData reverseObjectEnumerator] allObjects],@"SHRINK":[[shrinkData reverseObjectEnumerator] allObjects],@"RELAX":[[relaxData reverseObjectEnumerator] allObjects],@"AVG":[[avgData reverseObjectEnumerator] allObjects]};
    return dic;
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
    //    monStr = [NSString stringWithFormat:@"%@%@",[monArr firstObject],SMALocalizedString(@"device_SP_month")];
    //    if ([[monArr firstObject] intValue] == 1) {
    monStr = [NSString stringWithFormat:@"%@",SMALocalizedString([NSString stringWithFormat:@"month%d",[[monArr firstObject] intValue]])];
    //    }
    if ([[monArr firstObject] intValue] == [[[[NSDate date] yyyyMMddNoLineWithDate] substringWithRange:NSMakeRange(4, 2)] intValue] && [year isEqualToString:[[[NSDate date] yyyyMMddNoLineWithDate] substringToIndex:4]]) {
        monStr = SMALocalizedString(@"device_SL_thisMonth");
    }
    return monStr;
}

- (NSString *)getHourAndMin:(NSString *)time{
    NSString *hour = [NSString stringWithFormat:@"%d",time.intValue/60];
    NSString *min = [NSString stringWithFormat:@"%@%d",time.intValue%60 < 10?@"0":@"",time.intValue%60];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

@end
