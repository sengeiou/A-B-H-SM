//
//  SDBPProgressView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SDBPProgressView.h"

@implementation SDBPProgressView

//- (void)setBPProgres:(CGFloat)shrinkPor relaxaion:(CGFloat)relaPro{
//    
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [[SmaColor colorWithHexString:@"#b6c0c9" alpha:1.0] set];
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin - 5;
    CGContextAddArc(ctx, xCenter, yCenter, radius, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
     [[SmaColor colorWithHexString:@"#bbc9d5" alpha:1.0] set];
    CGContextAddArc(ctx, xCenter, yCenter, radius + 10, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    [[SmaColor colorWithHexString:@"#ffb446" alpha:1.0] set];
    CGFloat to = - M_PI * 0.5 + self.BPprogress * M_PI * 2;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5 , to, 0);
    CGContextStrokePath(ctx);
    
     [[SmaColor colorWithHexString:@"#fc4e1b" alpha:1.0] set];
     CGFloat to1 = - M_PI * 0.5 + self.progress * M_PI * 2;
     CGContextAddArc(ctx, xCenter, yCenter, radius + 10, - M_PI * 0.5 , to1, 0);
     CGContextStrokePath(ctx);
    
//    CGFloat textHei = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin - 15;
    
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:self.BPtitleLab ? self.BPtitleLab:@"" attributes:@{NSFontAttributeName :FontGothamLight(30),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#596877" alpha:1.0],NSBackgroundColorAttributeName:[UIColor clearColor]}];
    CGSize strSize1 = [self.BPtitleLab ? self.BPtitleLab:@""  sizeWithAttributes:@{NSFontAttributeName :FontGothamLight(30),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#596877" alpha:1.0]}];
    CGFloat strX1 = xCenter - strSize1.width * 0.5;
    CGFloat strY1 = yCenter - strSize1.height * 0.5 + 12;
    CGRect rect1 = CGRectMake(strX1, strY1, strSize1.width, strSize1.height);
    [attrStr1 drawInRect:rect1];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"mmHg" attributes:@{NSFontAttributeName :FontGothamLight(15),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#b6c0c9" alpha:1.0]}];
    CGSize strSize = [@"mmHg" sizeWithAttributes:@{NSFontAttributeName :FontGothamLight(15),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#aaabad" alpha:1.0]}];
    CGFloat strX = xCenter - strSize.width * 0.5;
//    CGFloat strY = yCenter + textHei - strSize.height - 1;
    CGRect rect0 = CGRectMake(strX, CGRectGetMaxY(rect1) , strSize.width, strSize.height);
     [attrStr drawInRect:rect0];
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:self.titleLab ? self.titleLab:@"" attributes:@{NSFontAttributeName :FontGothamLight(30),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#596877" alpha:1.0],NSBackgroundColorAttributeName:[UIColor clearColor ]}];
    CGSize strSize2 = [self.titleLab ? self.titleLab:@"" sizeWithAttributes:@{NSFontAttributeName :FontGothamLight(30),NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#596877" alpha:1.0]}];
    CGFloat strX2 = xCenter - strSize2.width * 0.5;
    CGFloat strY2 = yCenter - strSize2.height - 4;
    CGRect rect2 = CGRectMake(strX2, strY2, strSize2.width, strSize2.height);
    [attrStr2 drawInRect:rect2];
    
    CGContextMoveToPoint(ctx, rect2.origin.x - 4, CGRectGetMaxY(rect2));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect2) + 4, CGRectGetMaxY(rect2));
    CGContextSetLineWidth(ctx, 1.0);
    [[SmaColor colorWithHexString:@"#596877" alpha:1.0] set];
    CGContextStrokePath(ctx);
}

@end
