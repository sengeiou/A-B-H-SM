//
//  SMAthirdPartyManager.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/25.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "AFNetworking.h"
@interface SMAthirdPartyManager : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate,WXApiDelegate>
+(instancetype)sharedManager;
@end
