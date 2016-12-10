//
//  BLConnect.m
//  SMABLTEXT
//
//  Created by 有限公司 深圳市 on 15/12/28.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "BLConnect.h"

@interface BLConnect ()
@property (nonatomic, strong) NSTimer *reunionTimer;
@property (nonatomic, assign)BOOL firstInitilize;
@end

@implementation BLConnect
@synthesize peripherals;
/*********** 蓝牙单例公共对象构建  begin ***********/
// 用来保存唯一的单例对象
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
    SmaBleSend.delegate = self;
    self.firstInitilize = YES;
}

- (SMAUserInfo *)user{
    _user = [SMAAccountTool userInfo];//为了能获取个人资料最新资料
    return _user;
}

- (void)setScanName:(NSString *)scanName{
    _scanName = scanName;
    SMAUserInfo *user = [SMAAccountTool userInfo];
    user.scnaName = scanName;
    [SMAAccountTool saveUser:user];
}

- (BOOL)checkBLConnectState{
    if (self.user.watchUUID) {
        if (self.peripheral.state == CBPeripheralStateConnected) {
            if (_syncing) {
                [MBProgressHUD showError:SMALocalizedString(@"device_SP_syncWait")];
                return NO;
            }
            return YES;
        }
        else{
            [MBProgressHUD showError:SMALocalizedString(@"aler_conFirst")];
        }
    }
    else{
        [MBProgressHUD showError:SMALocalizedString(@"aler_bandDevice")];
    }
    return NO;
}

//查找蓝牙设备
- (void)scanBL:(int)time{
    if (self.mgr) {
        self.mgr = nil;
    }
    if (_firstInitilize) {
        self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.firstInitilize = NO;
    }
    else{
        self.mgr =  [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
    }
    [self stopSearch];
    if (time) {
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerFireScan) userInfo:nil repeats:YES];
    }
}

//开启设备重连机制
- (void)reunitonPeripheral:(BOOL)open{
    if (open) {
        if (self.user.watchUUID) {
            if (!self.peripheral && self.peripheral.state != CBPeripheralStateConnected) {
                [self scanBL:0];
            }
            if (!_reunionTimer) {
                _reunionTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(reunionTimer:) userInfo:nil repeats:YES];
            }
        }
    }
    else{
        [self stopSearch];
        NSLog(@"fwefwefwergr+++++22g====");
        if (_reunionTimer) {
            [_reunionTimer invalidate];
            _reunionTimer = nil;
        }
    }
}

- (void)reunionTimer:(id)sender{
    NSLog(@"fwefwefwergrg====");
    if (self.peripheral.state != CBPeripheralStateConnected) {
        NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"],[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
        NSLog(@"重连系统连接设备====%@  %@",SystemArr,self.user.watchUUID);
        if (SystemArr.count > 0) {
            [SystemArr enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.identifier.UUIDString isEqual:self.user.watchUUID]) {
                    NSLog(@"重连系统设备");
                    [self connectBl:obj];
                }
                else{
                    [self stopSearch];
                    [self scanBL:0];
                }
            }];
        }
        else{
            NSLog(@"外部搜索设备");
            [self stopSearch];
            [self scanBL:0];
        }
    }
}

//停止搜索
- (void)stopSearch{
    NSLog(@"停止搜索");
    [self.mgr stopScan];
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        //        [self.peripherals removeAllObjects];
        //        self.peripherals = nil;
        //        self.sortedArray = nil;
    }
}

//连接设备
- (void)connectBl:(CBPeripheral *)peripheral{
    if (peripheral) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        SmaBleSend.p = peripheral;
        [self.mgr connectPeripheral:self.peripheral options:nil];
    }
}

//断开链接
- (void)disconnectBl{
    if (self.peripheral) {
         [self.mgr cancelPeripheralConnection:self.peripheral];
    }
}

