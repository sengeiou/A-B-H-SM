//
//  SDBaseProgressView.h
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SDColorMaker(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define SDProgressViewItemMargin 10

#define SDProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

// 背景颜色
#define SDProgressViewBackgroundColor SDColorMaker(240, 240, 240, 0.9)

@interface SDBaseProgressView : UIView

@property (nonatomic, assign) CGFloat hisProgress;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat endProgress;

@property (nonatomic, assign) CGFloat startTime, endTime;
@property (nonatomic, assign) CGFloat hisStartTime, hisEndTime;
@property (nonatomic, assign) CGFloat endStartTime, endEndTime;

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) NSString *hisTitleLab;

@property (nonatomic, strong) NSString *titleLab;

@property (nonatomic, strong) NSString *endTitleLab;

@property (nonatomic, strong) NSTimer *animationTimer;

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes;

- (void)setCenterProgressText:(NSString *)text uintText:(NSString *)uint textFont:(UIFont *)font uintFont:(UIFont *)font1;

- (void)dismiss;

+ (id)progressView;

- (void)createUIRect:(CGRect)rect;

- (void)changeProgress:(CGFloat)progress titleLab:(NSString *)title;

- (void)sleepTimeAnimaitonWtihStar:(CGFloat)starTime end:(CGFloat)endTime;
@end
