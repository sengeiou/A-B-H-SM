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
@end
