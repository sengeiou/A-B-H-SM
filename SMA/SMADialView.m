//
//  SMADialView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/31.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADialView.h"

@implementation SMADialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setDialArr:(NSMutableArray *)dialArr{
    _dialArr = dialArr;
      [self setupLayers];
}

- (void)setupLayers{
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer * oval = [CAShapeLayer layer];
    oval.frame       = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    oval.fillColor   = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
    oval.strokeColor = [UIColor colorWithRed:0.329 green: 0.329 blue:0.329 alpha:1].CGColor;
    oval.path        = [self ovalPath].CGPath;

    [self.layer addSublayer:oval];
    _dialPoinArr = [NSMutableArray array];
     CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    for (int i = 1; i <= _dialArr.count; i ++) {
         CGSize fontsize = [[_dialArr objectAtIndex:i - 1] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(15)}];
        //计算点坐标
         CGFloat X = center.x + (self.frame.size.width/2 -fontsize.height) *sin((M_PI/180)*i*(360.0 /(_dialArr.count))) - fontsize.width/2; //R*sinB(夹角)
         CGFloat Y = center.y - (self.frame.size.width/2 -fontsize.height) *cos((M_PI/180)*i*(360.0 /(_dialArr.count))) - fontsize.height/2;//R*cosB(夹角)
        CATextLayer * text = [CATextLayer layer];
        text.frame           = CGRectMake(X, Y, fontsize.width, fontsize.height);
        text.contentsScale   = [[UIScreen mainScreen] scale];
        text.string          = [_dialArr objectAtIndex:i - 1];
        text.font            = (__bridge CFTypeRef)@"Gotham-Light";
        text.fontSize        = 15;
        text.alignmentMode   = kCAAlignmentCenter;
        text.foregroundColor = [UIColor blackColor].CGColor;
        text.transform =  CATransform3DMakeRotation((M_PI/180)*i*(360.0 /(_dialArr.count)), 0, 0, 1);
        [_dialPoinArr addObject:[NSString stringWithFormat:@"%f",(M_PI/180)*i*(360.0 /(_dialArr.count))]];
        [self.layer addSublayer:text];
    }
}

- (UIBezierPath*)ovalPath{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return ovalPath;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
