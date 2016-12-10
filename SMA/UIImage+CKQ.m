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

+ (UIImage*)image:(UIImage*)image  fortargetSize: (CGSize)targetSize{
    UIImage*sourceImage = image;
    CGSize imageSize = sourceImage.size;//图片的size
    CGFloat imageWidth = imageSize.width;//图片宽度
    CGFloat imageHeight = imageSize.height;//图片高度
    NSInteger judge;//声明一个判断属性
    //判断是否需要调整尺寸(这个地方的判断标准又个人决定,在此我是判断高大于宽),因为图片是800*480,所以也可以变成480*800
    if( ( imageHeight - imageWidth)>0) {
        //在这里我将目标尺寸修改成480*800
        CGFloat tempW = targetSize.width;
        CGFloat tempH = targetSize.height;
        targetSize.height= tempW;
        targetSize.width= tempH;
    }
    CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸
    CGFloat scaleFactor ;//先声明拉伸的系数
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
    //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image
    if( imageHeight < targetHeight && imageWidth < targetWidth) {
        return image;
    }
    if ( CGSizeEqualToSize(imageSize, targetSize ) ==NO )
    {
        CGFloat widthFactor = targetWidth / imageWidth;  //这里是目标宽度除以图片宽度
        CGFloat heightFactor = targetHeight / imageHeight; //这里是目标高度除以图片高度
        //分四种情况,
        //第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小
        if(widthFactor <1&& heightFactor<1){
            //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )
            if(widthFactor > heightFactor){
                judge =1;//右部分空白
                scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)
            }
            else
            {
                judge =2;//下部分空白
                scaleFactor = widthFactor;
            }
        }
        else if(widthFactor >1&& heightFactor <1){
            //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
            judge =3;//下部分空白
            //采用高度拉伸比例
            scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
        }else if(heightFactor >1&& widthFactor <1){
            //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
            judge =4;//下边空白
            //采用高度拉伸比例
            scaleFactor = imageHeight / targetWidth;
            
        }else{
            //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).
        }
        scaledWidth= imageWidth * scaleFactor;
        scaledHeight = imageHeight * scaleFactor;
    }
    if(judge ==1){
        //右部分空白
        targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
    }else if(judge ==2){
        //下部分空白
        targetHeight = scaledHeight;
    }else if(judge ==3){
        //第三种,高度不够比例,宽度缩小一点点
        targetWidth  = scaledWidth;
    }else{
        //第三种,高度不够比例,宽度缩小一点点
        targetHeight= scaledHeight;
    }
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
    thumbnailRect.origin= thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height= scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    return newImage;
}
+(UIImage *)imageCompressed:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
        NSAssert(!newImage,@"图片压缩失败");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
