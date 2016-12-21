//
//  SDLoopProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDLoopProgressView.h"

@implementation SDLoopProgressView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [SDColorMaker(31, 144, 234, 1) set];
    
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);

    CGFloat to = - M_PI * 0.5 + 0.1 + self.progress * M_PI * 2 ;
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5 + 0.1, to, 0);
    CGContextStrokePath(ctx);
    
    [SDColorMaker(68, 68, 68, 1) set];
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx1, 2);
    CGContextSetLineCap(ctx1, kCGLineCapRound);
    CGFloat to1;
    to1 = (- M_PI * 0.5 - 0.2) + M_PI * 2;
    if (self.progress==0) {
        CGContextAddArc(ctx1, xCenter, yCenter, radius + 1.5,0, M_PI * 2, 1);
        CGContextStrokePath(ctx1);
    }
    else if ( self.progress <= 0.9) {
            to1 = to + 0.3; // 初始值0.05
            CGContextAddArc(ctx1, xCenter, yCenter, radius + 1.5, - M_PI * 0.5 - 0.2, to1, 1);
            CGContextStrokePath(ctx1);
    }

    // 进度数字
//    NSString *progressStr = [NSString stringWithFormat:@"%.0f", self.progress * 100];
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = FontGothamLight(25 * SDProgressViewFontScale);
//    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    [self setCenterProgressText:self.titleLab uintText:self.titleLab.intValue > 1? SMALocalizedString(@"device_SP_steps"):SMALocalizedString(@"device_SP_step") textFont:self.titleLab.intValue>100000?FontGothamLight(17 * SDProgressViewFontScale):FontGothamLight(20 * SDProgressViewFontScale) uintFont:FontGothamLight(13 * SDProgressViewFontScale)];
}

@end
