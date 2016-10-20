//
//  SMAClockRulerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol smaAlarmRulerViewDelegate<NSObject>
- (void) drawViewFinish:(NSMutableArray *)cmArr;
@end

@interface SMAClockRulerView : UIView
@property (nonatomic, strong) NSMutableArray *cmArray, *lableArray;
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (nonatomic, assign) float transFloat;
@property (nonatomic, assign) int startTick; //大于50
@property (nonatomic, assign) int stopTick;  //小于250
@property (nonatomic) int multiple;
@property (nonatomic) int scaleHiden; //隐藏前后各**格
@property (nonatomic, weak) id<smaAlarmRulerViewDelegate> delegate;
@end
