//
//  ScattView.m
//  Scatter
//
//  Created by 有限公司 深圳市 on 15/10/30.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "ScattView.h"

@implementation ScattView
@synthesize xAxisTexts, yAxisTexts, yValues,yBaesValues, actualYValues, lineColors, identifiers,graph;
-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
}

- (void)initGraph {
    CGRect screenSize = [UIScreen mainScreen].bounds;
    /*****************************************************************************************
    // create the graph
    CPTGraphHostingView *chartLayout=[[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    chartLayout.backgroundColor=[UIColor clearColor];
    self.chartLayoutView = chartLayout;
    graph=[[CPTXYGraph alloc] initWithFrame:chartLayout.bounds];
    graph.plotAreaFrame.masksToBorder=NO;
    chartLayout.hostedGraph=graph;
    //configure the graph
    //    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    // graph在hostingView中的偏移
    graph.paddingBottom=5.0f;
    graph.paddingLeft=0.0f;
    graph.paddingRight=0.0f;
    graph.paddingTop=5.0f;
    graph.plotAreaFrame.borderLineStyle=nil;
    graph.plotAreaFrame.cornerRadius=0.0f;// hide frame
    // 绘图区4边留白
    graph.plotAreaFrame.paddingTop=5.0;
    graph.plotAreaFrame.paddingRight=0;
    graph.plotAreaFrame.paddingLeft= self.plotAreaFramePaddingLeft;//20.0
    graph.plotAreaFrame.paddingBottom=20.0;

    for (int i = 0; i < yValues.count; i ++) {
        if (self.DrawMode == CPTGraphScatterPlot) {
            CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            plot.plotSymbolMarginForHitDetection = 8.0f;
            lineStyle.miterLimit = 0.0f;
            lineStyle.lineWidth = 1.0f;
            lineStyle.lineColor = [lineColors objectAtIndex:i];
            lineStyle.lineCap = kCGLineCapRound;
            lineStyle.lineJoin = kCGLineJoinRound;
            plot.dataLineStyle = lineStyle;
            plot.identifier = [identifiers objectAtIndex:i];
            plot.dataSource = self;
            plot.delegate = self;
            plot.interpolation = CPTScatterPlotInterpolationLinear;  //曲线。
            [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];  // 将plot添加到默认的空间中
        }
        else if (self.DrawMode == CPTGraphBarPlot){
            
            CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[lineColors objectAtIndex:i] horizontalBars:NO];
            NSDecimalNumber *intermediateNumber = [[NSDecimalNumber alloc] initWithFloat:_barIntermeNumber.count>0?[_barIntermeNumber[i] floatValue]:0.97];
            NSDecimal decimal = [intermediateNumber decimalValue];
            [barPlot setBarWidth:decimal];
            barPlot.baseValue = decimal;
            barPlot.barBasesVary = YES;
            //柱状图偏移
            NSDecimalNumber *barOffsetNumber = [[NSDecimalNumber alloc] initWithFloat:0.005];
            NSDecimal barOffsetdDecimal = [barOffsetNumber decimalValue];
//             barPlot. barOffset = barOffsetdDecimal ;
            barPlot.fill = [CPTFill fillWithColor:[lineColors objectAtIndex:i]];
//            barPlot.barBaseCornerRadius = 5.0;
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.miterLimit = 1.0f;
            lineStyle.lineWidth = _barLineWidth?_barLineWidth:1.0f;
            lineStyle.lineColor = [CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0];
            lineStyle.lineCap = kCGLineJoinBevel;
            lineStyle.lineJoin = kCGLineJoinBevel;
            barPlot.lineStyle = lineStyle;
            barPlot.identifier = [identifiers objectAtIndex:i];
            barPlot.dataSource = self;
            barPlot.delegate = self;
            //            barPlot.interpolation = CPTScatterPlotInterpolationHistogram;  //曲线。
            //            if (i == 0) {
            [graph addPlot:barPlot toPlotSpace:graph.defaultPlotSpace];  // 将plot添加到默认的空间
            //            }
        }
    }
    ********************************************************************************************************/
    [self addGraph];
   
    /*****************************************************************************************
    //set up plot space
    CGFloat xMin=0.0f;
    CGFloat xMax=xAxisTexts.count+1;
    CGFloat yMin=0.0f;
    CGFloat yLengh=0.0f;
    if (self.xCoordinateDecimal) {
        yMin = self.xCoordinateDecimal;
    }
    CGFloat yMax=[self maxDataInArray:yValues]*1.02;
    //    NSLog(@"^^^initGraph t0");
    if (yMax == 0) {
        if (self.yMajorIntervalLength && ![self.yMajorIntervalLength isEqualToString:@""])
            yMax = self.yMajorIntervalLength.floatValue*2;
        else
            yMax = 100;
    }
    if (self.yRangeLength) {
        yLengh = self.yRangeLength;
    }
    //    NSLog(@"^^^initGraph t1");
    CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate = self;
    
    plotSpace.allowsUserInteraction = _allowsUserInteraction;
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax <= 31 ? xMax : 31)];  //显示可见部分（globalXRange设置的是滚动可见部分，前者是后者的一部分）
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(self.yRangeLength? self.yRangeLength :yMax)];
    plotSpace.globalXRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax )];  //globalXRange、globalYRange需要配合allowsUserInteraction属性为YES时使用，用于限制可滑动的最大区域 //可控制显示的X坐标起始位置
    plotSpace.globalYRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    ********************************************************************************************************/
    
    [self chanePlotSpace];
    
    /*****************************************************************************************
    // set axis
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    //    NSLog(@"^^^initGraph t2");
    if (!self.xMajorIntervalLength || [self.xMajorIntervalLength isEqualToString:@""]) {
        self.xMajorIntervalLength = @"6";
    }
    if (!self.yMajorIntervalLength || [self.yMajorIntervalLength isEqualToString:@""]) {
        self.yMajorIntervalLength = @"10";
    }
    //    NSLog(@"^^^initGraph t3");
    // xAxis
    CPTXYAxis   *xAxis=axisSet.xAxis;
    CPTMutableLineStyle *xLineStyle=[[CPTMutableLineStyle alloc] init];
    xLineStyle.lineColor= self.hiddenAxis ?[CPTColor clearColor] : [CPTColor whiteColor];
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    //    textStyle.fontName = @"EurostileExtended-Roman-DTC";
    textStyle.fontSize = screenSize.size.width > 320 ? 10 :7;
    textStyle.color = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor whiteColor];
    xAxis.axisLineStyle=xLineStyle;
    xAxis.labelTextStyle = textStyle;
    xAxis.labelingPolicy=CPTAxisLabelingPolicyNone;
    xAxis.axisConstraints=[CPTConstraints constraintWithLowerOffset:0.0];// 加上这两句才能显示label
    //    NSLog(@"^^^initGraph t3-------t1");
    xAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    xAxis.majorTickLength=2;  // 刻度线的长度
    xAxis.majorIntervalLength=CPTDecimalFromString(self.xMajorIntervalLength); // 间隔单位,和xMin~xMax对应
    // 小刻度线minor...
    xAxis.minorTickLineStyle=nil;  //新版coreplot不同于旧版，默认不为nil
    //    xAxis.minorTickLength = 2;
    xAxis.minorTicksPerInterval = 2;  //每2个大刻度之间包含的小刻度
    xAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(self.xCoordinateDecimal?self.xCoordinateDecimal:0);
    //x轴网格线（注意：若x轴的labelingPolicy属性设置为CPTAxisLabelingPolicyNone，则网格线设置无效，除非对majorTickLocations进行自定义设置）
    
    CPTMutableLineStyle *xGridLineStyle = [CPTMutableLineStyle lineStyle];
    xGridLineStyle.lineColor = [CPTColor clearColor] ;//虚线颜色
    xGridLineStyle.lineWidth = 0.5f;
    xAxis.majorGridLineStyle = xGridLineStyle; // 轴线是否显示或显示风格
    xAxis.minorGridLineStyle = xGridLineStyle;
    //title
    xAxis.title = self.xAxisTitle ? self.xAxisTitle : @"";
    //    xAxis.titleLocation = [[NSDecimalNumber numberWithInt:10] decimalValue];
    xAxis.titleOffset = 15;
    xAxis.titleTextStyle = textStyle;
    //    NSLog(@"^^^initGraph t3_0");
    
    //设置X轴自定义label
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:7];
    NSMutableArray *locationLabels = [[NSMutableArray alloc] init];
    //    SmaHRHisInfo *HRInfo = [SMAAccountTool HRHisInfo];
    //    int cycle =  HRInfo.tagname.intValue;
    //    if (!HRInfo) {
    //        cycle = 30;
    //    }
    _cyTime = !_cyTime?1:_cyTime;
    int labelLocation=1;
    for(NSString *label in xAxisTexts){
        CPTTextStyle *ts = xAxis.labelTextStyle;
        CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:ts];
        newLabel.tickLocation=[[NSNumber numberWithInt:labelLocation] decimalValue];
        [locationLabels addObject:[NSNumber numberWithInt:labelLocation]];
        newLabel.offset=xAxis.labelOffset+xAxis.majorTickLength;
        //        newLabel.rotation=M_PI/6;
        if (xAxisTexts.count > 12) {
            if (labelLocation%_cyTime == 0) {
                [labelArray addObject:newLabel];
            } else {
                [labelArray addObject:[[CPTAxisLabel alloc] initWithText:@"" textStyle:xAxis.labelTextStyle]];
            }
        } else {
            [labelArray addObject:newLabel];
        }
        labelLocation++;
    }
    xAxis.axisLabels=[NSSet setWithArray:labelArray];
    xAxis.majorTickLocations = [NSSet setWithArray:locationLabels];  //自定义标签的网格线需要设置majorTickLocations
    xAxis.labelOffset = -1;
    //    NSLog(@"^^^initGraph t3_1");
    ********************************************************************************************************/
    [self drawXaxis];
    
    /*****************************************************************************************
    // yAxis
    CPTMutableTextStyle *yTextStyle = [[CPTMutableTextStyle alloc] init];
    //    yTextStyle.fontName = @"EurostileExtended-Roman-DTC";
    yTextStyle.color = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor whiteColor];
    yTextStyle.fontSize = screenSize.size.width > 320 ? 8 :5;
    yTextStyle.fontName = @"Gotham-Medium";
    CPTMutableLineStyle *yGridLineStyle = [CPTMutableLineStyle lineStyle];
    yGridLineStyle.dashPattern = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:3.0f],
                                  [NSNumber numberWithFloat:3.0f], nil];//设置虚线
    yGridLineStyle.lineColor = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor clearColor];
    yGridLineStyle.lineWidth = 0.5f;
    CPTXYAxis   *yAxis=axisSet.yAxis;
    CPTMutableLineStyle *yLineStyle=[[CPTMutableLineStyle alloc] init];
    yLineStyle.lineColor= self.hiddenAxis ?[CPTColor clearColor] : [CPTColor greenColor];
    yAxis.axisLineStyle=yLineStyle;
    yAxis.labelTextStyle = yTextStyle;
    yAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    yAxis.majorGridLineStyle = yGridLineStyle;
    yAxis.majorTickLength=5;  // 刻度线的长度
    yAxis.minorTicksPerInterval = 4;
//    yAxis.borderColor
    //    NSLog(@"^^^initGraph t4");
    yAxis.majorIntervalLength=CPTDecimalFromString(self.yMajorIntervalLength); // 间隔单位，和yMin～yMax对应
    
    //title
    yAxis.title = self.yAxisTitle ? self.yAxisTitle : @"";
    yAxis.titleOffset = 35;
    yAxis.titleTextStyle = textStyle;
    if (self.hideYAxisLabels) {
        yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
        yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.5];
        yAxis.titleOffset = 35;
    }
    // 小刻度线minor...
    yAxis.minorTickLineStyle=nil;  //  不显示小刻度线
    yAxis.orthogonalCoordinateDecimal=CPTDecimalFromCGFloat(0);
    
    
    //设置Y轴自定义Label
    if (yAxisTexts && yAxisTexts.count > 0) {
        NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:7];
        NSMutableArray *locationLabels = [[NSMutableArray alloc] init];
        float labelLocation=self.ylabelLocation?self.ylabelLocation:10;
        for(NSString *label in yAxisTexts){
            CPTTextStyle *ts = yAxis.labelTextStyle;
            CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:ts];
            newLabel.tickLocation=[[NSNumber numberWithFloat:labelLocation] decimalValue];
            [locationLabels addObject:[NSNumber numberWithInt:labelLocation]];
            newLabel.offset=yAxis.labelOffset+yAxis.majorTickLength;
            [labelArray addObject:newLabel];
            labelLocation += self.ylabelLocation?self.ylabelLocation:10;
        }
        yAxis.axisLabels=[NSSet setWithArray:labelArray];
        yAxis.majorTickLocations = [NSSet setWithArray:locationLabels];  //自定义标签的网格线需要设置majorTickLocations
    }
    ********************************************************************************************************/
    
    [self drawYaxis];
    
    /*****************************************************************************************
    //图例
    if (self.showLegend) {
        CPTLegend *legend = [CPTLegend legendWithGraph:graph];
        legend.numberOfRows = 1;
        legend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
        CPTMutableLineStyle *lineStyleLegend = [CPTMutableLineStyle lineStyle];
        lineStyleLegend.lineColor = [CPTColor whiteColor];
        legend.borderLineStyle = lineStyleLegend;
        legend.cornerRadius = 10.0f;
        CPTMutableTextStyle *textStyleLegend = [[CPTMutableTextStyle alloc] init];
        //        textStyleLegend.fontName = @"EurostileExtended-Roman-DTC";
        textStyleLegend.fontSize =screenSize.size.width > 320 ? 10 : 7;
        textStyleLegend.color = [CPTColor whiteColor];
        legend.textStyle = textStyleLegend;
        graph.legend = legend;
        graph.legendAnchor = CPTRectAnchorBottomLeft;
        graph.legendDisplacement = CGPointMake(0,screenSize.size.width > 320 ? 230 : 155);//-25
    }
    
    // 添加折线点的提示 就是蓝色的小点点
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithColor:[[CPTColor redColor] colorWithAlphaComponent:1]];
    plotSymbol.lineStyle          = symbolLineStyle;
    plotSymbol.size               = CGSizeMake(screenSize.size.width > 320 ? 3.0 : 3.0, screenSize.size.width > 320 ? 3.0 : 3.0);
    if (self.DrawMode == CPTGraphScatterPlot) {
        for (int i = 0; i < identifiers.count; i ++ ) {
             ((CPTScatterPlot *)[graph plotAtIndex:i]).plotSymbol = plotSymbol;
        }
    }
    
    [self addSubview:chartLayout];
    ********************************************************************************************************/
    
    //    if (self.canTouch && yValues.count == 1) {  //要求y只有一个数据组
    ///////////////////触屏
    //添加触摸功能
//    [self addTouchPlot:self];
    //********************************************************************************************
    //滑动的Label
//    self.swipeLabel = [[BaseTouchesView alloc] init];
//    CGFloat HRwhith = [self.swipeLabel clearUpWhithHR:@"00" HRUnit:@"bpm" HRTime:@"00:00"];
//    self.swipeLabel.frame = CGRectMake(0, 0, HRwhith, 26);
//    self.swipeLabel.backgroundColor = [UIColor clearColor];
//    [self.swipeLabel createUI];
//    self.swipeLabel.hidden = YES;
    //    [self addSubview:self.swipeLabel];
    ///////////////////触屏
    //    }
    //    NSLog(@"^^^initGraph done!");
}