//设备更新状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"初始化中，请稍后……");
            break;
        case CBCentralManagerStateResetting:
            NSLog( @"设备不支持状态，过会请重试……");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"设备未授权状态，过会请重试……");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"设备未授权状态，过会请重试……");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"尚未打开蓝牙，请在设置中打开……");
            if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDisconnected:)]){
                [self.BLdelegate bleDisconnected:@"蓝牙关闭"];
            }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog( @"蓝牙已经成功开启，正在扫描蓝牙接口……");
            NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"],[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
            NSLog(@"扫描系统连接设备====%@",SystemArr);
            __block int blNum = 0;
            if (SystemArr.count > 0) {
                [SystemArr enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
                    blNum ++;
                    if ([obj.identifier.UUIDString isEqual:self.user.watchUUID]) {
                        NSLog(@"重连系统设备");
                        [self connectBl:obj];
                        blNum --;
                    }
                    else{
                        NSLog(@"搜索外部设备 = %d",blNum);
                        if (blNum == SystemArr.count) {
                            [self.peripherals removeAllObjects];
                            self.peripherals = nil;
                            [self.mgr scanForPeripheralsWithServices:nil options:nil];
                        }
                    }
                }];
            }
            else{
                NSLog(@"扫描外部搜索设备");
                [self.peripherals removeAllObjects];
                self.peripherals = nil;
                [self.mgr scanForPeripheralsWithServices:nil options:nil];
            }
        }
            break;
        default:
            break;
    }
}

//发现周边蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"搜索设备UUID：%@  记录UUID：%@  scanName: %@",peripheral.identifier.UUIDString,self.user.watchUUID,self.scanName);
    if (self.user.watchUUID) {
        if ([self.user.watchUUID isEqualToString:peripheral.identifier.UUIDString]) {
            [self connectBl:peripheral];
        }
    }
    else{
        if ([self.scanName isEqualToString:peripheral.name] && RSSI.intValue < 0) {
            NSLog(@"搜索出来的设备  %@  %d",peripheral,RSSI.intValue);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!peripherals) {
                    peripherals = [NSMutableArray array];
                }
                ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:RSSI.intValue UUID:peripheral.identifier.UUIDString];
                if (![peripherals containsObject:sensor])
                {
                    [peripherals addObject:sensor];
                }
                else
                {
                    sensor = [peripherals objectAtIndex:[peripherals indexOfObject:sensor]];
                    sensor.RSSI = RSSI.intValue;
                }
                _sortedArray = [peripherals sortedArrayUsingComparator:^NSComparisonResult(ScannedPeripheral *obj1, ScannedPeripheral *obj2){
                    if (obj1.RSSI > obj2.RSSI){
                        return NSOrderedAscending;
                    }
                    if (obj1.RSSI  < obj2.RSSI ){
                        return NSOrderedDescending;
                    }
                    return NSOrderedSame;
                }];
                NSLog(@"排序后的数组：%@",self.user);
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(reloadView)]) {
                    [self.BLdelegate reloadView];
                }
            });
        }
    }
}

//连接上蓝牙后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接上蓝牙后调用 %@",self.peripheral);
    [self stopSearch];
    [self.peripheral discoverServices:nil];
}

//发现设备服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"发现设备服务");
    for (int i=0; i < peripheral.services.count; i++) {
        CBService *s = [peripheral.services objectAtIndex:i];
        //        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [peripheral discoverCharacteristics:nil forService:s];
    }
    
}

//发现到特定蓝牙特征时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"发现到特定蓝牙特征时调用");
    if (self.characteristics) {
        [self.characteristics removeAllObjects];
        self.characteristics = nil;
    }
    self.characteristics = [NSMutableArray array];
    for (CBCharacteristic * characteristic in service.characteristics) {
        NSLog(@"%@===+%@",characteristic.UUID.UUIDString,self.user);
        [self.characteristics addObject:characteristic.UUID.UUIDString];
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            SmaBleSend.Write = characteristic;
            SMAUserInfo *user = [SMAAccountTool userInfo];
            if (user.watchUUID) {
                [SmaBleSend setHighSpeed:YES];
                [SmaBleSend LoginUserWithUserID:user.userID];
            }
            else{
                [SmaBleSend bindUserWithUserID:user.userID];
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:0];
                }
            }
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            /* 监听蓝牙返回的情况 */
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDidConnect)]){
        [self.BLdelegate bleDidConnect];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接问题 %@",error);
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDisconnected:)]){
        [self.BLdelegate bleDisconnected:error.localizedDescription];
    }
    
}

-(void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"fewfwef==%@",characteristic.value);
    [SmaBleSend handleResponseValue:characteristic];
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDidUpdateValue:)]) {
        [self.BLdelegate bleDidUpdateValue:characteristic];
    }
}

- (void)timerFireMethod{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(reloadView)]) {
        //        [self.BLdelegate reloadView];
    }
}

