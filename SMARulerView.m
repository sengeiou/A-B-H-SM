//
//  SMARulerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARulerView.h"
#import <CoreText/CoreText.h>
@implementation SMARulerView

- (id)initWithFrame:(CGRect)frame starTick:(int)start stopTick:(int)stop{
    self = [super initWithFrame:frame];
    if (self) {
        _startTick = start;
        _stopTick = stop;
        [self initializeMethod];
    }
    return self;
}

- (void)initializeMethod{
    _cmArray = [NSMutableArray array];
    _lableArray = [NSMutableArray array];
    for (int i = 0; i < (_stopTick - _startTick + 40)/10; i++) {
        [_lableArray addObject:[NSString stringWithFormat:@"%d",50+i*10]];
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat x = 0;
    for (int i = 0; i < _stopTick - _startTick + 40; i ++) {
        if (i>=20 && i<=_stopTick - _startTick + 20) {//隐藏前后各20格
            
            x = 20 + ((self.frame.size.width-40)/(_stopTick - _startTick + 40))*i;
            [_cmArray addObject:[NSNumber numberWithFloat:x]];
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, x, 0);
            if (i%5==0) {
                CGPathAddLineToPoint(path, nil,x,40);
            }
            else{
                CGPathAddLineToPoint(path, nil,x,30);
            }
            //        [[UIColor whiteColor] setStroke];
            CGContextAddPath(ctx, path);
            CGContextDrawPath(ctx, kCGPathEOFillStroke);
            CGPathRelease(path);
            //        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
            if (i%10 == 0) {
                CGSize size = [_lableArray[i/10 ] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x - size.width * 0.5, 50, size.width+5, size.height)];
                lab.font = FontGothamLight(16);
                lab.textAlignment = NSTextAlignmentCenter;
                lab.text = _lableArray[i/10];
                lab.transform = CGAffineTransformMakeRotation(M_PI + _transFloat);
                //            lab.backgroundColor = [UIColor greenColor];
                [self addSubview:lab];
                //            [_lableArray[i%10] drawAtPoint:CGPointMake(x - size.width * 0.5, 50) withAttributes:_textStyleDict];
                
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawViewFinish:)]) {
        [self.delegate drawViewFinish:_cmArray];
    }
}


-(NSDictionary *)textStyleDict
{
    if (!_textStyleDict) {
        UIFont *font = FontGothamLight(16);
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init]; // 段落样式
        style.alignment = NSTextAlignmentCenter;
        
        _textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    return _textStyleDict;
}
@end
