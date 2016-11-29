//
//  SMALocatiuonManager.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMALocatiuonManager.h"

@implementation SMALocatiuonManager
static id _instace;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedCoreBlueTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
        [_instace initilize];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

-(void)initilize
{
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
    _manager.distanceFilter = 30; //控制定位服务更新频率。单位是“米”
    [_manager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
    [_manager requestWhenInUseAuthorization];
    _manager.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新kCLAuthorizationStatusAuthorizedAlways
    //    [CLLocationManager authorizationStatus] = kCLAuthorizationStatusAuthorizedAlways;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _manager.allowsBackgroundLocationUpdates = YES;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
        case kCLErrorLocationUnknown:
            NSLog(@"The location manager was unable to obtain a location value right now.");
            break;
        case kCLErrorDenied:
            NSLog(@"Access to the location service was denied by the user.");
            break;
        case kCLErrorNetwork:
            NSLog(@"The network was unavailable or a network error occurred.");
            break;
        default:
            NSLog(@"未定义错误");
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"oldLocation.coordinate.timestamp:%@", oldLocation.timestamp);
    NSLog(@"oldLocation.coordinate.longitude:%f", oldLocation.coordinate.longitude);
    NSLog(@"oldLocation.coordinate.latitude:%f", oldLocation.coordinate.latitude);
    
    NSLog(@"newLocation.coordinate.timestamp:%@", newLocation.timestamp);
    NSLog(@"newLocation.coordinate.longitude:%f", newLocation.coordinate.longitude);
    NSLog(@"newLocation.coordinate.latitude:%f", newLocation.coordinate.latitude);
    
    NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    NSLog(@"%lf", interval);
    
}
@end
