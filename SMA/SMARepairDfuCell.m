//
//  SMARepairDfuCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMARepairDfuCell.h"

@implementation SMARepairDfuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    [[UIColor grayColor] set];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    if (self.topShow) {
      CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    }
    else{
       CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
    }
    CGContextAddLineToPoint(context, self.frame.size.width , 0);
      CGContextStrokePath(context);
    if (self.rightShow) {
        CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    }
    else{
       CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
    }
    CGContextMoveToPoint(context, self.frame.size.width , 0);
    CGContextAddLineToPoint(context, self.frame.size.width , self.frame.size.height);
      CGContextStrokePath(context);
    if (self.bottomShow) {
        CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    }
    else{
       CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
    }
    CGContextMoveToPoint(context, self.frame.size.width , self.frame.size.height);
    CGContextAddLineToPoint(context, 0 , self.frame.size.height);
    CGContextStrokePath(context);
    if (self.leftpShow) {
       CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
    }
    else{
       CGContextSetStrokeColorWithColor(context,[UIColor clearColor].CGColor);
    }
    CGContextMoveToPoint(context, 0 , self.frame.size.height);
    CGContextAddLineToPoint(context, 0 , 0);
    CGContextStrokePath(context);
}

@end
