//
//  WYScrollView.h
//  无忧学堂
//
//  Created by jacke－xu on 16/2/22.
//  Copyright © 2016年 jacke－xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScattView.h"
#import "MTKSleepView.h"
/** 遵循该代理就可以监控到网络滚动视图的index*/
@class WYScrollView;
@protocol WYScrollViewNetDelegate <NSObject>

@optional

/** 点中网络滚动视图后触发*/
-(void)didSelectedNetImageAtIndex:(NSInteger)index;

@end

/** 遵循该代理就可以监控到本地滚动视图的index*/

@protocol WYScrollViewLocalDelegate <NSObject>

@optional

/** 点中本地滚动视图后触发*/
-(void)didSelectedLocalImageAtIndex:(NSInteger)index;

/** 监听滑动到边沿（用于预加载数据） -1 向左  1向右*/
- (void)scrollViewWillToBorderAtDirection:(int)direction;

/** 滑动结束触发*/
- (void)WYScrollViewDidEndDecelerating:(WYScrollView *)scrollView;

/** 点击柱状图触发*/
- (void)WYbarTouchDownAtRecordIndex:(NSUInteger)idx;

/** 触摸手势开始*/
- (void)WYplotTouchDown;

/** 触摸手势结束*/
- (void)WYplotTouchUp;
@end

@interface WYScrollView : UIView

/** 选中网络图片的索引*/
@property (nonatomic, strong) id <WYScrollViewNetDelegate> netDelagate;

/** 选中本地图片的索引*/
@property (nonatomic, strong) id <WYScrollViewLocalDelegate> localDelagate;

/** 占位图*/
@property (nonatomic, strong) UIImage *placeholderImage;

/** 滚动延时*/
@property (nonatomic, assign) NSTimeInterval AutoScrollDelay;

/*是否允许到尽头向右滑动*/
@property (nonatomic, assign) BOOL banRightSlide;

/*是否允许更新UI*/
@property (nonatomic, assign) BOOL updateUI;

/*绘图方式*/
@property (nonatomic, assign) CPTGraphMode mode;

/*指定绘图类别 0 运动 1 睡眠 2心率*/
@property (nonatomic, assign) int categorymode;

@property (nonatomic, strong) NSArray *identifiers; //每组数据的标识字符串，一般用于阐明改组数据的属性

@property (nonatomic, strong) NSArray *lineColors;  //曲线颜色。长度与yValues相等，包含的元素为CPTColor类

@property (nonatomic, assign) BOOL sleepDayDraw;  //绘制睡眠当天图像

/*绘图区域是否允许点击改变颜色*/
@property (nonatomic, assign) BOOL selectColor;

/*是否隐藏最后一条数据*/
@property (nonatomic, assign) BOOL yValueHiden;

@property (nonatomic, assign) BOOL yDraw; //是否画坐标虚线

@property (nonatomic, assign) BOOL showBarGoap;//是否显示柱状图上下圆点

@property (nonatomic, strong)NSArray *barIntermeNumber; //柱状图宽度

/*X轴能显示的区域*/
@property (nonatomic, assign) CGFloat xRangeLength;

/*X轴起始位置*/
@property (nonatomic, assign) CGFloat xCoordinateDecimal;

/*柱状图偏移*/
@property (nonatomic, assign) CGFloat barOffset;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSString *coordsLab; //坐标名字（虚线）

@property (nonatomic, assign) CGFloat coordsPlace; //坐标位置（虚线）
/**
 *  本地图片
 *
 *  @param frame      位置
 *  @param imageArray 加载本地图片
 *
 *  @return
 */
- (instancetype) initWithFrame:(CGRect)frame WithLocalImages:(NSMutableArray *)imageArray;

/**
 *  加载网络图片
 *
 *  @param frame      位置大小
 *  @param imageArray 名字
 *
 *  @return
 */
- (instancetype) initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray;

 /** 设置数量*/
-(void)setMaxImageCount;

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex;
@end

