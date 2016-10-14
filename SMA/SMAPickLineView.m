//
//  SMAPickLineView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPickLineView.h"

@implementation SMAPickLineView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(ctx, 1);  //线宽
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil,self.frame.size.width,0);
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFillStroke);
    CGPathRelease(path);
    
    CGMutablePathRef bottomPath = CGPathCreateMutable();
    CGPathMoveToPoint(bottomPath, nil, 0, self.frame.size.height);
    CGPathAddLineToPoint(bottomPath, nil,self.frame.size.width,self.frame.size.height);
    CGContextAddPath(ctx, bottomPath);
    CGContextDrawPath(ctx, kCGPathEOFillStroke);
    CGPathRelease(bottomPath);
}


@end
