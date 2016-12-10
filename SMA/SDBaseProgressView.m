//
//  SDBaseProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBaseProgressView.h"

@implementation SDBaseProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (_progress >= 1 ) {
        _progress = 0.99;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_progress >= 1.0) {
            [self removeFromSuperview];
        } else {
            [self setNeedsDisplay];
        }
    });
    
}

//- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
//{
//    CGFloat xCenter = self.frame.size.width * 0.5;
//    CGFloat yCenter = self.frame.size.height * 0.5;
//    
//    // 判断系统版本
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//        CGSize strSize = [text sizeWithAttributes:attributes];
//        CGFloat strX = xCenter - strSize.width * 0.5;
//        CGFloat strY = yCenter - strSize.height * 0.5;
//        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
//    } else {
//        CGSize strSize;
//        NSAttributedString *attrStr = nil;
//        if (attributes[NSFontAttributeName]) {
//            strSize = [text sizeWithFont:attributes[NSFontAttributeName]];
//            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//        } else {
//            strSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
//            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
//        }
//        
//        CGFloat strX = xCenter - strSize.width * 0.5;
//        CGFloat strY = yCenter - strSize.height * 0.5;
//        
//        [attrStr drawAtPoint:CGPointMake(strX, strY)];
//    }
//    
//}



- (void)setCenterProgressText:(NSString *)text uintText:(NSString *)uint textFont:(UIFont *)font uintFont:(UIFont *)font1
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    CGSize strSize;
    CGSize strUintSize;
    NSAttributedString *attrStr = nil;
    NSAttributedString *attrUintStr = nil;
 
//    NSShadow *shadow = [[NSShadow alloc] init];//阴影
//    shadow.shadowBlurRadius = 1;
//    shadow.shadowColor = [UIColor blueColor];
//    shadow.shadowOffset = CGSizeMake(1, 3);
    attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :font}];
    attrUintStr = [[NSAttributedString alloc] initWithString:uint attributes:@{NSFontAttributeName : font1,NSForegroundColorAttributeName:[UIColor grayColor]}];
    strSize = [text sizeWithAttributes:@{NSFontAttributeName :font}];
    strUintSize = [uint sizeWithAttributes:@{NSFontAttributeName :font1}];
    
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    
    CGFloat strX1 = xCenter - strUintSize.width * 0.5;
    CGFloat strY1 = yCenter + strSize.height*0.5;
    [attrStr drawAtPoint:CGPointMake(strX, strY)];
    [attrUintStr drawAtPoint:CGPointMake(strX1, strY1)];
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}

- (void)createUIRect:(CGRect)rect{
   NSLog(@"this is father function....");  
}
@end
