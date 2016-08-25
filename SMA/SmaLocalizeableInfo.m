//
//  SmaLocalizeableInfo.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SmaLocalizeableInfo.h"

@implementation SmaLocalizeableInfo
#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])

+(NSString *)localizedString:(NSString *)translation_key {
    NSString *s = NSLocalizedString(translation_key, nil);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    if (![preferredLang isEqualToString:@"zh"] && ![preferredLang isEqualToString:@"fr"]&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"es"]&& ![preferredLang isEqualToString:@"it"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
    return s;
}

@end
