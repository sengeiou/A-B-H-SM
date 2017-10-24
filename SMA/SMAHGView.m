//
//  SMAHGView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAHGView.h"

@interface SMAHGView ()
{
    didBar selBlock;
    NSDictionary *barDic;
}
@end

@implementation SMAHGView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self drawPolyline:@{@"Xtext":@[@"0",@"12",@"24"],@"XPOINT":@[@"30",@"80",@"600",@"723",@"964",@"1324",@"1439"],@"YPOINT":@[@"30",@"80",@"65",@"43",@"60",@"88",@"88"],@"XPOINT1":@[@"30",@"80",@"600",@"723",@"964",@"1324",@"1440"],@"YPOINT1":@[@"90",@"120",@"165",@"143",@"232",@"188",@"168"]}];
//        [self drawBarGraph:@{@"Xtext":@[@"0",@"12",@"24",@"24"],@"SHRINK":@[@[@"65",@"80"],@[@"65",@"80"],@[@"65",@"80"],@[@"65",@"80"]],@"RELAX":@[@[@"95",@"130"],@[@"105",@"180"],@[@"90",@"240"],@[@"95",@"180"]]}];
    }
    return self;
}

- (void)drawPolyline:(NSDictionary *)Dic{
    CGRect rect = CGRectMake(30, 8, 8, 8);
    CAShapeLayer *shrinShapeLayer = [CAShapeLayer layer];
    UIBezierPath *shrinPath = [UIBezierPath bezierPathWithRect:rect];
    shrinShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shrinShapeLayer.fillColor = [SmaColor colorWithHexString:@"#53d3fd" alpha:1.0].CGColor;
    shrinShapeLayer.path = shrinPath.CGPath;
    [self.layer addSublayer:shrinShapeLayer];
    
     CGSize shrinSize = [SMALocalizedString(@"device_bp_systolic") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(11),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
    CATextLayer *shrinTextlayer = [CATextLayer layer];
    shrinTextlayer.frame = CGRectMake(CGRectGetMaxX(rect) + 4 , rect.origin.y + rect.size.height/2 - shrinSize.height/2 - 1.5, shrinSize.width, shrinSize.height + 1);
    shrinTextlayer.string = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"device_bp_systolic") attributes:@{NSFontAttributeName : FontGothamLight(10),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    shrinTextlayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:shrinTextlayer];
    
    CGRect rect1 = CGRectMake(CGRectGetMaxX(shrinTextlayer.frame) + 18, 8, 8, 8);
    CAShapeLayer *relaxShapeLayer = [CAShapeLayer layer];
    UIBezierPath *relaxPath = [UIBezierPath bezierPathWithRect:rect1];
    relaxShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    relaxShapeLayer.fillColor = [SmaColor colorWithHexString:@"#56faaf" alpha:1.0].CGColor;
    relaxShapeLayer.path = relaxPath.CGPath;
    [self.layer addSublayer:relaxShapeLayer];
    
    CGSize relaxSize = [SMALocalizedString(@"device_bp_diastolic") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(11),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
    CATextLayer *relaxTextlayer = [CATextLayer layer];
    relaxTextlayer.frame = CGRectMake(CGRectGetMaxX(rect1) + 4 , rect.origin.y + rect.size.height/2 - relaxSize.height/2 - 1.5, relaxSize.width, relaxSize.height + 1);
    relaxTextlayer.string = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"device_bp_diastolic") attributes:@{NSFontAttributeName : FontGothamLight(10),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    relaxTextlayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:relaxTextlayer];

    NSArray *XtextArr = Dic[@"Xtext"];
    CGFloat drawW = (self.frame.size.width - 60)/(XtextArr.count - 1);
    CGFloat drawH = self.frame.size.height - 28 - 24;
    CGFloat XbeginPoin = 38;
    CGFloat YbeginPoin = 28;
    CGFloat XDrBeginPoin = 0.0;
    
    CAShapeLayer *Xlayer = [CAShapeLayer layer];
    Xlayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 24, self.frame.size.width, 1);
    Xlayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:Xlayer];
    
    CAShapeLayer *Ylayer = [CAShapeLayer layer];
    Ylayer.frame = CGRectMake(26, YbeginPoin, 1, drawH);
    Ylayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:Ylayer];
    
    CGSize YtextSize = [@"90" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
     CATextLayer *YtextLayer = [CATextLayer layer];
    YtextLayer.frame = CGRectMake(4,YbeginPoin + (drawH - 8)/2 - YtextSize.height/2, YtextSize.width, YtextSize.height);
    YtextLayer.contentsScale = [UIScreen mainScreen].scale;
    YtextLayer.string = [[NSAttributedString alloc] initWithString:@"90" attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.layer addSublayer:YtextLayer];
    
    for (int i = 0; i < XtextArr.count; i ++ ) {
        CGSize textSize = [XtextArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
        CATextLayer *XtextLayer = [CATextLayer layer];
        XtextLayer.frame = CGRectMake(XbeginPoin + drawW * i - textSize.width/2, CGRectGetMaxY(Ylayer.frame) + 4, textSize.width, textSize.height);
        XtextLayer.string = [[NSAttributedString alloc] initWithString:XtextArr[i] attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]}];//whiteColor
        XtextLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:XtextLayer];
        if (i == 0 ) {
            XDrBeginPoin = XbeginPoin + drawW * i;
        }
    }
    
    CAShapeLayer *lineLay = [CAShapeLayer layer];
    lineLay.strokeColor = [SmaColor colorWithHexString:@"#ffffff" alpha:0.5].CGColor;
    [self.layer addSublayer:lineLay];
     UIBezierPath *YPath = [UIBezierPath bezierPath];
    [YPath moveToPoint:CGPointMake(26, YtextLayer.frame.origin.y + YtextLayer.frame.size.height/2)];
    [YPath addLineToPoint:CGPointMake(self.frame.size.width, YtextLayer.frame.origin.y + YtextLayer.frame.size.height/2)];
    lineLay.lineDashPattern = @[@1, @1];//画虚线
    lineLay.path = YPath.CGPath;
    
    
    CALayer *lineLay1 = [CALayer layer];
    lineLay1.frame = CGRectMake(39, YbeginPoin, 2, drawH - 8);
    lineLay1.backgroundColor = [UIColor greenColor].CGColor;
