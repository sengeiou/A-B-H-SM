//
//  ScattView.h
//  Scatter
//
//  Created by 有限公司 深圳市 on 15/10/30.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "BaseTouchesView.h"
typedef enum {
    CPTGraphScatterPlot = 0,       /// 折线图
    CPTGraphBarPlot,               /// 柱状图
    
} CPTGraphMode;

@protocol corePlotViewDelegate <NSObject>
- (void)barTouchDownAtRecordIndex:(NSUInteger)idx;
- (void)plotTouchDownAtRecordPoit:(CGPoint)poit;
- (void)plotTouchUpAtRecordPoit:(CGPoint)poit;
- (void)plotPrepareForDrawingPoit:(CGPoint)poit;
- (void)prepareForDrawingPlotLine:(CGPoint)poit;
- (void)plotShouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint;//缩放
@end

@interface ScattView : UIView<CPTScatterPlotDelegate,CPTPlotDataSource, BaseTouchesViewDelegate,CPTPlotSpaceDelegate,CPTBarPlotDelegate,CPTPlotDelegate>

@property (nonatomic, strong)     CPTGraph *graph;
@property (nonatomic, weak)       id<corePlotViewDelegate> delegate;
@property (nonatomic, assign)     CPTGraphMode DrawMode;  //绘图模式
@property (nonatomic, assign)     int HRDateMode;  //日期选择模式
@property (nonatomic, assign)     int cyTime;      //控制显示坐标
@property (nonatomic, assign)     CGFloat barLineWidth; //柱状图边界宽度
@property (nonatomic, assign)     NSUInteger selectIdx; //所选择的柱状图

@property (nonatomic, assign)     BOOL selectColor;  //选中是否改变颜色
@property (nonatomic, assign)     BOOL reloadFinish;  //选中是否reload完成
@property (nonatomic, assign)     BOOL isZoom;  //选中是否改变颜色
@property BOOL hideYAxisLabels;  //是否需要隐藏y轴刻度文本
@property BOOL showLegend;  //是否显示图例
@property BOOL canTouch;  //是否有触屏事件
@property BOOL YgiveLsat;  //舍去Y轴最后一位数据，（若最后一位用于限制Y轴最大值便不需显示）
@property BOOL hiddenAxis;  //隐藏XY轴承及刻度线（实际将线颜色变成透明）
@property BOOL showBarGoap; //是否显示柱状图上下圆点
@property BOOL allowsUserInteraction;//是否允许交互
@property (nonatomic, strong)NSString *xMajorIntervalLength;  //x轴大刻度的间隔（即两个刻度之间隔了几个数）
@property (nonatomic, strong)NSString *yMajorIntervalLength;
@property float plotAreaFramePaddingLeft;

@property (nonatomic, strong)NSArray *xAxisTexts;  //x轴显示的文本
@property (nonatomic, strong)NSArray *yAxisTexts;  //y轴显示的文本
@property (nonatomic, strong)NSArray *yValues;     //y值数组，长度表示有多少条曲线。注意：里面的item都是NSArray，第二层的item都是NSString
@property (nonatomic, strong)NSArray *yBaesValues; //y轴底部数据（柱状图底部点）
@property (nonatomic, strong)NSArray *actualYValues;  //实际y值数组，与yValues（值有可能是介乎0~1，为了解决画圆滑曲线且数值过大时卡机的情况）对应
@property (nonatomic, strong)NSArray *lineColors;  //曲线颜色。长度与yValues相等，包含的元素为CPTColor类
@property (nonatomic, strong)NSArray *identifiers; //每组数据的标识字符串，一般用于阐明改组数据的属性
@property (nonatomic, strong)NSArray *barIntermeNumber; //柱状图宽度
@property (nonatomic, strong)NSMutableArray *HRdataArr; //每组数据的标识字符串，一般用于阐明改组数据的属性
@property (nonatomic, strong)NSString *xAxisTitle;
@property (nonatomic, strong)NSString *yAxisTitle;
@property (nonatomic, assign)CGFloat xCoordinateDecimal; //x轴起始坐标
@property (nonatomic, assign)CGFloat yCoordinateDecimal; //x轴起始坐标
@property (nonatomic, assign)CGFloat xRangeLength; //定义Y轴显示长度
@property (nonatomic, assign)CGFloat ylabelLocation; //定义Y轴间距离
@property (nonatomic, assign)CGFloat yRangeLength; //定义Y轴显示长度
@property (nonatomic, assign)CGFloat barOffset;
@property (nonatomic, strong)CPTColor *poinColors;
////////////////手指触摸
@property (nonatomic, strong) NSNumber *selectedCoordination;
@property (nonatomic, strong) NSNumber *secondSelectedCoordination;

@property (nonatomic, strong) CPTScatterPlot *touchPlot;
@property (nonatomic, strong) CPTScatterPlot *secondTouchPlot;
@property (nonatomic, strong) CPTScatterPlot *highlightTouchPlot;

@property (nonatomic, weak) UIView * conditionView;
@property (nonatomic, weak) UIView * switchView;
@property (nonatomic, weak) UIView * touchView;
@property (nonatomic, weak) CPTGraphHostingView *chartLayoutView;

@property (nonatomic,weak) UIButton * swipeButton;
@property (nonatomic,strong) BaseTouchesView *swipeLabel;
////////////////手指触摸

- (void)initGraph;
- (float)maxDataInArray:(NSArray *)array;
- (void)reloadData;
- (void)drawXaxis;
- (void)chanePlotSpace;
@end