- (void)reloadData{
    _reloadFinish = NO;
    if (self.DrawMode == CPTGraphScatterPlot) {
        for (int i = 0; i < identifiers.count; i ++ ) {
         CPTScatterPlot *plot = ((CPTScatterPlot *)[graph plotAtIndex:i]);
            [plot reloadData];
        }
    }
    else{
        for (int i = 0; i < identifiers.count; i ++ ) {
            CPTBarPlot *plot = ((CPTBarPlot *)[graph plotAtIndex:i]);
            [plot reloadData];
        }
    }

//    [graph reloadData];
}

- (void)chanePlotSpace{
    //set up plot space
    CGFloat xMin=0.0f;
    CGFloat xMax=xAxisTexts.count+1;
    CGFloat yMin=0.0f;
    CGFloat yLengh=0.0f;
    CGFloat xLengh=0.0f;
    if (self.yCoordinateDecimal) {
        yMin = self.yCoordinateDecimal;
    }
    if (self.xCoordinateDecimal) {
        xMin = self.xCoordinateDecimal;
    }
    CGFloat yMax=[self maxDataInArray:yValues]*1.05;
    //    NSLog(@"^^^initGraph t0");
    if (yMax == 0) {
        if (self.yMajorIntervalLength && ![self.yMajorIntervalLength isEqualToString:@""])
            yMax = self.yMajorIntervalLength.floatValue*2;
        else
            yMax = 100;
    }
    if (self.yRangeLength) {
        yLengh = self.yRangeLength;
    }
    if (self.xRangeLength) {
        xLengh = self.xRangeLength;
    }
    //    NSLog(@"^^^initGraph t1");
    CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate = self;
    
    plotSpace.allowsUserInteraction = _allowsUserInteraction;
//    CPTPlotRange *xRange = [[CPTPlotRange alloc] init];
//    xRange.length = CPTDecimalFromFloat(xMax <= 5 ? xMax : 5);
//    NSLog(@"wfw===%f  %f  %@  %@",(xMax <= 4 ? xMax : 4), _yRangeLength? _yRangeLength :yMax,plotSpace,plotSpace.yRange.length);
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(self.xRangeLength? self.xRangeLength :xMax)];  //显示可见部分（globalXRange设置的是滚动可见部分，前者是后者的一部分）
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(self.yRangeLength? self.yRangeLength :yMax)];
    plotSpace.globalXRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];  //globalXRange、globalYRange需要配合allowsUserInteraction属性为YES时使用，用于限制可滑动的最大区域 //可控制显示的X坐标起始位置
    plotSpace.globalYRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(self.yRangeLength? self.yRangeLength :yMax)];
}

