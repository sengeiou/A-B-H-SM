//
//  WYScrollView.m
//  无忧学堂
//
//  Created by jacke－xu on 16/2/22.
//  Copyright © 2016年 jacke－xu. All rights reserved.
//

#import "WYScrollView.h"
#import "UIImageView+WebCache.h"

#define pageSize 16

//获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define pageColor RGB(67, 199, 176)

/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height

@interface WYScrollView () <UIScrollViewDelegate,corePlotViewDelegate>

@end

@implementation WYScrollView
{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
//    __strong  ScattView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    
    /** 当前显示的是第几个*/
    NSInteger _currentIndex;
    
    /** 当前滑动方向*/
    NSInteger _orientationIndex;
    
    /** 当前显示位置*/
    NSInteger _nowIndex;
    
    /** 图片个数*/
    NSInteger _MaxImageCount;
    
    /** 是否是网络图片*/
    BOOL _isNetworkImage;
}

#pragma mark - 本地图片

-(instancetype)initWithFrame:(CGRect)frame WithLocalImages:(NSMutableArray *)imageArray
{
    if (imageArray.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetworkImage = NO;
        
        /** 创建滚动view*/
        [self createScrollView];
        
        /** 加入本地image*/
        [self setImageArray:imageArray];
        
        /** 设置数量*/
//        [self setMaxImageCount:_imageArray.count];
    }
    
    return self;
}

#pragma mark - 网络图片

-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSMutableArray *)imageArray
{
    if (imageArray.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        _isNetworkImage = YES;
        /** 创建滚动view*/
        [self createScrollView];
        /** 加入本地image*/
        [self setImageArray:imageArray];
        /** 设置数量*/
//        [self setMaxImageCount:_imageArray.count];
    }
    return self;
}

#pragma mark - 设置数量

-(void)setMaxImageCount
{
    _MaxImageCount = _imageArray.count;
    
     /** 复用imageView初始化*/
    [self initImageView];
    
    /** pageControl*/
    [self createPageControl];
    
    /** 定时器*/
//    [self setUpTimer];
    
    /** 初始化图片位置*/
//    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
    [self changeImageLeft:0 center:1 right:2];
}

- (void)createScrollView
{
    self.backgroundColor = [UIColor clearColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /** 复用，创建三个*/
    scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    
    /** 设置滚动延时时间*/
    _AutoScrollDelay = 0;
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 1;
    
    _nowIndex = 1;
    
    _scrollView = scrollView;
}

-(void)setImageArray:(NSMutableArray *)imageArray
{
    //如果是网络
    if (_isNetworkImage)
    {
        _imageArray = imageArray;
        
    }else {
        //本地
        _imageArray = imageArray ;
    }
}

- (void)initImageView {
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth, 0,ScrollWidth, ScrollHeight)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth * 2, 0,ScrollWidth, ScrollHeight)];
    if (_sleepDayDraw) {
         MTKSleepView *leftScattView = [self addSleepOneDateWithData:[_imageArray[0] objectAtIndex:0]];
        MTKSleepView *centerScattView = [self addSleepOneDateWithData:[_imageArray[1] objectAtIndex:0]];
        MTKSleepView *rightScattView = [self addSleepOneDateWithData:[_imageArray[2] objectAtIndex:0]];
        
        [leftImageView addSubview:leftScattView];
        [centerImageView addSubview:centerScattView];
        [rightImageView addSubview:rightScattView];
    }
    else{
    ScattView *leftScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[0]] /*[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)]*/;
    ScattView *centerScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[1]];
    ScattView *rightScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[2]];
    
    [leftImageView addSubview:leftScattView];
    [centerImageView addSubview:centerScattView];
    [rightImageView addSubview:rightScattView];
    }
    leftImageView.userInteractionEnabled = YES;
    centerImageView.userInteractionEnabled = YES;
    rightImageView.userInteractionEnabled = YES;
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}

- (ScattView *)addScattViewWithMode:(CPTGraphMode)mode frame:(CGRect)frame dateArr:(NSMutableArray *)drawArr{

    ScattView *scatView = [[ScattView alloc] init];
    scatView.frame = frame;//10, 134, 300, 140
    scatView.delegate = self;
    scatView.HRdataArr = [NSMutableArray array];
    scatView.YgiveLsat = _yValueHiden;//隐藏Y轴数据最后一位
    scatView.DrawMode = mode;
    scatView.lineColors =_lineColors;
    scatView.poinColors = [CPTColor whiteColor];
    scatView.identifiers = _identifiers;  //随便定义
    scatView.showLegend = NO;
    scatView.xCoordinateDecimal = _xCoordinateDecimal;
    scatView.hideYAxisLabels = YES;
    scatView.barOffset = _barOffset;
    scatView.showBarGoap = _showBarGoap;
    scatView.barIntermeNumber = _barIntermeNumber;
    scatView.allowsUserInteraction = mode == 0 ? YES : NO;
    scatView.plotAreaFramePaddingLeft = 0;
    scatView.xRangeLength  = _xRangeLength;
    scatView.selectColor = self.selectColor;
    scatView.yAxisTexts = @[@""];
    scatView.xMajorIntervalLength = @"1";
    [self drawScattViewWithSpArr:drawArr withScattview:scatView updateGraph:NO];
    return scatView;
}

