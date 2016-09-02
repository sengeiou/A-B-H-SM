//
//  SMARulerScrollView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMARulerView.h"
@protocol smaRulerScrollDelegate<NSObject>
- (void) scrollDidEndDecelerating:(NSString *)ruler;
@end
@interface SMARulerScrollView : UIScrollView<UIScrollViewDelegate,smaRulerViewDelegate>
@property (nonatomic, strong) SMARulerView *rulerView;
@property (nonatomic, assign) int startTick; //大于50
@property (nonatomic, assign) int stopTick;  //小于250
@property (nonatomic, weak) id<smaRulerScrollDelegate> scrRulerdelegate;
- (id)initWithFrame:(CGRect)frame starTick:(int)start stopTick:(int)stop;
@end
