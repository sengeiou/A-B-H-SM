//
//  SMAWebDataHandleInfo.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/19.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACObject.h"
@interface SMAWebDataHandleInfo : NSObject
+ (ACObject *)heartRateSetObject;
+ (ACObject *)sedentarinessSetObject;
+ (void)saveWebHeartRateSetObject:(ACObject *)object;
+ (void)saveWebSedentarinessSetObject:(ACObject *)object;
+ (void)updateSLData:(NSMutableArray *)slList finish:(void (^)(id finish)) callBack;
+ (void)updateSPData:(NSMutableArray *)spList finish:(void (^)(id finish)) callBack;
+ (void)updateHRData:(NSMutableArray *)hrList finish:(void (^)(id finish)) callBack;
+ (void)updateALData:(NSMutableArray *)alList finish:(void (^)(id finish)) callBack;
@end
