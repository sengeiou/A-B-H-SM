//
//  SmaColor.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 16/7/26.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SmaColor : NSObject
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
