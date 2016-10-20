

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SmaSeatInfo.h"
#import "SmaHRHisInfo.h"
#import "SmaAlarmInfo.h"
#import "SmaBusinessTool.h"
#import "SmaNoDisInfo.h"
#import "SmaVibrationInfo.h"
typedef enum {
    BAND =0,      //绑定信息
    LOGIN ,       //登录
    SPORTDATA,    //运动数据
    SLEEPDATA,    //睡眠数据
    SLEEPSETDATA, //睡眠设定数据
    SETSLEEPAIDS, //设置睡眠辅助监测（07）
    ALARMCLOCK,   //闹钟列表
    SYSTEMTIME,   //系统时间
    ELECTRIC,     //电量
    VERSION,      //系统版本
    OTA,          //是否进入OTA
    BOTTONUP,     //上按键
    BOTTONDOWN,   //下按键
    MAC,          //MAC返回
    WATHEARTDATA, //手表心率返回
    CUFFSPORTDATA,  //07运动数据
    CUFFHEARTRATE,  //心率数据(05、07)
    CUFFSLEEPDATA,  //07睡眠数据
    CUFFSWITCHS,     //获取设备表盘（10-A）
    XMODEM          //进入XODEM模式（10-A）
}SMA_INFO_MODE;
/*
 @param BAND            反馈绑定信息，反馈数组内若为1，绑定成功，若为0，绑定失败
 @param LOGIN           反馈登录信息，反馈数组内若为1，登录成功，若为0，登录失败
 @param SPORTDATA       反馈运动数据信息，反馈数组参数
                        sport_date：运动日期
                        sport_steps：运动步数，sport_cal：消耗卡路里（单位：cal/10000）
                        sport_dist：运动距离（单位：m）
                        sport_time：运动时间（单位：m/15）
                        sport_actTime：运动时间
 @param SLEEPDATA       反馈睡眠数据，反馈数组参数
                        sleep_date：睡眠日期
                        sleep_timeStamp：睡眠反馈时间（从Date 0点开始的分钟数。此值可能会大于 1440(24小时*60分钟=1440分钟),如果大 于1440,则表示为隔天的时间）
                        sleep_mode：睡眠类型（1：深睡，2：浅睡，3：未进入睡眠）详细描述：1-3深睡到未睡---深睡时间；2-1清醒到深睡---浅睡时间；2-3清醒到未睡---浅睡时间；3-2未睡到清醒---清醒时间
 @param SLEEPSETDATA    反馈睡眠设定数据，反馈数组参数
                        sleep_date：睡眠日期
                        sleep_timeStamp：睡眠设定反馈时间（从Date 0点开始的分钟数。此值可能会大于 1440(24小时*60分钟=1440分钟),如果大 于1440,则表示为隔天的时间）
                        sleep_mode：睡眠设定类型（1：进入睡眠状态，2：退出睡眠状态）
 @param SETSLEEPAIDS    设置是否开启睡眠辅助监测功能，用于更准确判断用户是否戴表睡觉
 @param ALARMCLOCK      反馈闹钟数据，反馈数组参数，闹钟个数最多为8个，数组对象为SmaAlarmInfo
 @param SYSTEMTIME      反馈系统时间，反馈数组日期格式为：yyyyMMddHHmmss
 @param ELECTRIC        反馈设备电池电量，反馈数组为电量百分比
 @param VERSION         反馈设备系统版本
 @param OTA             反馈进入OTA状态信息，反馈数组若为1，进入成功，
                        当数组同时反馈@[0,PowerIsNormal]，进入OTA失败，无错误信息，
                        若反馈@[0,PowerIsTooLow]，进入OTA失败，电量过低
 @param BOTTONUP        反馈设备按键，反馈数组为UP代表点击上键
 @param BOTTONDOWN      反馈设备按键，反馈数组为DOWN代表点击下键
 @param MAC             反馈设备MAC地址，反馈数组为--:--:--:--:--:--,若出现04:03:00:00:00:00,为错误地址，建议重启设备
 @param WATHEARTDATA    反馈05手表最后一次监测的心率数据
 @param CUFFSPORTDATA   反馈07手环运动数据，数据一次最多返回20组，若仍有运动数据，需要重新请求
                        DATE：运动时间
                        STEP：运动步数
 @param CUFFHEARTRATE   反馈07手环心率数据，数据一次最多返回20组，若仍有心率数据，需要重新请求
                        DATE：心率监测时间
                        HEART：监测到的心率数值
 @param CUFFSLEEPDATA   反馈07手环睡眠数据，数据一次最多返回20组，若仍有睡眠数据，需要重新请求
                        DATE：睡眠监测时间
                        MODE：睡眠类型（若返回17则为进入睡眠时刻数据，34则为退出睡眠时刻数据，1：深睡，2：浅睡，3：未进入睡眠）
                        SOFTLY：睡眠时轻动响应次数
                        STRONG：睡眠时剧动响应次数
 
 */

@protocol SamCoreBlueToolDelegate <NSObject>