- (void)addGraph{
    _reloadFinish = NO;
    CGRect screenSize = [UIScreen mainScreen].bounds;
    // create the graph
    CPTGraphHostingView *chartLayout=[[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    chartLayout.backgroundColor=[UIColor clearColor];
    self.chartLayoutView = chartLayout;
    graph=[[CPTXYGraph alloc] initWithFrame:chartLayout.bounds];
    graph.plotAreaFrame.masksToBorder=NO;
    chartLayout.hostedGraph=graph;
    //configure the graph
    //    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    // graph在hostingView中的偏移
    graph.paddingBottom=5.0f;
    graph.paddingLeft=0.0f;
    graph.paddingRight=0.0f;
    graph.paddingTop=5.0f;
    graph.plotAreaFrame.borderLineStyle=nil;
    graph.plotAreaFrame.cornerRadius=0.0f;// hide frame
    // 绘图区4边留白
    graph.plotAreaFrame.paddingTop=5.0;
    graph.plotAreaFrame.paddingRight=0;
    graph.plotAreaFrame.paddingLeft= self.plotAreaFramePaddingLeft;//20.0
    graph.plotAreaFrame.paddingBottom=20.0;

    for (int i = 0; i < yValues.count; i ++) {
        if (self.DrawMode == CPTGraphScatterPlot) {
            CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            plot.plotSymbolMarginForHitDetection = 8.0f;
            lineStyle.miterLimit = 0.0f;
            lineStyle.lineWidth = 1.0f;
            lineStyle.lineColor = [lineColors objectAtIndex:i];
            lineStyle.lineCap = kCGLineCapRound;
            lineStyle.lineJoin = kCGLineJoinRound;
            plot.dataLineStyle = lineStyle;
            plot.identifier = [identifiers objectAtIndex:i];
            plot.dataSource = self;
            plot.delegate = self;
            plot.interpolation = CPTScatterPlotInterpolationLinear;  //曲线。
            [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];  // 将plot添加到默认的空间中
        }
        else if (self.DrawMode == CPTGraphBarPlot){
            
            CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[lineColors objectAtIndex:i] horizontalBars:NO];
            NSDecimalNumber *intermediateNumber = [[NSDecimalNumber alloc] initWithFloat:_barIntermeNumber.count>0?[_barIntermeNumber[i] floatValue]:0.97];
            NSDecimal decimal = [intermediateNumber decimalValue];
            [barPlot setBarWidth:decimal];
            barPlot.baseValue = decimal;
            barPlot.barBasesVary = YES;
            //柱状图偏移
            NSDecimalNumber *barOffsetNumber = [[NSDecimalNumber alloc] initWithFloat:_barOffset];
            NSDecimal barOffsetdDecimal = [barOffsetNumber decimalValue];
            barPlot. barOffset = barOffsetdDecimal ;
            barPlot.fill = [CPTFill fillWithColor:[lineColors objectAtIndex:i]];
            //            barPlot.barBaseCornerRadius = 5.0;
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.miterLimit = 1.0f;
            lineStyle.lineWidth = _barLineWidth?_barLineWidth:1.0f;
            lineStyle.lineColor = [CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0];
            lineStyle.lineCap = kCGLineJoinBevel;
            lineStyle.lineJoin = kCGLineJoinBevel;
            barPlot.lineStyle = lineStyle;
            barPlot.identifier = [identifiers objectAtIndex:i];
            barPlot.dataSource = self;
            barPlot.delegate = self;
            //            barPlot.interpolation = CPTScatterPlotInterpolationHistogram;  //曲线。
            //            if (i == 0) {
            [graph addPlot:barPlot toPlotSpace:graph.defaultPlotSpace];  // 将plot添加到默认的空间
            //            }
        }
    }
    
    /*图例*/
    if (self.showLegend) {
        CPTLegend *legend = [CPTLegend legendWithGraph:graph];
        legend.numberOfRows = 1;
        legend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
        CPTMutableLineStyle *lineStyleLegend = [CPTMutableLineStyle lineStyle];
        lineStyleLegend.lineColor = [CPTColor whiteColor];
        legend.borderLineStyle = lineStyleLegend;
        legend.cornerRadius = 10.0f;
        CPTMutableTextStyle *textStyleLegend = [[CPTMutableTextStyle alloc] init];
        //        textStyleLegend.fontName = @"EurostileExtended-Roman-DTC";
        textStyleLegend.fontSize =screenSize.size.width > 320 ? 10 : 7;
        textStyleLegend.color = [CPTColor whiteColor];
        legend.textStyle = textStyleLegend;
        graph.legend = legend;
        graph.legendAnchor = CPTRectAnchorBottomLeft;
        graph.legendDisplacement = CGPointMake(0,screenSize.size.width > 320 ? 230 : 155);//-25
    }

    // 添加折线点的提示 就是蓝色的小点点
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithColor:[[CPTColor redColor] colorWithAlphaComponent:1]];
    plotSymbol.lineStyle          = symbolLineStyle;
    plotSymbol.size               = CGSizeMake(screenSize.size.width > 320 ? 3.0 : 3.0, screenSize.size.width > 320 ? 3.0 : 3.0);
    if (self.DrawMode == CPTGraphScatterPlot) {
        for (int i = 0; i < identifiers.count; i ++ ) {
            ((CPTScatterPlot *)[graph plotAtIndex:i]).plotSymbol = plotSymbol;
        }
    }
    
    [self addSubview:chartLayout];
    
    //    if (self.canTouch && yValues.count == 1) {  //要求y只有一个数据组
    ///////////////////触屏
    //添加触摸功能
    [self addTouchPlot:self];

}