- (void)drawScattViewWithSpArr:(NSMutableArray *)spArr withScattview:(ScattView *)view updateGraph:(BOOL)update{
    view.xAxisTexts = [spArr firstObject];
    NSArray *yValue;
    NSArray *yBaesValues;
    if (_categorymode == 0) {
       yValue = @[spArr[2]];
       yBaesValues = @[spArr[1]];
       view.selectIdx = [spArr[2] count] < 10 ? [spArr[4] intValue] : 0;
    }
    else if (_categorymode == 1){
        yValue = @[spArr[2]];
        yBaesValues = @[spArr[1]];
        view.selectIdx = [spArr[2] count] < 10 ? [spArr[4] intValue] : 0;
    }
    else{
        if (_mode == CPTGraphScatterPlot) {
            yValue = @[spArr[2],spArr[1]];
            yBaesValues = @[];
        }
        else{
            yValue = @[spArr[2],spArr[3]];
            yBaesValues = @[spArr[1],spArr[4]];
        }
       view.selectIdx = [spArr[2] count] < 10 ? [spArr[7] intValue] : 0;
    }
    view.yValues = yValue;
    view.yBaesValues = yBaesValues;
    view.barLineWidth = [spArr[2] count] >10 ?7.0f:20;
    
    view.selectColor = [spArr[2] count] >10 ?NO:YES;
    view.ylabelLocation = [[spArr[2] valueForKeyPath:@"@max.intValue"] intValue];//可以yValue最大值为基准
//       if (!update) {
//        //        view.yValues = @[[self dayYvalue:[spArr objectAtIndex:2]]];
        [view initGraph];
//    }
//    else{
//        //        NSLog(@"vvwefwe==%@",view.yValues);
//        //        view.yValues = @[[self dayYvalue:spArr[2]]];
//        //        [view chanePlotSpace];
////        [view drawXaxis];
////        view.yValues = @[spArr[2]];
////        [view reloadData];
//    }
}

- (MTKSleepView *)addSleepOneDateWithData:(NSMutableArray *)data{
    MTKSleepView *sleepView = [[MTKSleepView alloc] initWithFrame:CGRectMake(0, 0,MainScreen.size.width ,ScrollHeight - 10)];
    sleepView.xTexts = @[@"22:00",@"2:00",@"6:00",@"10:00"];
    sleepView.backgroundColor = [UIColor clearColor];
    sleepView.xValues = [data copy];
    return sleepView;
}


-(void)createPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,ScrollHeight - pageSize,ScrollWidth, 8)];
    
    //设置页面指示器的颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置当前页面指示器的颜色
    pageControl.currentPageIndicatorTintColor = pageColor;
    pageControl.numberOfPages = _MaxImageCount;
    pageControl.currentPage = 0;
    
//    [self addSubview:pageControl];
    
    _PageControl = pageControl;
}

#pragma mark - 定时器

- (void)setUpTimer
{
    if (_AutoScrollDelay < 0.5) return;//太快了
    
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}

