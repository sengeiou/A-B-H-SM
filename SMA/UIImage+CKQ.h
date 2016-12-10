//
//  UIImage+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    topToBottom = 0,//从上到下
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIImage (CKQ)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;
//国际化
+ (UIImage *)imageLocalWithName:(NSString *)name;
/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize imageName:(NSString *)imageName;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType size:(CGSize )size;
+ (UIImage *) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType radius:(CGFloat)radius size:(CGSize )size;
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;
+ (NSData *)zipImageWithImage:(UIImage *)imag;
+ (UIImage *)imageUserToCompressForSizeImage:(UIImage *)image newSize:(CGSize)size;//等比例压缩图片
+ (UIImage *)image:(UIImage*)image fortargetSize: (CGSize)targetSize;
+ (UIImage *)imageCompressed:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