- (void)drawYaxis{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    // yAxis
    CPTMutableTextStyle *yTextStyle = [[CPTMutableTextStyle alloc] init];
    //    yTextStyle.fontName = @"EurostileExtended-Roman-DTC";
    yTextStyle.color = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor clearColor];
    yTextStyle.fontSize = screenSize.size.width > 320 ? 8 :5;
    yTextStyle.fontName = @"Gotham-Medium";
    CPTMutableLineStyle *yGridLineStyle = [CPTMutableLineStyle lineStyle];
    yGridLineStyle.dashPattern = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:3.0f],
                                  [NSNumber numberWithFloat:3.0f], nil];//设置虚线
    yGridLineStyle.lineColor = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor clearColor];
    yGridLineStyle.lineWidth = 0.5f;
    CPTXYAxis   *yAxis=axisSet.yAxis;
    CPTMutableLineStyle *yLineStyle=[[CPTMutableLineStyle alloc] init];
    yLineStyle.lineColor= self.hiddenAxis ?[CPTColor clearColor] : [CPTColor clearColor];
    yAxis.axisLineStyle=yLineStyle;
    yAxis.labelTextStyle = yTextStyle;
    yAxis.majorTickLineStyle=yLineStyle; //X轴大刻度线，线型设置
    yAxis.majorGridLineStyle = yGridLineStyle;
    yAxis.majorTickLength=5;  // 刻度线的长度
    yAxis.minorTicksPerInterval = 4;
    //    yAxis.borderColor
    //    NSLog(@"^^^initGraph t4");
    yAxis.majorIntervalLength=CPTDecimalFromString(self.yMajorIntervalLength); // 间隔单位，和yMin～yMax对应
    
    //title
    yAxis.title = self.yAxisTitle ? self.yAxisTitle : @"";
    yAxis.titleOffset = 35;
    yAxis.titleTextStyle = yTextStyle;
    if (self.hideYAxisLabels) {
        yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
        yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.5];
        yAxis.titleOffset = 35;
    }
    // 小刻度线minor...
    yAxis.minorTickLineStyle=nil;  //  不显示小刻度线
    yAxis.orthogonalCoordinateDecimal=CPTDecimalFromCGFloat(0);
    
    //设置Y轴自定义Label
    if (yAxisTexts && yAxisTexts.count > 0) {
        NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:7];
        NSMutableArray *locationLabels = [[NSMutableArray alloc] init];
        float labelLocation=self.ylabelLocation?self.ylabelLocation:10;
        for(NSString *label in yAxisTexts){
            CPTTextStyle *ts = yAxis.labelTextStyle;
            CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:ts];
            newLabel.tickLocation=[[NSNumber numberWithFloat:labelLocation] decimalValue];
            [locationLabels addObject:[NSNumber numberWithInt:labelLocation]];
            newLabel.offset=yAxis.labelOffset+yAxis.majorTickLength;
            [labelArray addObject:newLabel];
            labelLocation += self.ylabelLocation?self.ylabelLocation:10;
        }
        yAxis.axisLabels=[NSSet setWithArray:labelArray];
        yAxis.majorTickLocations = [NSSet setWithArray:locationLabels];  //自定义标签的网格线需要设置majorTickLocations
    }

}
- (void)drawXaxis{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    //    NSLog(@"^^^initGraph t2");
    if (!self.xMajorIntervalLength || [self.xMajorIntervalLength isEqualToString:@""]) {
        self.xMajorIntervalLength = @"6";
    }
    if (!self.yMajorIntervalLength || [self.yMajorIntervalLength isEqualToString:@""]) {
        self.yMajorIntervalLength = @"10";
    }
    // xAxis
    CPTXYAxis   *xAxis=axisSet.xAxis;
    CPTMutableLineStyle *xLineStyle=[[CPTMutableLineStyle alloc] init];
    xLineStyle.lineColor= self.hiddenAxis ?[CPTColor clearColor] : [CPTColor whiteColor];
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    //    textStyle.fontName = @"EurostileExtended-Roman-DTC";
    textStyle.fontSize = screenSize.size.width > 320 ? 10 :7;
    textStyle.color = self.hiddenAxis ?[CPTColor clearColor] : [CPTColor whiteColor];
    xAxis.axisLineStyle=xLineStyle;
    xAxis.labelTextStyle = textStyle;
    xAxis.labelingPolicy=CPTAxisLabelingPolicyNone;
    xAxis.axisConstraints=[CPTConstraints constraintWithLowerOffset:0.0];// 加上这两句才能显示label
    //    NSLog(@"^^^initGraph t3-------t1");
    xAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    xAxis.majorTickLength=2;  // 刻度线的长度
    xAxis.majorIntervalLength=CPTDecimalFromString(self.xMajorIntervalLength); // 间隔单位,和xMin~xMax对应
    // 小刻度线minor...
    xAxis.minorTickLineStyle=nil;  //新版coreplot不同于旧版，默认不为nil
    //    xAxis.minorTickLength = 2;
    xAxis.minorTicksPerInterval = 2;  //每2个大刻度之间包含的小刻度
    xAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(self.xCoordinateDecimal?self.xCoordinateDecimal:0);
    //x轴网格线（注意：若x轴的labelingPolicy属性设置为CPTAxisLabelingPolicyNone，则网格线设置无效，除非对majorTickLocations进行自定义设置）
    
    CPTMutableLineStyle *xGridLineStyle = [CPTMutableLineStyle lineStyle];
    xGridLineStyle.lineColor = [CPTColor clearColor] ;//虚线颜色
    xGridLineStyle.lineWidth = 0.5f;
    xAxis.majorGridLineStyle = xGridLineStyle; // 轴线是否显示或显示风格
    xAxis.minorGridLineStyle = xGridLineStyle;
    //title
    xAxis.title = self.xAxisTitle ? self.xAxisTitle : @"";
    //    xAxis.titleLocation = [[NSDecimalNumber numberWithInt:10] decimalValue];
    xAxis.titleOffset = 15;
    xAxis.titleTextStyle = textStyle;
    //    NSLog(@"^^^initGraph t3_0");
    
    //设置X轴自定义label
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:7];
    NSMutableArray *locationLabels = [[NSMutableArray alloc] init];
    _cyTime = !_cyTime?1:_cyTime;
    int labelLocation=1;
    for(NSString *label in xAxisTexts){
        CPTTextStyle *ts = xAxis.labelTextStyle;
        CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:ts];
        newLabel.tickLocation=[[NSNumber numberWithInt:labelLocation] decimalValue];
        [locationLabels addObject:[NSNumber numberWithInt:labelLocation]];
        newLabel.offset=xAxis.labelOffset+xAxis.majorTickLength;
        //        newLabel.rotation=M_PI/6;
        if (xAxisTexts.count > 12) {
            if (labelLocation%_cyTime == 0) {
                [labelArray addObject:newLabel];
            } else {
                [labelArray addObject:[[CPTAxisLabel alloc] initWithText:@"" textStyle:xAxis.labelTextStyle]];
            }
        } else {
            [labelArray addObject:newLabel];
        }
        labelLocation++;
    }
    xAxis.axisLabels=[NSSet setWithArray:labelArray];
    xAxis.majorTickLocations = [NSSet setWithArray:locationLabels];  //自定义标签的网格线需要设置majorTickLocations
    xAxis.labelOffset = -1;
}