- (void)timerFireScan{
    NSLog(@"超时停止搜索");
    [self.mgr stopScan];
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    //   [self.peripherals removeAllObjects];
    //   self.peripherals = nil;
    //    _sortedArray = [peripherals sortedArrayUsingComparator:^NSComparisonResult(ScannedPeripheral *obj1, ScannedPeripheral *obj2){
    //        if (obj1.RSSI > obj2.RSSI){
    //            return NSOrderedAscending;
    //        }
    //        if (obj1.RSSI  < obj2.RSSI ){
    //            return NSOrderedDescending;
    //        }
    //        return NSOrderedSame;
    //    }];
    //    NSLog(@"排序后的数组：%@",_sortedArray);
    //
        if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(searchTimeOut)]) {
            [self.BLdelegate searchTimeOut];
        }
    //    [self.mgr scanForPeripheralsWithServices:nil options:nil];
    //    [self.peripherals removeAllObjects];
}

#pragma mark ********SamCoreBlueToolDelegate*******
- (void)bleDataParsingWithMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)array Checkout:(BOOL)check{
    NSLog(@"mac---%d",array.count);
    SMADatabase *dal = [[SMADatabase alloc] init];
    switch (mode) {
        case BAND:
            if([array[0] intValue])//绑定成功
            {
                SMAUserInfo *user = [SMAAccountTool userInfo];
                user.watchUUID = self.peripheral.identifier.UUIDString;
                [SMAAccountTool saveUser:user];
                [SmaBleSend LoginUserWithUserID:self.user.userID];
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:1];
                }
            }
            else{
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:2];
                }
            }
            break;
        case LOGIN:
            if([array[0] intValue])//登录成功，
            {
                _syncing = NO;
                [self firstSet];
            }
            else{
                
            }
            break;
        case MAC:
            
            break;
        case ELECTRIC:
            break;
        case VERSION:
        {
            SMAUserInfo *user = [SMAAccountTool userInfo];
            user.watchVersion = [array firstObject];
            [SMAAccountTool saveUser:user];
        }
            break;
        case CUFFSPORTDATA:
            /****
             静坐开始 10
             步行开始 11
             跑步开始 12
             运动模式开始 20
             运动中数据   21
             运动模式结束 2F
             *****/
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
//                SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
//                [webTool acloudSetScore:[[[array lastObject] objectForKey:@"STEP"] intValue]];
                [dal insertSportDataArr: [self clearUpSportData:array] finish:^(id finish) {
//
                }];
            }
            [SmaBleSend requestCuffHRData];
            break;
        case CUFFSLEEPDATA:
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
                [dal insertSleepDataArr: [self clearUpSleepData:array] finish:^(id finish) {
                    
                }];
            }
            self.syncing = NO;
            break;
        case CUFFHEARTRATE:
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [dal insertHRDataArr:[self clearUpHRData:array] finish:^(id finish) {
                        //上传运动步数到排行榜
                        SMADatabase *dal = [[SMADatabase alloc] init];
                        NSMutableArray *spArr = [dal readSportDataWithDate:[NSDate date].yyyyMMddNoLineWithDate toDate:[NSDate date].yyyyMMddNoLineWithDate];
                        NSLog(@"spArr==%@",[spArr firstObject]);
                        SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
                        [webTool acloudSetScore:[[[spArr firstObject] objectForKey:@"STEP"] intValue]];
                        [webTool acloudSyncAllDataWithAccount:[SMAAccountTool userInfo].userID callBack:^(id finish) {
                        
                        }];
                    }];
                });
            }
            [SmaBleSend requestCuffSleepData];
            break;
        case RUNMODE:
            NSLog(@"riunfjwfiow===%@",array);
            break;
        default:
            break;
    }
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bledidDisposeMode:dataArr:)]){
        [self.BLdelegate bledidDisposeMode:mode dataArr:array];
    }
}
- (void)sendIdentifier:(int)identifier{
    NSLog(@"identifier  %d %ld",identifier,SmaBleSend.serialNum);
    _sendIdentifier = identifier;
}

- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(sendBLETimeOutWithMode:)]){
        [self.BLdelegate sendBLETimeOutWithMode:mode];
    }
}

- (void)updateProgress:(float)pregress{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleUpdateProgress:)]){
        [self.BLdelegate bleUpdateProgress:pregress];
    }
}
- (void)updateProgressEnd:(BOOL)success{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleUpdateProgressEnd:)]){
        [self.BLdelegate bleUpdateProgressEnd:success];
    }
}