//    [self.layer addSublayer:lineLay1];
    
    CALayer *lineLay2 = [CALayer layer];
    lineLay2.frame = CGRectMake(XDrBeginPoin, self.frame.size.height - 28, drawW * 2, 2);
    lineLay2.backgroundColor = [UIColor greenColor].CGColor;
//    [self.layer addSublayer:lineLay2];
    
    CAShapeLayer *polyLineLayer = [CAShapeLayer layer];
    UIBezierPath *polyPath = [UIBezierPath bezierPath];
    polyLineLayer.strokeColor = [UIColor whiteColor].CGColor;
    polyLineLayer.fillColor = nil;
    polyPath.lineWidth = 2;
    [self.layer addSublayer:polyLineLayer];
    
    CAShapeLayer *polyLineLayer1 = [CAShapeLayer layer];
    UIBezierPath *polyPath1 = [UIBezierPath bezierPath];
    polyLineLayer1.strokeColor = [UIColor whiteColor].CGColor;
    polyLineLayer1.fillColor = nil;
    polyPath1.lineWidth = 5;
    [self.layer addSublayer:polyLineLayer1];
    
    NSArray *XpointArr = Dic[@"XPOINT"];
    NSArray *YpointArr = Dic[@"YPOINT"];
    
    NSArray *XpointArr1 = Dic[@"XPOINT1"];
    NSArray *YpointArr1 = Dic[@"YPOINT1"];
    for (int i = 0; i < XpointArr.count; i ++) {
        CGPoint linePoint = CGPointMake([XpointArr[i] floatValue] * (drawW * 2/1440.0) + XDrBeginPoin,(YbeginPoin + drawH - 8) - ([YpointArr[i] floatValue] - 30) * ((drawH - 8)/2/(90-30)));
        if (i == 0) {
            [polyPath moveToPoint:linePoint];
        }
        else{
            [polyPath addLineToPoint:linePoint];
        }
        CAShapeLayer *poinLayer = [CAShapeLayer layer];
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:linePoint radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        poinLayer.fillColor   = [SmaColor colorWithHexString:@"56faaf" alpha:1.0].CGColor;
        poinLayer.strokeColor = [UIColor whiteColor].CGColor;
        poinLayer.lineWidth = 1.5;
        poinLayer.path = ovalPath.CGPath;
        [self.layer addSublayer:poinLayer];
        
        CGPoint linePoint1 = CGPointMake([XpointArr[i] floatValue] * (drawW * 2/1440.0) + XDrBeginPoin,YbeginPoin + (drawH - 8)/2 - ([YpointArr1[i] floatValue] - 90) * ((drawH - 8)/2/(240-90)));
        if (i == 0) {
            [polyPath1 moveToPoint:linePoint1];
        }
        else{
            [polyPath1 addLineToPoint:linePoint1];
        }
        CAShapeLayer *poinLayer1 = [CAShapeLayer layer];
        UIBezierPath *ovalPath1 = [UIBezierPath bezierPathWithArcCenter:linePoint1 radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        poinLayer1.fillColor   = [SmaColor colorWithHexString:@"53d3fd" alpha:1.0].CGColor;
        poinLayer1.strokeColor = [UIColor whiteColor].CGColor;
        poinLayer1.lineWidth = 1.5;
        poinLayer1.path = ovalPath1.CGPath;
        [self.layer addSublayer:poinLayer1];

    }
    polyLineLayer.path = polyPath.CGPath;
    polyLineLayer1.path = polyPath1.CGPath;
}