- (float)maxDataInArray:(NSArray *)array {
    float max = -999999;
    for (int j = 0; j < array.count; j ++) {
        NSArray *ar = [array objectAtIndex:j];
        for (int i = 0; i < ar.count; i ++) {
            float steps = [[ar objectAtIndex:i] floatValue];
            if (steps > max) {
                max = steps;
            }
        }
    }
    
    return max;
}

#pragma mark - CPTBarPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    if([plot.identifier isEqual:@"当前选择"] && self.DrawMode == 0) {
        return 1;
    }
    
    NSArray *array0 = [yValues objectAtIndex:0];
    NSUInteger re = (yValues && yValues.count > 0 && array0 && array0.count > 0) ? array0.count : 0;
    return re;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    if (yValues.count <= 0 && ((NSArray *)[yValues objectAtIndex:0]).count <= 0) {
        return 0;
    }
    
    NSNumber *num=nil;
    if ([plot isKindOfClass:[CPTScatterPlot class]]) {
        NSString *identifier = (NSString *)plot.identifier;
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:
                if([plot.identifier isEqual:@"当前选择"] && self.DrawMode == 1) {
                    num=[NSNumber numberWithInteger:index ];
                    
                }
                else if ([plot.identifier isEqual:@"当前选择1"]  && self.DrawMode == 1){
                    num=[NSNumber numberWithInteger:index ];
                }
                else if ([plot.identifier isEqual:@"当前选择"] && self.DrawMode == 0){
                    num = self.selectedCoordination ? self.selectedCoordination:@0;
                    NSLog(@"num==%@",[NSString stringWithFormat:@"%@",num]);
                }
                else {
                    num=[NSNumber numberWithInteger:index];    //必须变化，这是每个y值对应的x值  //日线的x标签有24个值(实际时间为0~23)，从0开始；其他周期从1开始
                    
                }
                break;
            case CPTScatterPlotFieldY:
                
                if([plot.identifier isEqual:@"当前选择"] && self.DrawMode == 1){
                    for (int i = 0; i < identifiers.count; i ++) {
                        if ([identifier isEqualToString:@"当前选择"]) {
                            if (self.YgiveLsat && index == [[yValues objectAtIndex:i] count]-1) {
                                break;
                            }
                            if ([[[yValues objectAtIndex:0] objectAtIndex:index] floatValue] == 0) {
                                break;
                            }
                            num = [NSDecimalNumber numberWithFloat:[[[yValues objectAtIndex:i] objectAtIndex:index] floatValue]];
                            break;
                        }
                    }
                }
                else if ([plot.identifier isEqual:@"当前选择1"] && self.DrawMode == 1){
                    for (int i = 0; i < identifiers.count; i ++) {
                        if ([identifier isEqualToString:@"当前选择1"]) {
                            if (self.YgiveLsat && index == [[yBaesValues objectAtIndex:i] count]-1) {
                                break;
                            }
                            if ([[[yValues objectAtIndex:0] objectAtIndex:index] floatValue] == 0) {
                                break;
                            }
                            num = [NSDecimalNumber numberWithFloat:[[[yBaesValues objectAtIndex:i] objectAtIndex:index] floatValue]];
                            break;
                        }
                    }
                    
                }
                else if ([plot.identifier isEqual:@"当前选择"]&& self.DrawMode == 0){
                    switch (index) {
                        default:
                        {
                            if (self.selectedCoordination.intValue >= 0)
                                num = [NSNumber numberWithFloat:[[[yValues objectAtIndex:0] objectAtIndex:self.selectedCoordination.intValue] floatValue]];
                            else
                                num = [NSNumber numberWithInt:0];
                            break;
                        }
                    }
                }
                else {
                    for (int i = 0; i < identifiers.count; i ++) {
                        if ([identifier isEqualToString:[identifiers objectAtIndex:i]]) {
//                            if (self.YgiveLsat && index == [[yValues objectAtIndex:i] count]-1) {
//                                break;
//                            }
                            if ([[[yValues objectAtIndex:i] objectAtIndex:index] floatValue] == 0 && [identifier isEqualToString:[identifiers objectAtIndex:0]]) {
                                break;
                            }
                            num = [NSDecimalNumber numberWithFloat:[[[yValues objectAtIndex:i] objectAtIndex:index] floatValue]];
                            break;
                        }
                    }
                }
                break;
            default:
                break;
        }
    }
    else if ([plot isKindOfClass:[CPTBarPlot class]]){
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation://x 轴坐标（柱子位置）：
                num = [NSNumber numberWithInteger:index];;
                break;
            case CPTBarPlotFieldBarTip:
                if ([plot.identifier isEqual:[identifiers objectAtIndex:0]]) {
                    num = [NSDecimalNumber numberWithFloat:[[[yValues objectAtIndex:0] objectAtIndex:index] floatValue]];
                    if (index == 0) {
                        num = 0;
                    }
                    if (self.YgiveLsat && index == [[yValues objectAtIndex:0] count]-1) {
                        num = 0;
                    }
                    if ([[[yValues objectAtIndex:0] objectAtIndex:index] floatValue] == 0) {
                        num = 0;
                    }

                }
                else{
                    num = [NSDecimalNumber numberWithFloat:[[[yValues objectAtIndex:1] objectAtIndex:index] floatValue]];
                    if (index == 0) {
                        num = 0;
                    }
                    if (self.YgiveLsat && index == [[yValues objectAtIndex:1] count]-1) {
                        num = 0;
                    }
                    if ([[[yValues objectAtIndex:1] objectAtIndex:index] floatValue] == 0) {
                        num = 0;
                    }

                }
                break;
            case CPTBarPlotFieldBarBase:
                 if ([plot.identifier isEqual:[identifiers objectAtIndex:0]]) {
                     num = [NSDecimalNumber numberWithFloat:[[[yBaesValues objectAtIndex:0] objectAtIndex:index] floatValue]];
                     if (index == 0) {
                         num = 0;
                     }
                     if (self.YgiveLsat && index == [[yBaesValues objectAtIndex:0] count]-1) {
                         num = 0;
                     }
                     if ([[[yValues objectAtIndex:0] objectAtIndex:index] floatValue] == 0) {
                         num = 0;
                     }

                 }
                 else{
                     num = [NSDecimalNumber numberWithFloat:[[[yBaesValues objectAtIndex:1] objectAtIndex:index] floatValue]];
                     if (index == 0) {
                         num = 0;
                     }
                     if (self.YgiveLsat && index == [[yBaesValues objectAtIndex:1] count]-1) {
                         num = 0;
                     }
                     if ([[[yValues objectAtIndex:1] objectAtIndex:index] floatValue] == 0) {
                         num = 0;
                     }
                 }
            default:
                break;
        }
    }
    return num;
}

