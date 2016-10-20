//
//  SMAAlarmRulerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAClockRulerView.h"
@class SMAAlarmRulerView;
@protocol smaAlarmRulerScrollDelegate<NSObject>
- (void) scrollDidEndDecelerating:(NSString *)ruler scrollView:(SMAAlarmRulerView *)scrollview;
@end

@interface SMAAlarmRulerView : UIScrollView<UIScrollViewDelegate,smaAlarmRulerViewDelegate>

@property (nonatomic, strong) SMAClockRulerView *clockRuler;
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (nonatomic) int starTick;
@property (nonatomic) int stopTick;
@property (nonatomic) int showTick;
@property (nonatomic) int multiple;
@property (nonatomic, weak) id<smaAlarmRulerScrollDelegate> alarmDelegate;
@property (nonatomic) float clearance; //两格间隙
@end
