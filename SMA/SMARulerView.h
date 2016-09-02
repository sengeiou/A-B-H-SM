//
//  SMARulerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol smaRulerViewDelegate<NSObject>
- (void) drawViewFinish:(NSMutableArray *)cmArr;
@end
@interface SMARulerView : UIView

@property (nonatomic, strong) NSMutableArray *cmArray, *lableArray;
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (nonatomic, assign) float transFloat;
@property (nonatomic, assign) int startTick; //大于50
@property (nonatomic, assign) int stopTick;  //小于250
@property (nonatomic, weak) id<smaRulerViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame starTick:(int)start stopTick:(int)stop;
@end