//  //在柱子上面显示对应的值
// -(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
//     CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
//     textLineStyle.fontSize=6.5;
//     textLineStyle.textAlignment = CPTTextAlignmentCenter;
//     textLineStyle.color=[CPTColor grayColor];
//
//     NSArray *plotYVals;
//     for (int i = 0; i < identifiers.count; i ++) {
//         if ([(NSString *)plot.identifier isEqualToString:[identifiers objectAtIndex:i]]) {
//             plotYVals = [yValues objectAtIndex:i];
//             break;
//         }
//     }
//
//     if ([[plotYVals objectAtIndex:index] floatValue] > 0) {
// //        CPTTextLayer *label=[[CPTTextLayer alloc] initWithText:[yValues objectAtIndex:index] style:textLineStyle];
//         CPTTextLayer *label=[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@%c(%@)", [plotYVals objectAtIndex:index], '\n', [xAxisTexts objectAtIndex:index]] style:textLineStyle];
//         return label;
//     } else {
//         return nil;
//     }
// }

#pragma  mark 添加触摸折线图
-(void) addTouchPlot:(UIView *)hostingView{
    
    // 手指选择
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [CPTColor clearColor];
    //滑动的折线，触摸屏幕会有橙色的线可以滑动 第一次触摸屏幕出现的线是touchPlot 第二次是secondTouchPlot
    //出现两条线的时候设置highlightTouchPlot会有填充的一块。具体的可以在真机上试试，再结合代码。
    //    if (self.DrawMode == CPTGraphScatterPlot) {
    
    if (self.DrawMode == CPTGraphBarPlot && _showBarGoap) {
        self.secondTouchPlot = [self addScatterPlot:@"当前选择1" lineStyle:lineStyle dataSource:self];
        self.touchPlot = [self addScatterPlot:@"当前选择" lineStyle:lineStyle dataSource:self];  //by weo. 其实触摸屏幕时出现的橙色竖线就是一个ScatterPlot。即整个逻辑就是多个ScatterPlot复合使用以做出触屏显示标签的效果
    }
    //    }
}

#pragma  mark 添加折线图
- (CPTScatterPlot *)addScatterPlot:(NSString *)identifier lineStyle:(CPTMutableLineStyle *)lineStyle dataSource:(id<CPTPlotDataSource>)dataSource
{
    CPTScatterPlot *boundLinePlot = [[CPTScatterPlot alloc]init];
    boundLinePlot.plotSymbolMarginForHitDetection = 10.0f;//设置symbol点的外沿范围，以用来检测手指的触摸
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier = identifier;
    boundLinePlot.dataSource = self;
    // Do a red-blue gradient: 渐变色区域
    CPTColor *blueColor = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1 alpha:0.8];
    CPTColor *redColor = [CPTColor colorWithComponentRed:1 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor endingColor:redColor];
    areaGradient1.angle = -90.0f;//angle 这里表示了渐变的方向，这个角度是按照逆时针方向与x轴正方向的夹角，-90.0 表示沿着y轴向下渐变
    //    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
    //    boundLinePlot.areaFill = areaGradientFill;
    //    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:1.0]decimalValue];// 渐变色的起点位置
    
