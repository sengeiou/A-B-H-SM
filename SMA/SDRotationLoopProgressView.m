//
//  SDRotationLoopProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-20.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDRotationLoopProgressView.h"

// 加载时显示的文字
NSString * const SDRotationLoopProgressViewWaitingText = @"LOADING...";

@implementation SDRotationLoopProgressView

{
    CGFloat _angleInterval;
    CGRect iamgeRect;
    BOOL firstLun;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        firstLun = NO;
//        self.layer.opaque = YES;
    }
    return self;
}

- (void)createUIRect:(CGRect)rect{
    
   CAShapeLayer * excircle = [CAShapeLayer layer];
    excircle.frame                     = CGRectMake(0, 0, rect.size.width, rect.size.height);
    excircle.fillColor                 = nil;
    excircle.strokeColor               = [UIColor colorWithRed:0.158 green: 0.329 blue:0.253 alpha:0].CGColor;
    excircle.path                      = [self ovalPathect:rect].CGPath;
    
    CAGradientLayer* ovalGradient = [CAGradientLayer layer];
//    ovalGradient.name              = @"gradient";
    CAShapeLayer* ovalMask         = [CAShapeLayer layer];
    ovalMask.path                  = excircle.path;
    ovalGradient.mask              = ovalMask;
    ovalGradient.frame             = excircle.bounds;
    ovalGradient.colors            = @[(id)[UIColor colorWithRed:0.941 green: 0.557 blue:0.8 alpha:1].CGColor, (id)[UIColor colorWithRed:0.847 green: 0.0863 blue:0.388 alpha:1].CGColor];//由于渐变导致页面滑动会出现卡顿
    ovalGradient.startPoint        = CGPointMake(0.5, 1);
    ovalGradient.endPoint          = CGPointMake(0.5, 0);
    [excircle addSublayer:ovalGradient];
    
    [self.layer addSublayer:excircle];
    
    // 遮罩
    CAShapeLayer * shadeOval = [CAShapeLayer layer];
    shadeOval.frame       = CGRectMake(rect.size.width/12, rect.size.height/12, rect.size.width-rect.size.width/6, rect.size.height-rect.size.height/6);
    shadeOval.fillColor   = [UIColor colorWithRed:0.949 green: 0.973 blue:0.996 alpha:1].CGColor;
    shadeOval.strokeColor = [UIColor colorWithRed:0.158 green: 0.329 blue:0.253 alpha:0].CGColor;
    shadeOval.path        = [self ovalPathect:shadeOval.frame].CGPath;
    [self.layer addSublayer:shadeOval];

    // 中心圆环
    CAShapeLayer * centreOval1 = [CAShapeLayer layer];
    centreOval1.frame       = CGRectMake(rect.size.width/5 - 1, rect.size.height/5 - 1, rect.size.width-rect.size.width/5*2 + 2, rect.size.height-rect.size.height/5*2 + 2);
    centreOval1.opaque = YES;
    centreOval1.fillColor   = [UIColor colorWithRed:0.937 green: 0.545 blue:0.788 alpha:0.3].CGColor;
    centreOval1.strokeColor = [UIColor colorWithRed:0.937 green: 0.545 blue:0.788 alpha:0].CGColor;
    centreOval1.path        = [self ovalPathect:centreOval1.frame].CGPath;
    [self.layer addSublayer:centreOval1];
    
//    // 中心圆
    CAShapeLayer * centreOval = [CAShapeLayer layer];
    centreOval.frame       = CGRectMake(rect.size.width/5, rect.size.height/5, rect.size.width-rect.size.width/5*2, rect.size.height-rect.size.height/5*2);
    centreOval.opaque = YES;
    centreOval.fillColor   = [UIColor colorWithRed:0.882 green: 0.933 blue:0.988 alpha:1].CGColor;
    centreOval.strokeColor = [UIColor colorWithRed:0.158 green: 0.329 blue:0.253 alpha:0].CGColor;
    centreOval.path        = [self ovalPathect:centreOval.frame].CGPath;
    [self.layer addSublayer:centreOval];
    


//    //中心图片
    CALayer *logoImalayer = [CALayer layer];
    logoImalayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"main_heart"].CGImage);
    logoImalayer.frame       = CGRectMake(CGRectGetMaxX(centreOval.frame)-rect.size.width/5, CGRectGetMinY(centreOval.frame)+rect.size.height/10, rect.size.width/10, rect.size.height/10);
    logoImalayer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, logoImalayer.frame.size.width, logoImalayer.frame.size.height)].CGPath;
    [self.layer addSublayer:logoImalayer];
    
    //旋转图片
    
    iamgeRect      = CGRectMake(CGRectGetMidX(shadeOval.frame) - rect.size.width/28, CGRectGetMinY(centreOval.frame)-rect.size.height/11-1, rect.size.width/14, rect.size.height/11);//初始旋转图片所在位置
