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

+ (UIImage *) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType size:(CGSize )size{
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

+ (UIImage *) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType radius:(CGFloat)radius size:(CGSize )size{
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
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef CTX = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.width);
    CGContextAddEllipseInRect(CTX, rect);
    CGContextClip(CTX);
    [image drawInRect:rect];
    
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    return image1;

}

/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)zipImageWithImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = 100*1024;
    CGFloat compression = 0.9f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.7;
        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newSize:CGSizeMake(image.size.width*compression, image.size.height*compression)], compression);
    }
    return compressedData;
}

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newSize:(CGSize )newImageSize
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageSize.width;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

//等比例压缩图片
+ (UIImage *)imageUserToCompressForSizeImage:(UIImage *)image newSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize originalSize = image.size;//获取原始图片size
    
    CGFloat originalWidth = originalSize.width;//宽
    
    CGFloat originalHeight = originalSize.height;//高
    
    if ((originalWidth <= size.width) && (originalHeight <= size.height)) {
        
        newImage = image;//宽和高同时小于要压缩的尺寸时返回原尺寸
    }
    
    else{
        
        //新图片的宽和高
        
        CGFloat scale = (float)size.width/originalWidth < (float)size.height/originalHeight ? (float)size.width/originalWidth : (float)size.height/originalHeight;
        
        CGSize newImageSize = CGSizeMake(originalWidth*scale , originalHeight*scale );
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImageSize.width , newImageSize.height ), NO, 0);
        
        [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if (newImage == nil) {
            
            NSLog(@"image ");
            
        }
        
        UIGraphicsEndImageContext();
        
    }
    
    return newImage;
    
}
@end
