//
//  SmaLocalizeableInfo.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaLocalizeableInfo : NSObject
+(NSString *)localizedString:(NSString *)translation_key;
+ (NSString *)localizedStringDic:(NSString *)translation_key comment:(NSString *)comment;
@end
