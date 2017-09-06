//
//  SDBaseProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBaseProgressView.h"

@implementation SDBaseProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

static int aniIndex;
static BOOL endAnimation0;
static BOOL endAnimation1;
- (void)setProgress:(CGFloat)progress
{
    if (progress >= 1 ) {
        progress = 1;
    }
    //    NSLog(@"fwghh44444hh==%f  %d",progress,_isAnimation);
    //    _endSpProgress = progress;
    //    if (self.isAnimation && progress != 0) {
    //        [_animationTimer invalidate];
    //        _animationTimer = nil;
    //        aniIndex = 0;
    //        NSLog(@"FWGGH==%F",1/(progress * 100));
    //        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animationTimer:) userInfo:[NSNumber numberWithFloat:progress] repeats:YES];
    //    }
    //    else{
    _progress = progress;
    [self setNeedsDisplay];
    //    }
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (_progress >= 1.0) {
    //            [self removeFromSuperview];
    //        } else {
    //            [self setNeedsDisplay];
    //        }
    //    });
    
}

- (void)changeProgress:(CGFloat)progress titleLab:(NSString *)title{
    if (progress >= 1 ) {
        progress = 1;
    }
    NSLog(@"fwghh44444hh==%f  %d  %@",progress,_isAnimation,self);
    _endProgress = progress;
    _endTitleLab = title;
    if (progress - _hisProgress != 0 || _endTitleLab.intValue - _hisTitleLab.intValue != 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        aniIndex = 0;
        NSLog(@"FWGGH==%F",1/(progress * 100));
        
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animationTimer:) userInfo:nil repeats:YES];
    }
    else{
        _titleLab = title;
        _progress = progress;
        [self setNeedsDisplay];
    }
    _titleLab = title;
}

- (void)setBPProgres:(CGFloat)shrinkPor relaxaion:(CGFloat)relaPro shrinkTitleLab:(NSString *)title relaxaionTitleLab:(NSString *)relaxaiontitle{
    if (shrinkPor >= 1 ) {
        shrinkPor = 1;
    }
    NSLog(@"fwghh44444hh==%f  %d  %@",shrinkPor,_isAnimation,self);
    _endProgress = shrinkPor;
    _endTitleLab = title;
    _BPendProgress = relaPro;
    _BPendTitleLab = relaxaiontitle;
    endAnimation0 = NO;
    endAnimation1 = NO;
    if (shrinkPor - _hisProgress != 0 || _endTitleLab.intValue - _hisTitleLab.intValue != 0 || shrinkPor - _BPhisProgress != 0 || _BPendTitleLab.intValue - _BPhisTitleLab.intValue != 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        aniIndex = 0;
        NSLog(@"FWGGH==%F",1/(shrinkPor * 100));
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animationBPTimer:) userInfo:nil repeats:YES];
    }
    else{
        _titleLab = title;
        _progress = shrinkPor;
        _BPtitleLab = relaxaiontitle;
        _BPprogress = relaPro;
        [self setNeedsDisplay];
    }
//    _titleLab = title;
//    _BPtitleLab = relaxaiontitle;
}