#pragma mark - 给复用的imageView赋值

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNetworkImage)
    {
        
//        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
//        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
//        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
        
    }else
    {
        NSLog(@"changeImageLeft=");
        for (ScattView *view in _leftImageView.subviews) {
            [view removeFromSuperview];
        }
        for (ScattView *view in _centerImageView.subviews) {
            [view removeFromSuperview];
        }
        for (ScattView *view in _rightImageView.subviews) {
            [view removeFromSuperview];
        }
        if (_sleepDayDraw) {
            MTKSleepView *leftScattView = [self addSleepOneDateWithData:[_imageArray[0] objectAtIndex:0]];
            MTKSleepView *centerScattView = [self addSleepOneDateWithData:[_imageArray[1] objectAtIndex:0]];
            MTKSleepView *rightScattView = [self addSleepOneDateWithData:[_imageArray[2] objectAtIndex:0]];
            
            [_leftImageView addSubview:leftScattView];
            [_centerImageView addSubview:centerScattView];
            [_rightImageView addSubview:rightScattView];
        }
        else{
        ScattView *leftScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[0]];
        
        [_leftImageView addSubview:leftScattView];
        ScattView *centerScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[1]];
        [_centerImageView addSubview:centerScattView];
        
        ScattView *rightScattView = [self addScattViewWithMode:self.mode frame:CGRectMake(0, 0,ScrollWidth, ScrollHeight) dateArr:_imageArray[2]];
        [_rightImageView addSubview:rightScattView];
        }
    }
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging===");
    [self setUpTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     NSLog(@"scrollViewDidEndDecelerating**********************===");
    self.updateUI = YES;
    if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYScrollViewDidEndDecelerating:)]) {
        [self.localDelagate WYScrollViewDidEndDecelerating:self];
    }
    self.updateUI = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation&&&&&&&&&&&&&&&&&&&===");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     NSLog(@"scrollViewWillBeginDragging===");
    [self removeTimer];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //可使禁止拖拽后滑动不至于界面显示错乱（停止时scrollView.contentOffset.x<_wScrollView）
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    if (scrollView.contentOffset.x > ScrollWidth && _banRightSlide) {//为初始显示位置
        scrollView.contentOffset = CGPointMake(ScrollWidth, 0);
        return;
    }

    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX > MainScreen.size.width && offsetX < MainScreen.size.width + 40 && _orientationIndex == 1) {
        _orientationIndex = -1;
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(scrollViewWillToBorderAtDirection:)]) {
            [self.localDelagate scrollViewWillToBorderAtDirection:-1];
        }
    }
    else if(offsetX < MainScreen.size.width && offsetX > MainScreen.size.width - 40 && _orientationIndex == -1){
        _orientationIndex = 1;
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(scrollViewWillToBorderAtDirection:)]) {
            [self.localDelagate scrollViewWillToBorderAtDirection:1];
        }
    }
    if (offsetX > MainScreen.size.width * 2 - 90) {
        _orientationIndex = 1;
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(scrollViewWillToBorderAtDirection:)]) {
            [self.localDelagate scrollViewWillToBorderAtDirection:1];
        }
    }
    else if (offsetX < 100){
        _orientationIndex = -1;
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(scrollViewWillToBorderAtDirection:)]) {
            [self.localDelagate scrollViewWillToBorderAtDirection:-1];
        }
    }
    if (offsetX == MainScreen.size.width) {
        _orientationIndex = 0;
    }
   if (offsetX >= ScrollWidth * 2)
      {
          
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYScrollViewDidEndDecelerating:)]) {
            [self.localDelagate WYScrollViewDidEndDecelerating:self];
        }
        _currentIndex++;
        _nowIndex ++;
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount)
        {
            _currentIndex = 0;
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
        }else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        NSLog(@"_currentIndex++==%d",_PageControl.currentPage);
    }
    if (offsetX <= 0)
    {
        if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYScrollViewDidEndDecelerating:)]) {
            [self.localDelagate WYScrollViewDidEndDecelerating:self];
        }
        _currentIndex--;
        _nowIndex --;
        if (_currentIndex == 0) {
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
        }else if (_currentIndex == -1) {
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        NSLog(@"_currentIndex--==%d",_PageControl.currentPage);
    }
}

-(void)dealloc
{
    [self removeTimer];
}

#pragma mark - set方法，设置间隔时间

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay{
    _AutoScrollDelay = AutoScrollDelay;
    [self removeTimer];
    [self setUpTimer];
}

#pragma mark******corePlotViewDelegate
- (void)barTouchDownAtRecordIndex:(NSUInteger)idx{
    if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYbarTouchDownAtRecordIndex:)]) {
        [self.localDelagate WYbarTouchDownAtRecordIndex:idx];
    }
}

- (void)plotTouchDownAtRecordPoit:(CGPoint)poit{
//    NSLog(@"plotTouchDownAtRecordPoit %@",NSStringFromCGPoint(poit));
    if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYplotTouchDown)]) {
        [self.localDelagate WYplotTouchDown];
    }
    if (_mode == CPTGraphScatterPlot) {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)plotTouchUpAtRecordPoit:(CGPoint)poit{
//    NSLog(@"plotTouchUpAtRecordPoit %@",NSStringFromCGPoint(poit));
    if (self.localDelagate && [self.localDelagate respondsToSelector:@selector(WYplotTouchUp)]) {
        [self.localDelagate WYplotTouchUp];
    }
    _scrollView.scrollEnabled = YES;
}

- (void)prepareForDrawingPlotLine:(CGPoint)poit{
        NSLog(@"prepareForDrawingPlotLine %@",NSStringFromCGPoint(poit));
//    if (poit.x == 0) {
//        _scrollView.scrollEnabled = YES;
//    }
//    else if (poit.x <= -670){
//        _scrollView.scrollEnabled = YES;
//    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (_yDraw) {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_coordsLab attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName : [UIColor whiteColor]}];
        CGSize strSize = [_coordsLab sizeWithAttributes:@{NSFontAttributeName : FontGothamLight(13)}];
        
        CGFloat strX = 0 ;
        CGFloat strY = _coordsPlace - strSize.height * 0.5;
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
        
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        //设置虚线颜色
        CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
        //设置虚线宽度
        CGContextSetLineWidth(currentContext, 0.5);
        //设置虚线绘制起点
        CGContextMoveToPoint(currentContext, 5 + strSize.width, _coordsPlace);
        //设置虚线绘制终点
        CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, _coordsPlace);
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
        CGFloat arr[] = {3, 1};
        //下面最后一个参数“2”代表排列的个数。
        CGContextSetLineDash(currentContext, 0, arr, 2);
        //画线
        CGContextDrawPath(currentContext, kCGPathStroke);
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
