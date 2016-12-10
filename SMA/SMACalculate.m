//
//  SMACalculate.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/10.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMACalculate.h"

@implementation SMACalculate
//  十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    NSString * prepare = @"";
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    NSString * result = @"";
    for (int i = (int)prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)],i==0?@"":@","];
    }
    NSMutableArray *resultArr = [[result componentsSeparatedByString:@","] mutableCopy];
    NSInteger count = 7 - resultArr.count;
    if (resultArr.count < 7) {
        for (int j = 0; j < count; j ++) {
            [resultArr insertObject:@"0" atIndex:0];
        }
        result = [resultArr componentsJoinedByString:@","];
    }
    return result;
}

//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    return result;
}

+ (float)convertToInch:(float)cm {
    return cm*0.39370078740157;
}

+ (float)convertToCm:(float)feet {
    return feet*2.54;
}

+ (float)convertToLbs:(float)kg {
    return kg*2.2046226;
}

+ (float)convertToKg:(float)lbs {
    return lbs*0.4535924;
}

+ (float)convertToMile:(float)km {
    return  km / 1.609;
}

+ (float)convertToKm:(float)mile {
    return mile*1.609344;
}

+ (NSString *)convertToFt:(int)feet{
    return [NSString stringWithFormat:@"%@'%d\"",feet/12 > 0 ? [NSString stringWithFormat:@"%d",feet/12]:@"",feet%12  ];
}

//计算距离
+ (float)countKMWithHeigh:(float)hight step:(int) step{
    return 45 * hight * step /10000000;
}

//计算卡路里
+ (float)countCalWithSex:(NSString *)sex userWeight:(float)weight step:(int)step{
    if ([sex isEqualToString:@"1"]) {
        return (55*weight*step)/100000;
    }
    else{
        return (46*weight*step)/100000;
    }
}

//整理07运动，保证四舍不入
+ (NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness: NO  raiseOnOverflow: NO  raiseOnUnderflow: NO  raiseOnDivideByZero: NO ];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return  [NSString stringWithFormat: @"%@" ,roundedOunces];
}

+ (CGFloat)heightForLableWithText:(NSString *)text Font:(UIFont*)font AndlableWidth:(CGFloat)lableWidth
{
    CGSize textSize = CGSizeMake(lableWidth, CGFLOAT_MAX);
    //计算高度
    CGSize sizeWithFont = [text boundingRectWithSize:textSize options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(sizeWithFont.height);
    
}

@end
