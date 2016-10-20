//
//  SMAClockRulerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAClockRulerView.h"

@implementation SMAClockRulerView
{
    BOOL firstCreate;
}
#pragma mark - Initialization

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
    _startTick = 0;
    _stopTick = 12;
    _scaleHiden = 20;
    _multiple = 1;
    firstCreate = YES;
}

- (void)layoutSubviews{
    if (firstCreate) {
        _cmArray = [NSMutableArray array];
        _lableArray = [NSMutableArray array];
        for (int i = 0; i < (_stopTick - _startTick); i++) {
            [_lableArray addObject:[NSString stringWithFormat:@"%d",i * _multiple]];
        }
        firstCreate = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat x = 0;
    for (int i = 0; i < _stopTick - _startTick + _scaleHiden*2; i ++) {
        if (i >= _scaleHiden && i< _stopTick - _startTick + _scaleHiden) {
            
            x = (self.frame.size.width/(_stopTick - _startTick + _scaleHiden*2))*i;
            [_cmArray addObject:[NSNumber numberWithFloat:x]];
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, x, 0);
            CGPathAddLineToPoint(path, nil,x,self.frame.size.height/2 - 10);
            [[UIColor whiteColor] setStroke];
            CGContextAddPath(ctx, path);
            CGContextDrawPath(ctx, kCGPathEOFillStroke);
            CGPathRelease(path);
                CGSize size = [_lableArray[i - _scaleHiden] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x - (size.width + 5) * 0.5, self.frame.size.height/2 + 5, size.width+5, size.height)];
                lab.textColor = [UIColor whiteColor];
                lab.font = [self.textStyleDict objectForKey:NSFontAttributeName];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.text = _lableArray[i - _scaleHiden];
                [self addSubview:lab];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawViewFinish:)]) {
        [self.delegate drawViewFinish:_cmArray];
    }
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

@end
