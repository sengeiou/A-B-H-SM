//
//  SMADfuView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADfuView.h"

@implementation SMADfuView

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[SmaColor colorWithHexString:@"#FFFFFF" alpha:0.5] set];
    CGContextSetLineWidth(ctx, 5);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 5, 0, M_PI * 2, 1);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 10);
    [[SmaColor colorWithHexString:@"#FFFFFF" alpha:1] set];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + 0.1 + self.progress * M_PI * 2 ;
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 5, - M_PI * 0.5 + 0.1, to, 0);
    CGContextStrokePath(ctx);
}

@end