- (void)firstSet{
    [SmaBleSend setSystemTime];
    [SmaBleSend setDefendLose:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]];
    [SmaBleSend setSleepAIDS:[SMADefaultinfos getIntValueforKey:SLEEPMONSET]];
    [SmaBleSend setphonespark:[SMADefaultinfos getIntValueforKey:CALLSET]];
    [SmaBleSend setSmspark:[SMADefaultinfos getIntValueforKey:SMSSET]];
    [SmaBleSend setStepNumber:self.user.userGoal.intValue];
    [SmaBleSend setUserMnerberInfoWithHeight:self.user.userHeight.intValue weight:self.user.userWeigh.intValue sex:self.user.userSex.intValue age:self.user.userAge.intValue];
    SmaNoDisInfo *disInfo = [[SmaNoDisInfo alloc] init];
    disInfo.isOpen = [NSString stringWithFormat:@"%d",[[SMADefaultinfos getValueforKey:NODISTRUBSET] intValue]];
    disInfo.beginTime1 = @"0";
    disInfo.endTime1 = @"1439";
    disInfo.isOpen1 = @"1";
    [SmaBleSend setNoDisInfo:disInfo];
    
    SmaHRHisInfo *HRInfo = [SMAAccountTool HRHisInfo];
    if (!HRInfo) {
        HRInfo = [[SmaHRHisInfo alloc] init];
        HRInfo.isopen0 = [NSString stringWithFormat:@"%d",1];
        HRInfo.dayFlags=@"127";//每天
        HRInfo.isopen=[NSString stringWithFormat:@"%d",1];
        HRInfo.tagname=@"30";
        HRInfo.beginhour0 = @"0";
        HRInfo.endhour0 = @"23";
        [SMAAccountTool saveHRHis:HRInfo];
    }
    [SmaBleSend setHRWithHR:HRInfo];
    
    SmaSeatInfo *setInfo = [SMAAccountTool seatInfo];
    if (setInfo) {
         [SmaBleSend seatLongTimeInfoV2:setInfo];
    }

    [SmaBleSend setBacklight:[SMADefaultinfos getIntValueforKey:BACKLIGHTSET]];
    SmaVibrationInfo *vibration = [[SmaVibrationInfo alloc] init];
    vibration.type = @"5";
    vibration.freq = [NSString stringWithFormat:@"%d",[SMADefaultinfos getIntValueforKey:VIBRATIONSET]];
    [SmaBleSend setVibration:vibration];
    
    if ([self.scanName isEqualToString:@"SM07"]) {
        [SmaBleSend setVertical:[SMADefaultinfos getIntValueforKey:SCREENSET]];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
        if (![preferredLang isEqualToString:@"zh"]) {
            [SmaBleSend setLanguage:YES];
        }
        else{
            [SmaBleSend setLanguage:NO];
        }
    }
    
    SMADatabase *smaDal = [[SMADatabase alloc] init];
    NSMutableArray *alarmArr = [smaDal selectClockList];
    if (alarmArr.count > 0) {
        [SmaBleSend setClockInfoV2:alarmArr];
    }
   
    [SmaBleSend getElectric];
    [SmaBleSend getBLVersion];
    [SmaBleSend getBLmac];
}

static double spInterval;
static bool isSpMode;
- (NSMutableArray *)clearUpSportData:(NSMutableArray *)dataArr{
    NSMutableArray *sp_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *spDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [spDic setObject:SmaBleMgr.peripheral.name forKey:@"INDEX"];
        [spDic setObject:@"0" forKey:@"WEB"];
        [spDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        [sp_arr addObject:spDic];
        //        spInterval = nowInterval;
        if (i == dataArr.count - 1) {
            spInterval = 0;
        }
        
    }
    return sp_arr;
}

- (NSMutableArray *)clearUpSleepData:(NSMutableArray *)dataArr{
    NSMutableArray *sl_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *slDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [slDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] forKey:@"INDEX"];
        [slDic setObject:@"0" forKey:@"WEB"];
        [slDic setObject:@"1" forKey:@"WEAR"];
        [slDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        [sl_arr addObject:slDic];
    }
    return sl_arr;
}

static double hrInterval;
static bool ishrMode;
- (NSMutableArray *)clearUpHRData:(NSMutableArray *)dataArr{
    NSMutableArray *hr_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *hrDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [hrDic setObject:SmaBleMgr.peripheral.name forKey:@"INDEX"];
        [hrDic setObject:@"0" forKey:@"WEB"];
        [hrDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        double nowInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:[hrDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        [hr_arr addObject:hrDic];
        hrInterval = nowInterval;
        if (i == dataArr.count - 1) {
            hrInterval = 0;
        }
        
    }
    return hr_arr;
}
@end
