//
//  SMALocatiuonManager.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMALocatiuonManager.h"

@interface SMALocatiuonManager ()
@property (nonatomic, strong) NSDate *hisDate;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) SMADatabase *datebase;
@property (nonatomic, assign) BOOL startSave;
@property (nonatomic, strong) NSTimer *locationTimer;
@end

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
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyyMMddHHmmss"];
    _datebase = [[SMADatabase alloc] init];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
    //    _manager.distanceFilter = 30; //控制定位服务更新频率。单位是“米”
    [_manager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
    [_manager requestWhenInUseAuthorization];
    _manager.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新kCLAuthorizationStatusAuthorizedAlways
    //        [CLLocationManager authorizationStatus] = kCLAuthorizationStatusAuthorizedAlways;
    _manager.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _manager.allowsBackgroundLocationUpdates = YES;
    }
}

- (void)startLocation{
    _startSave = YES;

    [_manager startUpdatingLocation];
}

- (void)stopLocation{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_manager stopUpdatingLocation];
    NSLog(@"FWGGHH====");
    _startSave = NO;
    
}

- (void)locationAction:(NSTimer *)timer{
    //    if (_locationTimer) {
    //        [_locationTimer invalidate];
    //        _locationTimer = nil;
    //    }
    NSLog(@"locationAction:");
    _startSave = YES;
    //         [_manager startUpdatingLocation];
}

#pragma mark - CL_locationTimerDelegate
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

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"didUpdateHeading");
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"locationManagerDidPauseLocationUpdates");
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return  YES;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"locationManager  %d %lu",_gatherLocation,(unsigned long)_runStepDic.count);
    if (!_gatherLocation || !_runStepDic  || !_allowLocation) {
        return;
    }
    _gatherLocation = NO;
    CLLocation * currLocation = [locations lastObject];
    NSDictionary *locationDic = [NSDictionary dictionaryWithObjectsAndKeys:[SMAAccountTool userInfo].userID,@"USERID",[_runStepDic objectForKey:@"DATE"],@"DATE",[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude],@"LONGITUDE",[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude],@"LATITUDE",[_runStepDic objectForKey:@"STEP"],@"STEP",[_runStepDic objectForKey:@"MODE"],@"MODE",@"0",@"WEB", nil];
    
    NSMutableArray *locationArr = [NSMutableArray arrayWithObject:locationDic];
    [_datebase insertLocatainDataArr:locationArr finish:^(id finish) {
        
    }];
    NSLog(@"---%@",[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude]);
    NSLog(@"+++%@",[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude]);
}

@end
