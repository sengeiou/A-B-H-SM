//
//  SDPieLoopProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-20.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPieLoopProgressView.h"

@implementation SDPieLoopProgressView
{
    CAShapeLayer *backLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setupLayers:(CGRect)rect{
    
    self.layer.shadowColor = [UIColor colorWithRed:0.353 green: 0.827 blue:0.561 alpha:1].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.clipsToBounds = NO;
    
    CGPoint center = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);
    
    [backLayer removeFromSuperlayer];
    backLayer = [[CAShapeLayer alloc] init];
    backLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    [self.layer addSublayer:backLayer];
    for (int i = 1; i <= 12; i ++) {
        
        CATextLayer * text = [CATextLayer layer];
        
        text.contentsScale   = [[UIScreen mainScreen] scale];
        
        if (i%3) {
            CGSize fontsize = CGSizeMake(4, 8);
//            CGSize fontsize = [@"|" sizeWithAttributes:@{NSFontAttributeName:FontGothamBold(10 * SDProgressViewFontScale)}];
            //计算点坐标
            CGFloat X = center.x + (rect.size.width/2 -(fontsize.height +5)/2) *sin((M_PI/180)*i*(360.0 /(12))) - fontsize.width/2; //R*sinB(夹角)
            CGFloat Y = center.y - (rect.size.width/2 -(fontsize.height +5)/2) *cos((M_PI/180)*i*(360.0 /(12))) - fontsize.height/2;//R*cosB(夹角)
            text.frame           = CGRectMake(X, Y, fontsize.width, fontsize.height);
            text.string    =  [[NSAttributedString alloc] initWithString:@"|" attributes:@{NSFontAttributeName : FontGothamBold(10 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor whiteColor]}];//whiteColor
            if (i<self.startTime/5 && i > self.endTime/5) {
                text.string    =  [[NSAttributedString alloc] initWithString:@"|" attributes:@{NSFontAttributeName : FontGothamBold(10 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor grayColor]}];
            }
            
            text.alignmentMode   = kCAAlignmentCenter;
            text.foregroundColor = [UIColor blueColor].CGColor;
            text.transform =  CATransform3DMakeRotation((M_PI/180)*i*(360.0 /(12)), 0, 0, 1);
        }
        else{
            CGSize fontsize = [[NSString stringWithFormat:@"%d",i] sizeWithAttributes:@{NSFontAttributeName:FontGothamBold(12 * SDProgressViewFontScale)}];
            //计算点坐标
            CGFloat X = center.x + (rect.size.width/2 -fontsize.height/2) *sin((M_PI/180)*i*(360.0 /(12))) - fontsize.width/2; //R*sinB(夹角)
            CGFloat Y = center.y - (rect.size.width/2 -fontsize.height/2) *cos((M_PI/180)*i*(360.0 /(12))) - fontsize.height/2 + 1;//R*cosB(夹角)
            text.frame           = CGRectMake(X, Y, fontsize.width, fontsize.height);
            text.string    =  [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",i] attributes:@{NSFontAttributeName : FontGothamBold(12 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor whiteColor]}];
            if (i<self.startTime/5 && i > self.endTime/5) {
                text.string   =  [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",i] attributes:@{NSFontAttributeName : FontGothamBold(12 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor grayColor]}];
            }
            text.alignmentMode   = kCAAlignmentCenter;
        }
        
        text.foregroundColor = [UIColor blackColor].CGColor;
        [backLayer addSublayer:text];
    }
}

- (void)drawRect:(CGRect)rect
{
    //    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 2, rect.size.height - 2);
    [self setupLayers:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SDProgressViewItemMargin * 0.2;
    
    // 背景圆
    [SDColorMaker(255, 255, 255, 1) set];
    CGFloat w = radius * 2 ;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    //    CGContextSetShadowWithColor(ctx, CGSizeMake(20, 20), 20, [UIColor clearColor].CGColor);
    // 进度环边框
    [[UIColor blueColor] set];
    CGFloat masW = w + 2;
    CGFloat masH = masW;
    //    CGFloat masX = (rect.size.width - masW) * 0.5;
    //    CGFloat masY = (rect.size.height - masH) * 0.5;
    //    CGContextAddEllipseInRect(ctx, CGRectMake(masX, masY, masW, masH));
    //    CGContextStrokePath(ctx);
    
    // 进度环
    [[SmaColor colorWithHexString:@"#59D9A4" alpha:1] set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGFloat to = M_PI * (((self.startTime-15)/60.0*360 - 360)/180) + (self.endTime-self.startTime)/60.0 * M_PI * 2 ; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, M_PI * (((self.startTime-15)/60.0*360 - 360)/180.0), to, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    // 遮罩
    [SDColorMaker(240, 240, 240, 1) set];
    CGFloat maskW = (radius /4) * 2;
    CGFloat maskH = maskW;
    CGFloat maskX = (rect.size.width - maskW) * 0.5;
    CGFloat maskY = (rect.size.height - maskH) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(maskX, maskY, maskW, maskH));
    //    CGContextFillPath(ctx);
    
    //中心图片
    CALayer *logoImalayer = [CALayer layer];
    logoImalayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"home_sleep"].CGImage);
    logoImalayer.frame       = CGRectMake(maskX, maskY, maskW, maskH);
    logoImalayer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, logoImalayer.frame.size.width, logoImalayer.frame.size.height)].CGPath;
    [self.layer addSublayer:logoImalayer];
    
    // 遮罩边框
    [[UIColor grayColor] set];
    CGFloat borderW = maskW + 1;
    CGFloat borderH = borderW;
    CGFloat borderX = (rect.size.width - borderW) * 0.5;
    CGFloat borderY = (rect.size.height - borderH) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(borderX, borderY, borderW, borderH));
    //    CGContextStrokePath(ctx);
    
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", self.progress * 100, "\%"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    
    //    [self setCenterProgressText:progressStr withAttributes:attributes];
}

- (UIBezierPath*)ovalPathect:(CGRect)rect{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, (rect.size.height)/2) radius:(rect.size.width)/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return ovalPath;
}
@end