@optional
/*发送指令序号标识，用于识别应答数据指令序号
 @param identifier 接收到应答数据反馈指令序号标识
 @discussion       当向设备发送一条指令（如设置系统时间指令：setSystemTime），当应用程序调用:handleResponseValue:后回调
 */
- (void)sendIdentifier:(int)identifier;

/*数据反馈处理
 @param mode     数据属于的类型枚举：SMA_INFO_MODE
 @param array    数据处理数组，组合类型查看DEMO
 @discussion     将设备反馈数据进行处理，并通过反馈数据类型：mode来区分属于哪类数据（如：睡眠数据，运动数据），当应用程序调用:handleResponseValue:后回调
 */
- (void)bleDataParsingWithMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)array Checkout:(BOOL)check;
/*数据发送超时
 @param mode     数据属于的类型枚举：SMA_INFO_MODE
 */
- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode;
//更新进度（表盘）
- (void)updateProgress:(NSString *)pregress;
- (void)updateProgressEnd:(BOOL)success;
@end

@interface SmaBLE : NSObject
@property (nonatomic, assign, readonly) NSInteger serialNum;//发送指令序号标识
@property (nonatomic,strong)  CBPeripheral*p;//连接的设备
@property (nonatomic,strong)  CBCharacteristic*Write;//连接的设备的写特征
@property (nonatomic, weak) id<SamCoreBlueToolDelegate> delegate;
+ (instancetype)sharedCoreBlue; //创建对象

/*处理设备反馈数据
 @param characteristic 设备更新数据特征
 @discussion           当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:后调用
 */
- (void)handleResponseValue:(CBCharacteristic *)characteristic;

/*绑定手表
  @param userid 目前支持纯数字，如电话号码
  @discussion   用于向设备注册ID为userid的用户，以达到数据正常传输（运动，睡眠数据）
 */
-(void)bindUserWithUserID:(NSString *)userid;

/*解除绑定
  @discussion   解除用户绑定，清除设备内部设定用户数据
 */
-(void)relieveWatchBound;

/*登录命令
  @param userid 目前支持纯数字，如电话号码
  @discussion   登录用户ID必须为绑定设置的用户ID，否则导致数据无法同步（运动，睡眠数据）
*/
-(void)LoginUserWithUserID:(NSString *)userid;

/*退出登录
 @discussion   退出用户登录，可导致设备短时间断开连接
*/
-(void)logOut;

/*设置用户信息
  @param he    身高（cm）
  @param we    体重 (kg)
  @param sex   性别 (0:女，1：男)
  @param age   年龄 （0~127）
  @discussion  向设备设置用户身高，体重，性别和年龄信息
 */
-(void)setUserMnerberInfoWithHeight:(int)he weight:(int)we sex:(int)sex age:(int)age;

/*设置系统时间
 @discussion  向设备设置手机当前时间
 */
-(void)setSystemTime;

/*设置防丢
   @param bol   YES:开启；NO:关闭
 */
-(void)setDefendLose:(BOOL)bol;

/*手机来电
  @param bol YES:开启；NO:关闭
 */
-(void)setphonespark:(BOOL)bol;

/*短信
  @param bol YES:开启；NO:关闭
 */
-(void)setSmspark:(BOOL)bol;

/*设置记步目标
  @param count 步数
 */
-(void)setStepNumber:(int)count;

/*勿扰设置(05)
  @param bol YES:开启；NO:关闭
 */
- (void)setNoDisturb:(BOOL)bol;

/*背光设置(05)
 @param time 背光时间（1~10s）
 */
- (void)setBacklight:(int)time;

/*震动设置（05）
 @param freq 震动次数（1~10次）
 */
- (void)setVibrationFrequency:(int)freq;

/*震动设置（07）
 @param info 详见SmaVibrationInfo类
 */
- (void)setVibration:(SmaVibrationInfo *)info;

/*设置久坐
   @param week  传入类型如 @"0~127";
   @param begin 开始时间
   @param end   结束时间
   @param seat  久坐时间  如设置5分钟，将在以0分钟开始，每5分钟会检查一次久坐情况并不是从设置久坐后5分钟检查久坐情况
 */
-(void)seatLongTimeWithWeek:(NSString *)week beginTime:(int)begin endTime:(int)end seatTime:(int)seat;

/*关闭久坐
  */
-(void)closeLongTimeInfo;

/*  久坐提醒V2 */
-(void)seatLongTimeInfoV2:(SmaSeatInfo *)info;

/*设置闹钟
  @param smaACs 闹钟数组，对象类型为SmaAlarmInfo
  @discussion   闹钟各属性请参考SmaAlarmInfo描述,闹钟个数最多为八个
 */
-(void)setCalarmClockInfo:(NSMutableArray *)smaACs;

/*设置手环闹钟V2
 @param smaACs 闹钟数组，对象类型为SmaAlarmInfo
 @discussion   闹钟各属性请参考SmaAlarmInfo描述,闹钟个数最多为八个
 */
