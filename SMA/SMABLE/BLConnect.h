//
//  BLConnect.h
//  SMABLTEXT
//
//  Created by 有限公司 深圳市 on 15/12/28.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScannedPeripheral.h"
#import "SmaBLE.h"
@protocol BLConnectDelegate <NSObject>
@optional
- (void)reloadView;
- (void)searchTimeOut;
- (void)bleDidConnect;
- (void)bleDisconnected:(NSString *)error;
- (void)bleBindState:(int)state;//0：绑定中；1：绑定成功；2：绑定失败
- (void)bleLoginComplete;
- (void)bleDidUpdateValue:(CBCharacteristic *)characteristic;
- (void)blediDWriteValueForCharacteristicError:(NSError *)error;
- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data;
- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode;
//更新进度（表盘）
- (void)bleUpdateProgress:(float)pregress;
- (void)bleUpdateProgressEnd:(BOOL)success;
@end


@interface BLConnect : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate,SmaCoreBlueToolDelegate>
/* 中心管理者*/
@property (nonatomic, strong) CBCentralManager *mgr;
/*连接的那个蓝牙设备*/
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) NSMutableArray *characteristics;
@property (strong, nonatomic) NSArray *sortedArray;
@property (strong, nonatomic) NSString *scanName;
@property (strong, nonatomic) NSTimer *reloadTimer;
@property (strong, nonatomic) NSTimer *scanTimer;
@property (strong, nonatomic) SMAUserInfo *user;
@property (assign,readonly,nonatomic) int sendIdentifier;
@property (weak,   nonatomic) id<BLConnectDelegate> BLdelegate;
@property (assign, nonatomic) BOOL syncing;
+ (instancetype)sharedCoreBlueTool;
//查找蓝牙设备
- (void)scanBL:(int)time;
//开启设备重连机制
- (void)reunitonPeripheral:(BOOL)open;
//停止搜索
- (void)stopSearch;
//连接设备
- (void)connectBl:(CBPeripheral *)peripheral;
//断开链接
- (void)disconnectBl;
//检查连接是否正常
- (BOOL)checkBLConnectState;
@end
