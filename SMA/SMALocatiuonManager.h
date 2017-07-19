//
//  SMALocatiuonManager.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SMALocatiuonManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSDictionary *firstRunDic;//初始定位数据（用于日后删除相关定位数据）
@property (nonatomic, strong) NSDictionary *runStepDic;
@property (nonatomic, assign) BOOL gatherLocation;
@property (nonatomic, assign) BOOL allowLocation;//允许定位（用于日后判断蓝牙断开后重连将不再获取定位数据）
+ (instancetype)sharedCoreBlueTool;
- (void)startLocation;

- (void)stopLocation;
@end