-(void)setClockInfoV2:(NSMutableArray *)smaACs;

/*数据同步
  @param bol YES:开启；NO:关闭
  @discussion   仅适用于02、04、05设备
 */
-(void)Syncdata:(BOOL)bol;

/*设置OTA
 @discussion 进入OTA升级指令，用于升级设备软件，请参考IOS-nRF-Toolbox-master.zip，技术支持网站https://developer.nordicsemi.com/nRF51_SDK/nRF51_SDK_v8.x.x/doc/8.0.0/s110/html/a00103.html
  */
-(void)setOTAstate;

/*设置APP数据
  @param cal    卡路里（cal）
  @param metre  路程（m）
  @param step   步数
  @discussion   向设备设置卡路里，路程，步数数据（仅适用于02，04，05设备）
  */
- (void)setAppSportDataWithcal:(float)cal distance:(int)metre stepNnumber:(int)step;

/*设置手环首页中英文（星期）
  @param open    是否开启，YES为英文，NO为中文
 */
- (void)setLanguage:(BOOL)open;

/*设置心率（07）
  @parmar info  心率设置对像（请参考该对象参数）
 */
- (void)setHRWithHR:(SmaHRHisInfo *)info;

/*设置抬手亮（07）
  @parmar open  YES开启，NO关闭
 */
 - (void)setLiftBright:(BOOL)open;

/*竖屏设置（07）
 @parmar open   YES开启，NO关闭
 */
- (void)setVertical:(BOOL)open;

/* 设置勿扰时间（07）
 @parmar info  勿扰设置对像（各参数请参考该对象参数）
 */
- (void)setNoDisInfo:(SmaNoDisInfo *)info;

/*设置睡眠辅助监测
 @parmar open  YES开启，NO关闭
 */
- (void)setSleepAIDS:(BOOL)open;

/*BEACON广播设置 
  @parmar interval(0~225min) time(0~225s)
 */
- (void)setRadioInterval:(int)interval Continuous:(int)time;

/*12/24小时制设置
 @parmar hourly  YES 12小时制，NO 24小时制
 */
- (void)setHourly:(BOOL) hourly;

/*高速模式
 @parmar open  YES开启，NO关闭
 */
- (void)setHighSpeed:(BOOL)open;

/*请求07运动数据
 @discussion 每次数据请求最多只能反馈20组数据，余下数据必须重新发送请求指令，直到获取到的数据少于20组
 */
-(void)requestCuffSportData;

/*请求07睡眠数据
 @discussion 每次数据请求最多只能反馈20组数据，余下数据必须重新发送请求指令，直到获取到的数据少于20组
 */
- (void)requestCuffSleepData;

/*请求07心率数据
 @discussion 每次数据请求最多只能反馈20组数据，余下数据必须重新发送请求指令，直到获取到的数据少于20组
 */
- (void)requestCuffHRData;

/*请求05最后一次检测到的心率
 @discussion 检测出来的心率为05手表最后一次监测到的心率值
 */
- (void)requestLastHRData;

/*复位手表
  @discussion 重启手表
 */
- (void)BLrestoration;

/*测试模式
 @param on YES:进入，NO：退出
 @discussion  可测试LED和马达工作情况（仅用于02、04）
 */
- (void)enterTextMode:(BOOL)on;

/*点亮LED
 @discussion  必须进入测试模式
 */
- (void)lightLED;

/*震动马达
 @discussion  必须进入测试模式
 */
- (void)vibrationMotor;

/*获取闹钟列表
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
  */
-(void)getCalarmClockList;

/*获取07闹钟列表
 @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
 */
-(void)getCuffCalarmClockList;


/*请求运动数据
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
  */
-(void)requestExerciseData;

/*获取手表时间
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
  */
- (void)getWatchDate;

/*获取电量
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
  */
-(void)getElectric;

/*获取蓝牙硬件版本
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
  */
- (void)getBLVersion;

/*获取MAC地址
  @discussion 当应用程序触发:peripheral:didUpdateValueForCharacteristic:error:之后后调用:handleResponseValue:触发bleDataParsingWithMode: dataArr
 */
- (void)getBLmac;

/*获取表盘编号（10-A）
 */
- (void)getSwitchNumber;

/*进入XOMDEM模式（10-A）
 */
- (void)enterXmodem;

/*计算路程
 @parmar height 用户身高（cm）
 @parmar step   步数
 */
- (float )countDisWithHeight:(NSString *)height Step:(NSString *)step;

/*计算卡路里
 @parmar sex 用户性别
 @parmar weight 用户体重
 @parmar step   步数
 */
- (float)countCalWithSex:(NSString *)sex userWeight:(NSString *)weight step:(NSString *)step;

/*解析表盘数据包
 @parmar name 解析对应的表盘bin文件 如：watch_000010 不需要添加.bin
 @parmar number 需要替换表盘的位置（1，2，3）
 */
- (void)analySwitchs:(NSString *)name replace:(int )number;
@end