- (void)animationBPTimer:(NSTimer *)timer{
    
    aniIndex = aniIndex + 1;
    CGFloat nowProgress = aniIndex * ((_endProgress - _hisProgress)/100) + _hisProgress;
    NSString *titString = [NSString stringWithFormat:@"%.0f",0.01 * aniIndex * ((_endTitleLab.intValue - _hisTitleLab.intValue)) + _hisTitleLab.intValue];
    if (_endProgress - _hisProgress >= 0) {
        if (nowProgress >= _endProgress) {
            nowProgress = _endProgress;
            _hisProgress = nowProgress;
        }
        if (titString.intValue >= _endTitleLab.intValue) {
            titString = _endTitleLab;
            _hisTitleLab = _endTitleLab;
        }
        if (titString.intValue >= _endTitleLab.intValue && nowProgress >= _endProgress) {
//            [_animationTimer invalidate];
//            _animationTimer = nil;
            endAnimation0 = YES;
        }
    }
    else{
        if (nowProgress <= _endProgress) {
            nowProgress = _endProgress;
            _hisProgress = nowProgress;
        }
        if (titString.intValue <= _endTitleLab.intValue) {
            titString = _endTitleLab;
            _hisTitleLab = _endTitleLab;
        }
        if (titString.intValue <= _endTitleLab.intValue && nowProgress <= _endProgress) {
//            [_animationTimer invalidate];
//            _animationTimer = nil;
            endAnimation0 = YES;
        }
    }
    //   NSLog(@"FWGHHHHH===%f    %@",nowProgress,titString);
    _progress = nowProgress;
    _titleLab = titString;
    
    CGFloat BPnowProgress = aniIndex * ((_BPendProgress - _BPhisProgress)/100) + _BPhisProgress;
    NSString *BPtitString = [NSString stringWithFormat:@"%.0f",0.01 * aniIndex * ((_BPendTitleLab.intValue - _BPhisTitleLab.intValue)) + _BPhisTitleLab.intValue];
    if (_BPendProgress - _BPhisProgress >= 0) {
        if (BPnowProgress >= _BPendProgress) {
            nowProgress = _endProgress;
            _BPhisProgress = BPnowProgress;
        }
        if (BPtitString.intValue >= _BPendTitleLab.intValue) {
            BPtitString = _BPendTitleLab;
            _BPhisTitleLab = _BPendTitleLab;
        }
        if (BPtitString.intValue >= _BPendTitleLab.intValue && BPnowProgress >= _BPendProgress) {
//            [_animationTimer invalidate];
//            _animationTimer = nil;
             endAnimation1 = YES;
        }
    }
    else{
        if (BPnowProgress <= _BPendProgress) {
            BPnowProgress = _BPendProgress;
            _BPhisProgress = BPnowProgress;
        }
        if (BPtitString.intValue <= _BPendTitleLab.intValue) {
            BPtitString = _BPendTitleLab;
            _BPhisTitleLab = _BPendTitleLab;
        }
        if (BPtitString.intValue <= _BPendTitleLab.intValue && BPnowProgress <= _BPendProgress) {
//            [_animationTimer invalidate];
//            _animationTimer = nil;
            endAnimation1 = YES;
        }
    }
    //   NSLog(@"FWGHHHHH===%f    %@",nowProgress,titString);
    _BPprogress = BPnowProgress;
    _BPtitleLab = BPtitString;
    [self setNeedsDisplay];
    if (endAnimation1 && endAnimation0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

- (void)animationTimer:(NSTimer *)timer{
    aniIndex = aniIndex + 1;
    CGFloat nowProgress = aniIndex * ((_endProgress - _hisProgress)/100) + _hisProgress;
    NSString *titString = [NSString stringWithFormat:@"%.0f",0.01 * aniIndex * ((_endTitleLab.intValue - _hisTitleLab.intValue)) + _hisTitleLab.intValue];
    if (_endProgress - _hisProgress >= 0) {
        if (nowProgress >= _endProgress) {
            nowProgress = _endProgress;
            _hisProgress = nowProgress;
        }
        if (titString.intValue >= _endTitleLab.intValue) {
            titString = _endTitleLab;
            _hisTitleLab = _endTitleLab;
        }
        if (titString.intValue >= _endTitleLab.intValue && nowProgress >= _endProgress) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    else{
        if (nowProgress <= _endProgress) {
            nowProgress = _endProgress;
            _hisProgress = nowProgress;
        }
        if (titString.intValue <= _endTitleLab.intValue) {
            titString = _endTitleLab;
            _hisTitleLab = _endTitleLab;
        }
        if (titString.intValue <= _endTitleLab.intValue && nowProgress <= _endProgress) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    //   NSLog(@"FWGHHHHH===%f    %@",nowProgress,titString);
    _progress = nowProgress;
    _titleLab = titString;
    [self setNeedsDisplay];
}


- (void)sleepTimeAnimaitonWtihStar:(CGFloat)starTime end:(CGFloat)endTime{
    _endEndTime = endTime - (int)endTime/60 * 60;
    _endStartTime = starTime - (int)starTime/60 * 60;
    
    if (self.endEndTime - self.hisEndTime != 0 || self.endStartTime - self.hisStartTime != 0) {
        if (_hisEndTime == 0) {
            _hisEndTime = 60;
        }
        [_animationTimer invalidate];
        _animationTimer = nil;
        aniIndex = 0;
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animationSlTimer:) userInfo:nil repeats:YES];
    }
    else{
        _startTime = starTime;
        _endTime = endTime;
        [self setNeedsDisplay];
    }
    
}

- (void)animationSlTimer:(NSTimer *)timer{
    
    aniIndex = aniIndex + 1;
    CGFloat starFloat = aniIndex * ((_endStartTime - _hisStartTime))/100 + _hisStartTime;
    CGFloat endFloat;
    endFloat = _hisEndTime + (aniIndex * ((0 + _endEndTime - _hisEndTime))/100);
    if (_endStartTime - _hisStartTime >= 0 && _endEndTime - _hisEndTime <= 0) {
        if (starFloat >= self.endStartTime) {
            starFloat = _endStartTime;
            _hisStartTime = _endStartTime;
        }
        if (endFloat <= self.endEndTime) {
            endFloat = _endEndTime;
            _hisEndTime = _endEndTime;
        }
        if (starFloat >= self.endStartTime&& endFloat <= self.endEndTime) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    else if(_endStartTime - _hisStartTime >= 0 && _endEndTime - _hisEndTime >= 0){
        if (starFloat >= self.endStartTime) {
            starFloat = _endStartTime;
            _hisStartTime = _endStartTime;
        }
        if (endFloat >= self.endEndTime) {
            endFloat = _endEndTime;
            _hisEndTime = _endEndTime;
        }
        
        if (starFloat <= self.endStartTime && endFloat >= self.endEndTime) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    else if (_endStartTime - _hisStartTime <= 0 && _endEndTime - _hisEndTime <= 0){
        if (starFloat <= self.endStartTime) {
            starFloat = _endStartTime;
            _hisStartTime = _endStartTime;
        }
        if (endFloat <= self.endEndTime) {
            endFloat = _endEndTime;
            _hisEndTime = _endEndTime;
        }
        if (starFloat <= self.endStartTime && endFloat <= self.endEndTime) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    else{
        if (starFloat <= self.endStartTime) {
            starFloat = _endStartTime;
            _hisStartTime = _endStartTime;
        }
        if (endFloat >= self.endEndTime) {
            endFloat = _endEndTime;
            _hisEndTime = _endEndTime;
        }
        if (starFloat <= self.endStartTime && endFloat >= self.endEndTime) {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
    }
    _startTime = starFloat;
    _endTime = endFloat;
    NSLog(@"rehehqahqhqh==%f  %d     %f  %d \n %f  %f",starFloat, (int)self.endStartTime%60,endFloat,(int)self.endEndTime%60,((_endStartTime - _hisStartTime))/100,((_endEndTime - _hisEndTime))/100);
    [self setNeedsDisplay];
    
}
- (void)setCenterProgressText:(NSString *)text uintText:(NSString *)uint textFont:(UIFont *)font uintFont:(UIFont *)font1
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    CGSize strSize;
    CGSize strUintSize;
    NSAttributedString *attrStr = nil;
    NSAttributedString *attrUintStr = nil;
    
    //    NSShadow *shadow = [[NSShadow alloc] init];//阴影
    //    shadow.shadowBlurRadius = 1;
    //    shadow.shadowColor = [UIColor blueColor];
    //    shadow.shadowOffset = CGSizeMake(1, 3);
    attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :font}];
    attrUintStr = [[NSAttributedString alloc] initWithString:uint attributes:@{NSFontAttributeName : font1,NSForegroundColorAttributeName:[UIColor grayColor]}];
    strSize = [text sizeWithAttributes:@{NSFontAttributeName :font}];
    strUintSize = [uint sizeWithAttributes:@{NSFontAttributeName :font1}];
    
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    
    CGFloat strX1 = xCenter - strUintSize.width * 0.5;
    CGFloat strY1 = yCenter + strSize.height*0.5;
    [attrStr drawAtPoint:CGPointMake(strX, strY)];
    [attrUintStr drawAtPoint:CGPointMake(strX1, strY1)];
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}

- (void)createUIRect:(CGRect)rect{
    NSLog(@"this is father function....");
}
@end
