//
//  SMAAlarmRulerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAlarmRulerView.h"

@implementation SMAAlarmRulerView
{
    BOOL shouldUpdateSubviews;
    UIImageView *indicateIma;
    BOOL firstCreate;
    float oldPoint;
    float EndDragPoin;
    int hiddenScale;//该隐藏的刻度数
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
} 

- (void)commonInit {
    self.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:1];
    self.showsHorizontalScrollIndicator = NO;
    _starTick = 0;
    shouldUpdateSubviews = YES;
    _clearance = 50.0;
    _multiple = 1;
}

- (void)layoutSubviews{
    if (shouldUpdateSubviews) {
        self.delegate = self;
        hiddenScale = MainScreen.size.width > 380 ? 5:MainScreen.size.width > 330 ? 4 : 3;
        _clockRuler = [[SMAClockRulerView alloc] initWithFrame:CGRectMake(0, 0, _clearance * (_stopTick - _starTick + hiddenScale * 2) , (self.frame.size.width>self.frame.size.height?self.frame.size.height:self.frame.size.width))];
        _clockRuler.startTick = _starTick;
        _clockRuler.stopTick = _stopTick;
        _clockRuler.scaleHiden = hiddenScale;
        _clockRuler.multiple = _multiple;
        _clockRuler.textStyleDict = _textStyleDict;
        _clockRuler.delegate = self;
        _clockRuler.backgroundColor = [SmaColor colorWithHexString:@"#86BFFA" alpha:1];
        self.contentSize = CGSizeMake(_clockRuler.frame.size.width, self.frame.size.height);
        [self addSubview:_clockRuler];
        //红色指示线
        indicateIma = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) , 0, 2, (self.frame.size.width>self.frame.size.height?self.frame.size.height:self.frame.size.width)/2)];
//        indicateIma.image = [UIImage imageNamed:@"img_Pointer"];
        indicateIma.transform =  CGAffineTransformMakeRotation(M_PI);
        indicateIma.backgroundColor = [UIColor whiteColor];
        [self addSubview:indicateIma];

    }
   shouldUpdateSubviews = NO;
}

//static static
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (firstCreate) {
        //根据移动偏移量改变指示线位置
        indicateIma.frame = CGRectMake(scrollView.contentOffset.x - oldPoint + indicateIma.frame.origin.x , 0, indicateIma.frame.size.width, indicateIma.frame.size.height);
    }
    firstCreate = YES;
    oldPoint = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    EndDragPoin = scrollView.contentOffset.x;
    [self performSelector:@selector(timeoutToStopDrag:) withObject:nil afterDelay:0.1];
}

-(void)timeoutToStopDrag:(UIScrollView *)scrollView
{
    
    __block NSString *rulerPoin;
    [UIView animateWithDuration:0.2 animations:^{
        if (EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) > [[_clockRuler.cmArray lastObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:(int)_clockRuler.cmArray.count - 1];
            rulerPoin = [NSString stringWithFormat:@"%lu",(_clockRuler.cmArray.count -1 +_starTick)];
        }
        else if (EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) < [[_clockRuler.cmArray firstObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:0];
            rulerPoin = [NSString stringWithFormat:@"%d",_starTick];
        }
        else{
            self.contentOffset = [self scrollviewContentOffset:[NSString stringWithFormat:@"%0.f",(EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) - [[_clockRuler.cmArray firstObject] floatValue])/((_clockRuler.frame.size.width)/(_stopTick - _starTick + hiddenScale * 2))].intValue];
            rulerPoin = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%0.f",(EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) - [[_clockRuler.cmArray firstObject] floatValue])/((_clockRuler.frame.size.width)/(_stopTick - _starTick + hiddenScale * 2))].intValue + _starTick];
        }
    } completion:^(BOOL finished) {
        if (self.alarmDelegate && [self.alarmDelegate respondsToSelector:@selector(scrollDidEndDecelerating:scrollView:)]) {
            [self.alarmDelegate scrollDidEndDecelerating:rulerPoin scrollView:self];
        }
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopDrag:) object:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopDrag:) object:nil];
    NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    EndDragPoin = scrollView.contentOffset.x;
    __block NSString *rulerPoin;
    [UIView animateWithDuration:0.2 animations:^{
        if (EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) > [[_clockRuler.cmArray lastObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:(int)_clockRuler.cmArray.count - 1];
            rulerPoin = [NSString stringWithFormat:@"%lu",_clockRuler.cmArray.count -1 +_starTick];
        }
        else if (EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) < [[_clockRuler.cmArray firstObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:0];
            rulerPoin = [NSString stringWithFormat:@"%d",_starTick];
        }
        else{
            NSLog(@"wgrgth===%f",self.frame.size.width);
            self.contentOffset = [self scrollviewContentOffset:[NSString stringWithFormat:@"%0.f",(EndDragPoin + (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2) - [[_clockRuler.cmArray firstObject] floatValue])/((_clockRuler.frame.size.width)/(_stopTick - _starTick + hiddenScale * 2))].intValue];
            rulerPoin = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%0.f",(EndDragPoin + (self.frame.size.width > self.frame.size.height ? self.frame.size.width/2:self.frame.size.height/2) - [[_clockRuler.cmArray firstObject] floatValue])/((_clockRuler.frame.size.width)/(_stopTick - _starTick + hiddenScale * 2))].intValue + _starTick];
        }
    } completion:^(BOOL finished) {
                if (self.alarmDelegate && [self.alarmDelegate respondsToSelector:@selector(scrollDidEndDecelerating:scrollView:)]) {
                    [self.alarmDelegate scrollDidEndDecelerating:rulerPoin scrollView:self];
                }
    }];
}

-(NSDictionary *)textStyleDict
{
    if (!_textStyleDict) {
        UIFont *font = FontGothamLight(30);
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init]; // 段落样式
        style.alignment = NSTextAlignmentCenter;
        
        _textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    return _textStyleDict;
}

#pragma mark *****smaAlarmRulerViewDelegate
- (void)drawViewFinish:(NSMutableArray *)cmArr{
    //根据确定的开始位置得出指示线的位置
    indicateIma.frame = CGRectMake([cmArr[_showTick] floatValue] - 1, 0, indicateIma.frame.size.width, indicateIma.frame.size.height);
    self.contentOffset = [self scrollviewContentOffset:_showTick];
    
}

- (CGPoint)scrollviewContentOffset:(int)rulerPoin{
    //得出刻度所在位置得出点坐标，进而求出scrollview的contentOffset  - _clearance/(_stopTick - _starTick + 5)
    CGPoint offset =  CGPointMake([_clockRuler.cmArray[rulerPoin] floatValue] - (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2), 0);
    return  offset;
}

@end
