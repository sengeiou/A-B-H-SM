

//
//  SmaCommonStudio.m
//  SmaLife
//
//  Created by chenkq on 15/4/6.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaCommonStudio.h"
//#import <ShareSDK/ShareSDK.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WXApi.h"
//#import "WeiboSDK.h"

@implementation SmaCommonStudio

#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])

+(NSString *)DPLocalizedString:(NSString *)translation_key {
    NSString *s = NSLocalizedString(translation_key, nil);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
   if (![preferredLang isEqualToString:@"zh"]) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
    return s;
}



@end
