//
//  SMACalculate.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/10.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMACalculate : NSObject
//  十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;
//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;
//  厘米转英寸
+ (float)convertToInch:(float)cm;
//  英寸转厘米
+ (float)convertToCm:(float)feet;
//  千克转英磅
+ (float)convertToLbs:(float)kg;
//  英磅转千克
+ (float)convertToKg:(float)lbs;
//  千米转英里
+ (float)convertToMile:(float)km;
// 英里转千米
+ (float)convertToKm:(float)mile;
@end