//    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
//    
//    CPTColor *areaColor = [CPTColor colorWithComponentRed:CPTFloat(1.0) green:CPTFloat(1.0) blue:CPTFloat(1.0) alpha:CPTFloat(0.6)];
//    
//    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]]; areaGradient.angle = -90.0;
//    
//    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient]; dataSourceLinePlot.areaFill = areaGradientFill; dataSourceLinePlot.areaBaseValue = CPTDecimalFromDouble(0.0);
//    
//    boundLinePlot.areaFill = areaGradientFill;
    
    

    boundLinePlot.interpolation = CPTScatterPlotInterpolationLinear;
    // Add plot symbols: 表示数值的符号的形状
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[[CPTColor redColor] colorWithAlphaComponent:1]];
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    symbolLineStyle.lineWidth = 2;
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(self.HRDateMode == 1?7.0f:7.0f,self.HRDateMode == 1?7.0f:7.0f);
    boundLinePlot.plotSymbol = plotSymbol;
    
    boundLinePlot.delegate = self;
    [graph addPlot:boundLinePlot];
    
    return boundLinePlot;
}

#pragma mark - 图标的Touch事件处理

- (int)getXFromPoint:(CGPoint)point
{
    //    NSLog(@"getX: 1 point=(%f,%f)", point.x, point.y);
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
    pointInPlotArea.x -= self.plotAreaFramePaddingLeft;  //plotAreaFrame相对于graph有一定偏移
    //    NSLog(@"getX: 2 pointInPlotArea=(%f,%f)", pointInPlotArea.x, pointInPlotArea.y);
    NSDecimal newPoint[2];  //x、y坐标
    [graph.defaultPlotSpace plotPoint:newPoint numberOfCoordinates:2 forPlotAreaViewPoint:pointInPlotArea];
    //    NSLog(@"getX: 3 newPoint[0]=%f,newPoint[1]=%f", [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] floatValue], [[NSDecimalNumber decimalNumberWithDecimal:newPoint[1]] floatValue]);
    
    NSDecimalRound(&newPoint[0], &newPoint[0], 0, NSRoundPlain);
    //    NSLog(@"getX: 4 newPoint[0]=%f,newPoint[1]=%f", [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] floatValue], [[NSDecimalNumber decimalNumberWithDecimal:newPoint[1]] floatValue]);
    
    int xx = [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] intValue];
    //    NSLog(@"getX: 5 xx=%d", xx);
    if (xx < 0) {
        xx = 0;
    } else if (xx >= [yValues.firstObject count]) {
        xx = (int)[yValues.firstObject count] - 1;
        // NSLog(@"123");
    }
//        NSLog(@"getX: 6 xx=%d", xx);
    
    return xx;
}

/**
 *  一个手指 滑动 首先触发
 */
- (void)updateTouchPlot:(CGPoint)point
{
    if (self.DrawMode == CPTGraphScatterPlot) {
        [self.touchPlot reloadData];
    }
    int xx = [self getXFromPoint:point];
    
    self.selectedCoordination = [NSNumber numberWithInt:xx];
    
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    //    textStyle.fontName = @"EurostileExtended-Roman-DTC";
    textStyle.fontSize = 7;
    textStyle.color = [CPTColor whiteColor];
    
    
    //    NSLog(@"---939--%F  %@",[self.touchPlot plotAreaPointOfVisiblePointAtIndex:0].y,_HRdataArr);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"move" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [self.swipeLabel frame];//self.swipeButton
    if (self.DrawMode == CPTGraphScatterPlot) {
        rect.origin.x=self.DrawMode == CPTGraphScatterPlot ? point.x-self.swipeLabel.frame.size.width/2+4:point.x-self.swipeLabel.frame.size.width/2+4;
        rect.origin.y = self.DrawMode == CPTGraphScatterPlot? (200-point.y-self.swipeLabel.frame.size.height*1.4):200-point.y-self.swipeLabel.frame.size.height*1.3;
        rect.size.width = [self.swipeLabel clearUpWhithHR:[[yValues objectAtIndex:0] objectAtIndex:xx] HRUnit:@"bpm" HRTime:[_HRdataArr objectAtIndex:xx]];
        [self.swipeLabel createUI];
        [self.swipeLabel setFrame:rect];//self.swipeButton
    }
    [UIView commitAnimations];
}

#pragma mark 实现CPTPlotSpaceDelegate  拖动事件监测 判断是几个手指触摸的
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(plotTouchDownAtRecordPoit:)]){
        [self.delegate plotTouchDownAtRecordPoit:point];
    }
    //    int pointInPlotArea = [self getXFromPoint:point];
    //    NSLog(@"POINT --=   %d",event.allTouches.count );
    //    for (CPTPlot *plot in space.graph.allPlots) {
    //        if ([plot isKindOfClass:[CPTScatterPlot class]]) {
    //
    //            //            NSLog(@"%@",plot.identifier);
    //            if ([plot.identifier isEqual:@"当前选择"]) {
    //                  [plot reloadData];
    //                BOOL res =[self plotSpace:space shouldHandlePointingDeviceDraggedEvent:event atPoint:point];
    //                NSLog(@"00CPTScatterPlot=%@",NSStringFromCGPoint([(CPTScatterPlot *)plot plotAreaPointOfVisiblePointAtIndex:0]));
    //                  NSLog(@"CPTScatterPlot1=%d",[(CPTScatterPlot *)plot indexOfVisiblePointClosestToPlotAreaPoint:point]);
    //            }
    //
    //        }
    //    }
    //      if (self.DrawMode == 0) {
    if (event.allTouches.count >= 2) {
        // 2个指头
        [self.swipeLabel setHidden:YES];
    }
    //            else {
    //        // 1个指头
    //        [self.swipeLabel setHidden:NO];
    //
    ////            [self updateTouchPlot:point];
    //        }
    //
    //    }
    
    return YES;
}


-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
//    NSLog(@"fwfwefew==%@",NSStringFromCGPoint(point));
    //    forw (CPTPlot *plot in space.graph.allPlots) {
    //        if ([plot isKindOfClass:[CPTScatterPlot class]]) {
    //            //            NSLog(@"%@",plot.identifier);
    //            [plot reloadData];
//                NSLog(@"CPTScatterPlot=%u",[(CPTScatterPlot *)space indexOfVisiblePointClosestToPlotAreaPoint:point]);
    //
    //        }
    //    }
    //
       int pointInPlotArea = [self getXFromPoint:point];
