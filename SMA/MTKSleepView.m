//
//  MTKSleepView.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/17.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSleepView.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/155.0 green:arc4random_uniform(255)/155.0 blue:arc4random_uniform(255)/155.0 alpha:0.7]

#define coorLineWidth 2
#define bottomLineMargin 20
#define coordinateOriginFrame CGRectMake(self.leftLineMargin, self.height - bottomLineMargin, coorLineWidth, coorLineWidth)  // 原点坐标
#define xCoordinateWidth (self.width - self.leftLineMargin - 25)
#define yCoordinateHeight (self.height - bottomLineMargin - 5)

@interface MTKSleepView ()
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (assign, nonatomic) CGRect selfFrame;
@end

@implementation MTKSleepView



+(instancetype)charView
{
    MTKSleepView *chartView = [[self alloc] init];
    // 默认值
    chartView.frame = CGRectMake(10, 70, 300, 220);
    return chartView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selfFrame = frame;
        [self addDrawLabel];
    }
    return self;
}

- (void)addDrawLabel{
    UILabel *deepIma = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, 10, 10)];
    deepIma.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f];
    [self addSubview:deepIma];
    
    CGSize deepSize = [SMALocalizedString(@"device_SL_deep") sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(11)}];
    CGSize lightSize = [SMALocalizedString(@"device_SL_light") sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(11)}];
    CGSize awakeSize = [SMALocalizedString(@"device_SL_awake") sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(11)}];
    
    UILabel *deepLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(deepIma.frame) + 3, 8, deepSize.width, 10)];
    deepLab.font = FontGothamLight(10);
    deepLab.textColor = [UIColor whiteColor];
    deepLab.text = SMALocalizedString(@"device_SL_deep");
    [self addSubview:deepLab];
    
    UILabel *lightIma = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(deepLab.frame) + 13, 8, 10, 10)];
    lightIma.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7f];
    [self addSubview:lightIma];
    
    UILabel *lightLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lightIma.frame) + 3, 8, lightSize.width, 10)];
    lightLab.font = FontGothamLight(10);
    lightLab.textColor = [UIColor whiteColor];
    lightLab.text = SMALocalizedString(@"device_SL_light");
    [self addSubview:lightLab];
    
    UILabel *awakeIma = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lightLab.frame) + 13, 8, 10, 10)];
    awakeIma.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3f];
    [self addSubview:awakeIma];
    
    UILabel *awakeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(awakeIma.frame) + 3, 8, awakeSize.width, 10)];
    awakeLab.font = FontGothamLight(10);
    awakeLab.textColor = [UIColor whiteColor];
    awakeLab.text = SMALocalizedString(@"device_SL_awake");
    [self addSubview:awakeLab];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setUpCoordinateSystem];
    [self drawRectangular];
    //    [self drawSleepRectangular];
    
    // Drawing code
}

- (void)setYValues:(NSArray *)yValues{
    _yValues = yValues;
    CGFloat maxStrWidth = 0;
    for (NSString *yValue in yValues) {
        CGSize size = [yValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        if (size.width > maxStrWidth) {
            maxStrWidth = size.width;
        }
    }
    self.leftLineMargin = maxStrWidth + 6;
}

- (NSDictionary *)textStyleDict{
    if (!_textStyleDict){
        UIFont *font = [UIFont systemFontOfSize:8];
        NSMutableParagraphStyle *sytle = [[NSMutableParagraphStyle alloc]init];
        sytle.alignment = NSTextAlignmentCenter;
        _textStyleDict = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:sytle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    return _textStyleDict;
}

#pragma mark - 创建坐标系
-(void)setUpCoordinateSystem // 利用UIView作为坐标轴动态画出坐标系
{
    CGContextRef ctxy = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil,5, _selfFrame.size.height-20);
    CGPathAddLineToPoint(path, nil, _selfFrame.size.width-5, _selfFrame.size.height-20);
    CGContextSetRGBStrokeColor(ctxy, 1, 1, 1, 1);
    CGContextSetLineCap(ctxy, kCGLineCapRound);
    CGContextAddPath(ctxy, path);
    [[UIColor whiteColor] setFill];
    CGContextDrawPath(ctxy, kCGPathStroke);
    CGPathRelease(path);
    CGFloat x = 0;
    NSMutableArray *xTextP = [NSMutableArray array];
    for (int i = 0; i < _xTexts.count; i++) {
        x = 15 + ((_selfFrame.size.width-30)/(_xTexts.count-1))*i;
        [xTextP addObject:[NSValue valueWithCGPoint:CGPointMake(x, _selfFrame.size.height-15)]];
        CGSize size = [_xTexts[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        [_xTexts[i] drawAtPoint:CGPointMake(x - size.width * 0.5, _selfFrame.size.height-15) withAttributes:self.textStyleDict];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, x, _selfFrame.size.height-15);
        CGPathAddLineToPoint(path, nil,x,_selfFrame.size.height-15-3);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathEOFillStroke);
        CGPathRelease(path);
        
    }
    
}


#pragma mark - 画矩形

- (void)drawSleepRectangular{
    for (int i = 0; i < _xValues.count; i++) {
        NSDictionary *dic1 = _xValues[i];
        CGRect rectangle = CGRectMake(([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15, 15.0f,[dic1[@"SLEEPTIME"] floatValue]*((_selfFrame.size.width-40.0)/(720.0)),_selfFrame.size.height-40.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetLineWidth(ctx, rectangle.size.width);  //线宽
        //          NSLog(@"movePoint = %f",([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15 - rectangle.size.width/2);
        CGPoint movePoint  = CGPointMake(([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15 - rectangle.size.width/2, 15);
        NSLog(@"movePoint = %@",NSStringFromCGPoint(movePoint));
        CGPathMoveToPoint(path, nil, ([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15 - rectangle.size.width/2, 15);
        CGPathAddLineToPoint(path, nil,([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15 - rectangle.size.width/2,_selfFrame.size.height-35-3);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathEOFillStroke);
        CGPathRelease(path);
    }
}
- (void)drawRectangular{
    CGFloat ongy = 0.0;
    for (int i = 0; i < _xValues.count; i++) {
        NSDictionary *dic1 = _xValues[i];
        CGRect rectangle = CGRectMake(([dic1[@"TIME"] floatValue])*((_selfFrame.size.width-40.0)/(720.0))+15, 25.0f,[dic1[@"SLEEPTIME"] floatValue]*((_selfFrame.size.width-40.0)/(720.0)),_selfFrame.size.height-50.0);
        
        ongy = rectangle.origin.x + rectangle.size.width;
        CALayer *layer = [CALayer layer];
        layer.frame = rectangle;
        [self.layer addSublayer:layer];
        UIColor *fillColor;
        if ([dic1[@"QUALITY"] intValue] == 1) {
            fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f];
            //             fillColor = [UIColor greenColor];
        }
        else if([dic1[@"QUALITY"] intValue] == 2){
            fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];
            //              fillColor = [UIColor whiteColor];
        }
        else{
            fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
            //              fillColor = [UIColor blueColor];
        }
        layer.backgroundColor = fillColor.CGColor;
    }
}

-(float)roundFloat:(float)price{
    
    NSString *temp = [NSString stringWithFormat:@"%.7f",price];
    
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       
                                       scale:0
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
    
}
@end
