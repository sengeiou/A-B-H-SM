//
//  SMARulerScrollView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARulerScrollView.h"

@implementation SMARulerScrollView
{
    UIImageView *indicateIma;
    BOOL firstCreate;
}
- (id)initWithFrame:(CGRect)frame starTick:(int)start stopTick:(int)stop{
    self = [super initWithFrame:frame];
    if (self) {
        self.startTick = start;
        self.stopTick = stop;
        [self createUI];
    }
    return self;
}

- (void)setStartTick:(int)startTick{
    _startTick = startTick;//由于SMARulerView最小为50；
}

- (void)setStopTick:(int)stopTick{
    _stopTick = stopTick;
}

- (void)createUI{
    self.delegate = self;
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    _rulerView = [[SMARulerView alloc] initWithFrame:CGRectMake(0, 0, 2000, 80)starTick:_startTick stopTick:_stopTick];
    _rulerView.backgroundColor = [UIColor clearColor];
    _rulerView.delegate = self;
    [self addSubview:_rulerView];
    self.contentSize = CGSizeMake(_rulerView.frame.size.width, self.frame.size.height);
    //红色指示线
    indicateIma = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2), 0, 8, 40)];
    indicateIma.image = [UIImage imageNamed:@"img_Pointer"];
    indicateIma.transform =  CGAffineTransformMakeRotation(M_PI);
    [self addSubview:indicateIma];
}

static float oldPoint;static float EndDragPoin;
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
        if (EndDragPoin + self.frame.size.height/2 > [[_rulerView.cmArray lastObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:(int)_rulerView.cmArray.count - 1];
            rulerPoin = [NSString stringWithFormat:@"%lu",_rulerView.cmArray.count -1 +_startTick];
        }
        else if (EndDragPoin + self.frame.size.height/2 < [[_rulerView.cmArray firstObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:0];
            rulerPoin = [NSString stringWithFormat:@"%d",_startTick];
        }
        else{
            self.contentOffset = [self scrollviewContentOffset:[NSString stringWithFormat:@"%0.f",(EndDragPoin + self.frame.size.height/2 - [[_rulerView.cmArray firstObject] floatValue])/((_rulerView.frame.size.width-40)/(_stopTick - _startTick + 40))].intValue];
            rulerPoin = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%0.f",(EndDragPoin + self.frame.size.height/2 - [[_rulerView.cmArray firstObject] floatValue])/((_rulerView.frame.size.width-40)/(_stopTick - _startTick + 40))].intValue + _startTick];
        }
    } completion:^(BOOL finished) {
        if (self.scrRulerdelegate && [self.scrRulerdelegate respondsToSelector:@selector(scrollDidEndDecelerating:)]) {
            [self.scrRulerdelegate scrollDidEndDecelerating:rulerPoin];
        }
    }];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopDrag:) object:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopDrag:) object:nil];
    NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     NSLog(@"scrollViewDidEndDecelerating");
    __block NSString *rulerPoin;
    [UIView animateWithDuration:0.2 animations:^{
        if (scrollView.contentOffset.x + self.frame.size.height/2 > [[_rulerView.cmArray lastObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:(int)_rulerView.cmArray.count - 1];
            rulerPoin = [NSString stringWithFormat:@"%lu",_rulerView.cmArray.count -1 +_startTick];
        }
        else if (scrollView.contentOffset.x + self.frame.size.height/2 < [[_rulerView.cmArray firstObject] floatValue]) {
            self.contentOffset = [self scrollviewContentOffset:0];
            rulerPoin = [NSString stringWithFormat:@"%d",_startTick];
        }
        else{
            self.contentOffset = [self scrollviewContentOffset:[NSString stringWithFormat:@"%0.f",(scrollView.contentOffset.x + self.frame.size.height/2 - [[_rulerView.cmArray firstObject] floatValue])/((_rulerView.frame.size.width-40)/(_stopTick - _startTick + 40))].intValue];
            rulerPoin = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%0.f",(scrollView.contentOffset.x + self.frame.size.height/2 - [[_rulerView.cmArray firstObject] floatValue])/((_rulerView.frame.size.width-40)/(_stopTick - _startTick + 40))].intValue + _startTick];
        }
    } completion:^(BOOL finished) {
        if (self.scrRulerdelegate && [self.scrRulerdelegate respondsToSelector:@selector(scrollDidEndDecelerating:)]) {
            [self.scrRulerdelegate scrollDidEndDecelerating:rulerPoin];
        }
    }];
    
}

#pragma mark *****smaRulerViewDelegate
- (void)drawViewFinish:(NSMutableArray *)cmArr{
    //根据确定的开始位置得出指示线的位置
    indicateIma.frame = CGRectMake([cmArr[100] floatValue] - 4, 0, indicateIma.frame.size.width, indicateIma.frame.size.height);
    self.contentOffset = [self scrollviewContentOffset:100];

}

- (CGPoint)scrollviewContentOffset:(int)rulerPoin{
    //得出刻度所在位置得出点坐标，进而求出scrollview的contentOffset
    CGPoint offset =  CGPointMake([_rulerView.cmArray[rulerPoin] floatValue] - (self.frame.size.width>self.frame.size.height?self.frame.size.width/2:self.frame.size.height/2), 0);
    return  offset;
}
@end