//        NSLog(@"===%d",pointInPlotArea);
    //     if (self.DrawMode == 0) {
    //    if (event.allTouches.count >= 2) {
    //        // 2个指头
    [self.swipeLabel setHidden:YES];
    //    } else {
    //        // 1个指头
    //
    //            [self updateTouchPlot:point];
    //        }
    //
    //    }
    //     else{
    //         [self.swipeLabel setHidden:YES];
    //     }
    
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(plotTouchUpAtRecordPoit:)]){
        [self.delegate plotTouchUpAtRecordPoit:point];
    }
    
    //      NSLog(@"UpEvent: %d", event.allTouches.count);
    //    for (CPTPlot *plot in space.graph.allPlots) {
    //        if ([plot isKindOfClass:[CPTScatterPlot class]]) {
    //            //            NSLog(@"%@",plot.identifier);
    //                        NSLog(@"%u",[(CPTScatterPlot *)plot indexOfVisiblePointClosestToPlotAreaPoint:point]);
    //        }
    //    }
    //    [self.swipeLabel setHidden:YES];
    self.selectedCoordination = nil;
    //    self.secondSelectedCoordination = nil;
    //    if (self.DrawMode == CPTGraphScatterPlot) {
    [self.touchPlot reloadData];
    //    }
    //        [self.secondTouchPlot reloadData];
    //        [self.highlightTouchPlot reloadData];
    
    //    [self resetGraphTitle];
    return YES;
}

#pragma mark 是否允许缩放
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint
{
    if (!_isZoom) {
        return NO;
    }
    [self.swipeLabel setHidden:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(plotShouldScaleBy:aboutPoint:)]){
        [self.delegate plotShouldScaleBy:interactionScale aboutPoint:interactionPoint];
    }
    for (CPTPlot *plot in space.graph.allPlots) {
        if ([plot isKindOfClass:[CPTScatterPlot class]]) {
            
            if ([plot.identifier isEqual:[identifiers objectAtIndex:0]] ) {
                CPTScatterPlot *scaPlot = (CPTScatterPlot *)plot;
                if (scaPlot.plotSymbol.size.width >= 3.0) {
                    scaPlot.plotSymbol.size = CGSizeMake(scaPlot.plotSymbol.size.width*interactionScale <3.0 ?3.0f:scaPlot.plotSymbol.size.width*interactionScale, scaPlot.plotSymbol.size.height*interactionScale < 3.0 ? 3.0f :scaPlot.plotSymbol.size.height*interactionScale);
                }
            }
            if ([plot.identifier isEqual:@"当前选择"] || [plot.identifier isEqual:@"当前选择1"]) {
                CPTScatterPlot *scaPlot = (CPTScatterPlot *)plot;
                if (self.DrawMode == 1 ) {
                    scaPlot.plotSymbol.size = CGSizeMake(scaPlot.plotSymbol.size.width*interactionScale <(self.HRDateMode == 1?9.0:5)?(self.HRDateMode == 1?9.0f:5.0f):scaPlot.plotSymbol.size.width*interactionScale, scaPlot.plotSymbol.size.height*interactionScale < (self.HRDateMode == 1?9.0f:5.0f) ? (self.HRDateMode == 1?9.0f:5.0f) :scaPlot.plotSymbol.size.height*interactionScale);
                }
            }
        }
        else if ([plot isKindOfClass:[CPTBarPlot class]]){

        }
    }
    return YES;
}



-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx{
    if ([barPlot.identifier isEqual:[self.identifiers objectAtIndex:0]]) {
        if (idx == _selectIdx && idx != 0 && _selectColor) {
            return [CPTFill fillWithColor:[CPTColor whiteColor]];
        }
        return [CPTFill fillWithColor:[lineColors objectAtIndex:0]];
    }
    else{
        if (idx == _selectIdx && idx != 0 && _selectColor) {
            CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] endingColor:[CPTColor colorWithComponentRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1] beginningPosition:0 endingPosition:1];
            gradient.angle = 90.0f;
            return [CPTFill fillWithGradient:gradient];
        }
      return [CPTFill fillWithColor:[lineColors objectAtIndex:1]];
    }
    
}

-(void)barPlot:(CPTBarPlot *)plot barTouchUpAtRecordIndex:(NSUInteger)idx{
    _selectIdx = idx;
    [plot reloadBarFills];
    if(self.delegate && [self.delegate respondsToSelector:@selector(barTouchDownAtRecordIndex:)]){
        [self.delegate barTouchDownAtRecordIndex:idx];
    }
}
//- (void)barPlot:(CPTBarPlot *)plot barTouchDownAtRecordIndex:(NSUInteger)idx withEvent:(CPTNativeEvent *)event{
//}


-(void)scatterPlot:(CPTScatterPlot *)plot prepareForDrawingPlotLine:(CGPathRef)dataLinePath inContext:(CGContextRef)context{
    if(self.delegate && [self.delegate respondsToSelector:@selector(prepareForDrawingPlotLine:)]){
        [self.delegate prepareForDrawingPlotLine:[plot plotAreaPointOfVisiblePointAtIndex:0]];
    }
//            NSLog(@"---prepareForDrawingPlotLine==%@",NSStringFromCGPoint([plot plotAreaPointOfVisiblePointAtIndex:0]));
}

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(CPTNativeEvent *)event{
    
    if (self.DrawMode == 0) {
        [self.swipeLabel setHidden:NO];
        CGPoint point = [plot plotAreaPointOfVisiblePointAtIndex:idx];
        
        //    NSLog(@"CPTScatterPlot=====%@",NSStringFromCGPoint([plot plotAreaPointOfVisiblePointAtIndex:idx]));
        //    [self updateTouchPlot:point];
    }
    
}

#pragma mark - 触摸事件处理  第一触发触摸事件
- (void)theTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    UITouch *touch=[touches anyObject];
    if (self.DrawMode == 0) {
        [self.swipeLabel setHidden:NO];//self.swipeButton
    }
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:self.touchView];
    }
    if (touches.count == 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:1];
        point = [touch locationInView:self.touchView];
    }
    
    [self plotSpace:graph.defaultPlotSpace shouldHandlePointingDeviceDownEvent:event atPoint:point];
}

- (void)theTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:self.touchView];
    }
    if (touches.count == 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:1];
        point = [touch locationInView:self.touchView];
    }
    
    [self plotSpace:graph.defaultPlotSpace shouldHandlePointingDeviceDraggedEvent:event atPoint:point];
}

- (void)theTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:self.touchView];
    }
    if (touches.count == 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:1];
        point = [touch locationInView:self.touchView];
    }
    
    [self.swipeLabel setHidden:YES];//self.swipeButton
    [self plotSpace:graph.defaultPlotSpace shouldHandlePointingDeviceUpEvent:event atPoint:point];
}

- (NSString *)getTimeForTime:(NSString *)time{
    int hour = time.intValue*30/60;
    int min = time.intValue*30%60;
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",hour>9?[NSString stringWithFormat:@"%d",hour]:[NSString stringWithFormat:@"0%d",hour],min==30?@"30":@"00"];
    return timeStr;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