//    [self drawTextLayer:rect pragrassText:@"0"];
}

- (void)drawTextLayer:(CGRect)rect pragrassText:(NSString *)textStr{
    
        [self.text removeFromSuperlayer];
        [self.unitText removeFromSuperlayer];
        [self.imageLayer removeFromSuperlayer];//由于同时修改frame及transform导致图像旋转变形，因此移除再新建，原因不明
    CGPoint center = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);
    CGSize fontsize = [textStr sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17 * SDProgressViewFontScale)}];
    CGFloat X = center.x -fontsize.width/2;
    CGFloat Y = center.y - fontsize.height/2;
    self.text = [CATextLayer layer];
    self.text.frame           = CGRectMake(X, Y, fontsize.width, fontsize.height);
    self.text.contentsScale   = [[UIScreen mainScreen] scale];
    self.text.string          =[[NSAttributedString alloc] initWithString:textStr attributes:@{NSFontAttributeName : FontGothamLight(17 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.text.alignmentMode   = kCAAlignmentCenter;
    [self.layer addSublayer:self.text];
    
    //单位
    CGSize unitFontsize = [@"bpm" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(12 * SDProgressViewFontScale)}];
    //计算点坐标
    CGFloat X1 = center.x - unitFontsize.width/2;
    CGFloat Y1 = center.y + fontsize.height/2;
    self.unitText = [CATextLayer layer];
    self.unitText.frame           = CGRectMake(X1, Y1, unitFontsize.width, unitFontsize.height);
    self.unitText.contentsScale   = [[UIScreen mainScreen] scale];
   self.unitText.string          =[[NSAttributedString alloc] initWithString:@"bpm" attributes:@{NSFontAttributeName : FontGothamLight(10 * SDProgressViewFontScale),NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.unitText.alignmentMode   = kCAAlignmentCenter;
    [self.layer addSublayer:self.unitText];

     //旋转图片
    self.imageLayer = [CALayer layer];
    self.imageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"main_heart_point"].CGImage);
    self.imageLayer.frame       = iamgeRect;
    self.imageLayer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height)].CGPath;
    [self.layer addSublayer:self.imageLayer];
    CGFloat X2 =  rect.size.width/2 + (rect.size.width/2 -CGRectGetMidY(iamgeRect)) *sin(M_PI/180*(360.0*self.progress)) - iamgeRect.size.width/2; //R*sinB(夹角)
    CGFloat Y2 =  rect.size.height/2 - (rect.size.height/2 -CGRectGetMidY(iamgeRect)) *cos(M_PI/180*(360.0*self.progress)) - iamgeRect.size.height/2;//R*cosB(夹角)
    
    self.imageLayer.frame = CGRectMake(X2, Y2, self.imageLayer.frame.size.width, self.imageLayer.frame.size.height);
    self.imageLayer.transform =  CATransform3DMakeRotation(M_PI/180*(360.0*self.progress), 0, 0, 1);

}

- (void)changeAngle
{
    _angleInterval += M_PI * 0.08;
    if (_angleInterval >= M_PI * 2) _angleInterval = 0;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if (!firstLun) {
        [self createUIRect:rect];
        firstLun = YES;
    }
    [self drawTextLayer:rect pragrassText:[NSString stringWithFormat:@"%.0f", self.progress * 200]];
}

#pragma mark - Bezier Path

- (UIBezierPath*)ovalPathect:(CGRect)rect{
//    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
     UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:rect.size.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return ovalPath;
}

- (UIBezierPath*)shadeOvalPathect:(CGRect)rect{
//   UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:rect.size.width/2-10 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    return ovalPath;
}
@end
