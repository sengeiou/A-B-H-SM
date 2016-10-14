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
@end
