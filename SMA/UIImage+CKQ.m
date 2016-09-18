//
//  UIImage+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+CKQ.h"

@implementation UIImage (CKQ)
+ (UIImage *)imageWithName:(NSString *)name
{

//    if (iOS7) {
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        UIImage *image = [UIImage imageNamed:newName];
//        if (image == nil) { // 没有_os7后缀的图片
//            image = [UIImage imageNamed:name];
//        }
//        return image;
//    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}

+ (UIImage *)imageLocalWithName:(NSString *)name
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    //英文
    if(![[preferredLang substringToIndex:2] isEqualToString:@"zh"])
    {
        NSString *newName = [name stringByAppendingString:@"_en"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize imageName:(NSString *)imageName
{
    
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        
    {
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            
            scaleFactor = widthFactor; // scale to fit height
        
        else
            
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor)
            
        {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }
        
        else if (widthFactor < heightFactor)
            
        {
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width= scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType size:(CGSize )size{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0,size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType radius:(CGFloat)radius size:(CGSize )size{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
//    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0,size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    // borderWidth 表示边框的宽度
//    CGFloat borderWidth = 0;
//    CGFloat imageW = image.size.width + 2 * borderWidth;
//    CGFloat imageH = imageW;
//    CGSize imageSize = CGSizeMake(imageW, imageH);
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
//    CGContextRef context1 = UIGraphicsGetCurrentContext();
//    // borderColor表示边框的颜色
//    [[UIColor blueColor] set];
//    CGFloat bigRadius = imageW * 0.5;
//    CGFloat centerX = bigRadius;
//    CGFloat centerY = bigRadius;
//    CGContextAddArc(context1, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
//    CGContextFillPath(context1);
//    CGFloat smallRadius = bigRadius - borderWidth;
//    CGContextAddArc(context1, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
//    CGContextClip(context1);
//    [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.width)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef CTX = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.width);
    CGContextAddEllipseInRect(CTX, rect);
    CGContextClip(CTX);
    [image drawInRect:rect];
    
    
//    CGFloat border = 1;
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    UIGraphicsBeginImageContext(imageRect.size);
//    [image drawInRect:CGRectMake(border,border,image.size.width-border*2,image.size.height-border*2)];
//    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.width));
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(ctx, 20, 20);
//    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
//    //画圆
//    CGContextAddArc(ctx, size.width/2+0.5, size.width/2+0.5, size.width/2-1, 0, M_PI  * 2, 0);
//    CGContextFillPath(ctx);
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    return image1;

}
@end