- (void)drawBarGraph:(NSDictionary *)Dic{
    barDic = Dic;
    CGRect rect = CGRectMake(30, 8, 8, 8);
    CAShapeLayer *shrinShapeLayer = [CAShapeLayer layer];
    UIBezierPath *shrinPath = [UIBezierPath bezierPathWithRect:rect];
    shrinShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shrinShapeLayer.fillColor = [SmaColor colorWithHexString:@"#53d3fd" alpha:1.0].CGColor;
    shrinShapeLayer.path = shrinPath.CGPath;
    [self.layer addSublayer:shrinShapeLayer];
    
    CGSize shrinSize = [SMALocalizedString(@"device_bp_systolic") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(11),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
    CATextLayer *shrinTextlayer = [CATextLayer layer];
    shrinTextlayer.frame = CGRectMake(CGRectGetMaxX(rect) + 4 , rect.origin.y + rect.size.height/2 - shrinSize.height/2 - 1.5, shrinSize.width, shrinSize.height + 1);
    shrinTextlayer.string = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"device_bp_systolic") attributes:@{NSFontAttributeName : FontGothamLight(10),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    shrinTextlayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:shrinTextlayer];
    
    CGRect rect1 = CGRectMake(CGRectGetMaxX(shrinTextlayer.frame) + 18, 8, 8, 8);
    CAShapeLayer *relaxShapeLayer = [CAShapeLayer layer];
    UIBezierPath *relaxPath = [UIBezierPath bezierPathWithRect:rect1];
    relaxShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    relaxShapeLayer.fillColor = [SmaColor colorWithHexString:@"#56faaf" alpha:1.0].CGColor;
    relaxShapeLayer.path = relaxPath.CGPath;
    [self.layer addSublayer:relaxShapeLayer];
    
    CGSize relaxSize = [SMALocalizedString(@"device_bp_systolic") boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(11),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
    CATextLayer *relaxTextlayer = [CATextLayer layer];
    relaxTextlayer.frame = CGRectMake(CGRectGetMaxX(rect1) + 4 , rect.origin.y + rect.size.height/2 - relaxSize.height/2 - 1.5, relaxSize.width, relaxSize.height + 1);
    relaxTextlayer.string = [[NSAttributedString alloc] initWithString:SMALocalizedString(@"device_bp_diastolic") attributes:@{NSFontAttributeName : FontGothamLight(10),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    relaxTextlayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:relaxTextlayer];

    NSArray *XtextArr = Dic[@"Xtext"];
    CGFloat drawW = (self.frame.size.width - 48)/(XtextArr.count);
    CGFloat drawH = self.frame.size.height - 28 - 24;
    CGFloat XbeginPoin = 48;
    CGFloat YbeginPoin = 28;
    
    CAShapeLayer *Xlayer = [CAShapeLayer layer];
    Xlayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 24, self.frame.size.width, 1);
    Xlayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:Xlayer];
    
    CAShapeLayer *Ylayer = [CAShapeLayer layer];
    Ylayer.frame = CGRectMake(26, YbeginPoin, 1, drawH);
    Ylayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:Ylayer];
    
    CGSize YtextSize = [@"90" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
    CATextLayer *YtextLayer = [CATextLayer layer];
    YtextLayer.frame = CGRectMake(4,YbeginPoin + (drawH - 8)/2 - YtextSize.height/2, YtextSize.width, YtextSize.height);
    YtextLayer.contentsScale = [UIScreen mainScreen].scale;
    YtextLayer.string = [[NSAttributedString alloc] initWithString:@"90" attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.layer addSublayer:YtextLayer];
    
    for (int i = 0; i < XtextArr.count; i ++ ) {
        CGSize textSize = [XtextArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil].size;
//        CATextLayer *XtextLayer = [CATextLayer layer];
//        XtextLayer.frame = CGRectMake(XbeginPoin + drawW * i + drawW/2 - textSize.width/2, CGRectGetMaxY(Ylayer.frame) + 4, textSize.width, textSize.height);
//        XtextLayer.string = [[NSAttributedString alloc] initWithString:XtextArr[i] attributes:@{NSFontAttributeName : FontGothamLight(13),NSForegroundColorAttributeName:[UIColor whiteColor]}];//whiteColor
//        XtextLayer.contentsScale = [UIScreen mainScreen].scale;
//        XtextLayer.backgroundColor = [UIColor blueColor].CGColor;
//        [self.layer addSublayer:XtextLayer];
        UILabel *XtextLayer = [UILabel new];
        XtextLayer.frame = CGRectMake(XbeginPoin + drawW * i + drawW/2 - textSize.width/2, CGRectGetMaxY(Ylayer.frame) + 6, textSize.width, textSize.height);
        XtextLayer.attributedText = [[NSAttributedString alloc] initWithString:XtextArr[i] attributes:@{NSFontAttributeName : FontGothamLight(10),NSForegroundColorAttributeName:[UIColor whiteColor]}];//whiteColor
//        XtextLayer.layer.shadowColor = [UIColor blackColor].CGColor;
//        XtextLayer.layer.shadowOffset = CGSizeMake(3, 3);
//        XtextLayer.layer.shadowRadius = 3.0;
//        XtextLayer.layer.shadowOpacity = 1.0;
//        XtextLayer.contentsScale = [UIScreen mainScreen].scale;
//        XtextLayer.backgroundColor = [UIColor blueColor];
        [self addSubview:XtextLayer];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame =  CGRectMake(XbeginPoin + drawW * i, 28, drawW, drawH);
        [but setBackgroundImage:[UIImage imageNamed:@"矩形 2"] forState:UIControlStateSelected];
        [but setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:but.frame.size] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(selectBar:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = 1000 + i;
        if (i == XtextArr.count - 1) {
            but.selected = YES;
        }
        [self addSubview:but];
        
        NSArray *shrinkPointArr = Dic[@"RELAX"][i];
        NSArray *relaxPointArr = Dic[@"SHRINK"][i];
        CGPoint shrinkPoint0 = CGPointMake(XbeginPoin + drawW * i + drawW/2,(YbeginPoin + drawH - 8) - (([shrinkPointArr[0] floatValue] <= 30 ? 30:[shrinkPointArr[0] floatValue]) - 30) * ((drawH - 8)/2/(90-30)));
        shrinkPoint0.x = shrinkPoint0.x <= 0 ? 0:shrinkPoint0.x;
        shrinkPoint0.y = shrinkPoint0.y <= 0 ? 0:shrinkPoint0.y;
        CGPoint shrinkPoint1 = CGPointMake(XbeginPoin + drawW * i + drawW/2,(YbeginPoin + drawH - 8) - (([shrinkPointArr[1] floatValue] <= 30 ? 30:[shrinkPointArr[1] floatValue]) - 30) * ((drawH - 8)/2/(90-30)));
        shrinkPoint1.x = shrinkPoint1.x <= 0 ? 0:shrinkPoint1.x;
        shrinkPoint1.y = shrinkPoint1.y <= 0 ? 0:shrinkPoint1.y;
        CAShapeLayer *shrinkLayer = [CAShapeLayer layer];
        UIBezierPath *shrinkPath = [UIBezierPath bezierPath];
        [shrinkPath moveToPoint:shrinkPoint0];
        [shrinkPath addLineToPoint:shrinkPoint1];
        shrinkLayer.path = shrinkPath.CGPath;
        shrinkLayer.lineWidth = 3.0f;
        shrinkLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        CAShapeLayer *poinLayer1 = [CAShapeLayer layer];
        UIBezierPath *ovalPath1 = [UIBezierPath bezierPathWithArcCenter:shrinkPoint0 radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        poinLayer1.fillColor   = [SmaColor colorWithHexString:@"56faaf" alpha:1.0].CGColor;
        poinLayer1.strokeColor = [UIColor whiteColor].CGColor;
        poinLayer1.lineWidth = 1.5;
        poinLayer1.path = ovalPath1.CGPath;
        
        CAShapeLayer *poinLayer2 = [CAShapeLayer layer];
        UIBezierPath *ovalPath2 = [UIBezierPath bezierPathWithArcCenter:shrinkPoint1 radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        poinLayer2.fillColor   = [SmaColor colorWithHexString:@"56faaf" alpha:1.0].CGColor;
        poinLayer2.strokeColor = [UIColor whiteColor].CGColor;
        poinLayer2.lineWidth = 1.5;
        poinLayer2.path = ovalPath2.CGPath;
        
        if ([shrinkPointArr[0] floatValue] >= 30) {
            [self.layer addSublayer:shrinkLayer];
            [self.layer addSublayer:poinLayer1];
            [self.layer addSublayer:poinLayer2];
        }
        
        CGPoint relaxPoint0 = CGPointMake(XbeginPoin + drawW * i + drawW/2,YbeginPoin + (drawH - 8)/2 - (([relaxPointArr[0] floatValue] <= 90 ? 90:[relaxPointArr[0] floatValue]) - 90) * ((drawH - 8)/2/(240-90)));
        CGPoint relaxPoint1 = CGPointMake(XbeginPoin + drawW * i + drawW/2,YbeginPoin + (drawH - 8)/2 - (([relaxPointArr[1] floatValue] <= 90? 90: [relaxPointArr[1] floatValue]) - 90) * ((drawH - 8)/2/(240-90)));
        CAShapeLayer *relaxLayer = [CAShapeLayer layer];
        UIBezierPath *relaxPath = [UIBezierPath bezierPath];
        [relaxPath moveToPoint:relaxPoint0];
        [relaxPath addLineToPoint:relaxPoint1];
        relaxLayer.path = relaxPath.CGPath;
        relaxLayer.lineWidth = 3.0f;
        relaxLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        CAShapeLayer *relaxPoinLayer1 = [CAShapeLayer layer];
        UIBezierPath *relaxOvalPath1 = [UIBezierPath bezierPathWithArcCenter:relaxPoint0 radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        relaxPoinLayer1.fillColor   = [SmaColor colorWithHexString:@"53d3fd" alpha:1.0].CGColor;
        relaxPoinLayer1.strokeColor = [UIColor whiteColor].CGColor;
        relaxPoinLayer1.lineWidth = 1.5;
        relaxPoinLayer1.path = relaxOvalPath1.CGPath;
        
        
        CAShapeLayer *relaxPoinLayer2 = [CAShapeLayer layer];
        UIBezierPath *relaxOvalPath2 = [UIBezierPath bezierPathWithArcCenter:relaxPoint1 radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        relaxPoinLayer2.fillColor   = [SmaColor colorWithHexString:@"53d3fd" alpha:1.0].CGColor;
        relaxPoinLayer2.strokeColor = [UIColor whiteColor].CGColor;
        relaxPoinLayer2.lineWidth = 1.5;
        relaxPoinLayer2.path = relaxOvalPath2.CGPath;
        
        if ([relaxPointArr[0] floatValue] >= 90) {
            [self.layer addSublayer:relaxLayer];
            [self.layer addSublayer:relaxPoinLayer1];
            [self.layer addSublayer:relaxPoinLayer2];
        }
    }
   
    CAShapeLayer *lineLay = [CAShapeLayer layer];
    lineLay.strokeColor = [SmaColor colorWithHexString:@"#ffffff" alpha:0.5].CGColor;
    [self.layer addSublayer:lineLay];
    UIBezierPath *YPath = [UIBezierPath bezierPath];
    [YPath moveToPoint:CGPointMake(26, YtextLayer.frame.origin.y + YtextLayer.frame.size.height/2)];
    [YPath addLineToPoint:CGPointMake(self.frame.size.width, YtextLayer.frame.origin.y + YtextLayer.frame.size.height/2)];
    lineLay.lineDashPattern = @[@1, @1];//画虚线
    lineLay.path = YPath.CGPath;
}

- (void)didSelectBar:(didBar)callBack{
    selBlock = callBack;
}

- (void)selectBar:(UIButton *)sender{
    for (UIButton *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
             view.selected = NO;
        }
    }
    sender.selected = YES;
    if (selBlock) {
        selBlock(barDic,sender.tag - 1000);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
