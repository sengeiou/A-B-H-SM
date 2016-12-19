//
//  SMADfuButton.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADfuButton.h"

@implementation SMADfuButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
//        [self createDfuLayer];
    }
    return self;
}

- (void)createDfuLayer{
    CAShapeLayer *defaultLayer = [CAShapeLayer layer];
    defaultLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    defaultLayer.path        = [self ovalPathect:defaultLayer.frame].CGPath;
    [self.layer addSublayer:defaultLayer];
}

- (UIBezierPath*)ovalPathect:(CGRect)rect{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:rect.size.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return ovalPath;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[SmaColor colorWithHexString:@"#FFFFFF" alpha:0.5] set];
    CGContextSetLineWidth(ctx, 5);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 5, 0, M_PI * 2, 1);
    CGContextStrokePath(ctx);
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 10);
    [[SmaColor colorWithHexString:@"#FFFFFF" alpha:1] set];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + 0.1 + self.progress * M_PI * 2 ;
    NSLog(@"wgrghthet==%f  %f",to, _progress);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 5, - M_PI * 0.5 + 0.1, to, 0);
    CGContextStrokePath(ctx);
}


@end
