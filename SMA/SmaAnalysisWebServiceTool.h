//
//  SmaAnalysisWebServiceTool.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAUserInfo.h"
#import "SMAAccountTool.h"
#import "SMAWebDataHandleInfo.h"
#import "ACFeedBack.h"
#import "ACFeedBackManager.h"
#import <sys/utsname.h>
#define watchface_recommending @"smav2_watchface_recommending"//（推荐）
#define watchface_dynamic @"smav2_watchface_dynamic"//动态
#define watchface_pointer @"smav2_watchface_pointer"//指针
#define watchface_number @"smav2_watchface_number"//数字
#define watchface_other @"smav2_watchface_other"//其他
#define firmware_smav2 @"get_versions_smav2"
#define firmware_sma07c @"get_versions_sma07c"

@interface SmaAnalysisWebServiceTool : NSObject
@property (nonatomic, strong) NSString *chaImageName;
//登陆
-(void)getWebServiceLogin:(NSString *)userName userPwd:(NSString *)userPwd clientId:(NSString *)clientId success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
//第三方登录
- (void)acloudLoginWithOpenId:(NSString *)openId provider:(NSString *)provider accessToken:(NSString *)accessToken success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
//注册
-(void)getWebServiceRegister:(NSString *)userName userPwd:(NSString *)userPwd clientId:(NSString *)clientId success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//推送成功
-(void)getWebServiceSendLove:(NSString *)device_type  nickName:(NSString *)nickName friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id  success:(void (^)(id))success failure:(void (^)(NSError *))failure;

-(void)getWebServiceSendIiBound:(NSString *)device_type friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id  success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//返回配对结果
-(void)sendBackNatchesResult:(NSString *)device_type friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id friend_id:(NSString *)friend_id agree:(NSString *)agree  nickName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure;

-(void)sendInteraction:(NSString *)device_type friendAccount:(NSString *)friendAccount content:(NSString *)content;
//更新用户
-(void)updateWebserverUserInfo:(SMAUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure;
////解除绑定
-(void)sendunBondFriends:(SMAUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure;
////获取好友信息
-(void)getBondFriends:(NSString *)device_type userInfo:(SMAUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure;
-(void)UpdateUserPwd:(NSString *)tel pwd:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//检查更新
- (void)checkUpdate:(void (^)(id))success failure:(void (^)(NSError *))failure;

//ableCloud登录
- (void)acloudLoginWithAccount:(NSString *)account Password:(NSString *)passowrd success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//退出登录
- (void)logOutSuccess:(void (^)(bool result))callBack;
//检测是否存在该用户
- (void)acloudCheckExist:(NSString *)account success:(void (^)(bool))success failure:(void (^)(NSError *))failure;
//发送验证码
- (void)acloudSendVerifiyCodeWithAccount:(NSString *)account template:(NSInteger)templat success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//注册用户
- (void)acloudRegisterWithPhone:(NSString *)phone email:(NSString *)email password:(NSString *)password verifyCode:(NSString *)verifiy success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//修改密码
- (void)acloudResetPasswordWithAccount:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)acloudChangePasswordWithOld:(NSString *)old new:(NSString *)newPassword callback:(void (^)(NSString *uid, NSError *error))callback;
//发送照片
- (void)acloudHeadUrlSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
//下载头像照片
- (void)acloudDownLHeadUrlWithAccount:(NSString *)account Success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//设置个人信息
- (void)acloudPutUserifnfo:(SMAUserInfo *)info success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
//发送CID
- (void)acloudCIDSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
//清除CID
- (void)acloudRemoveCIDSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
//获取个人信息
- (void)acloudGetUserifnfoSuccess:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSError *))failure;
//好友添加请求
- (void)acloudRequestFriendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//应答好友
- (void)acloudReplyFriendAccount:(NSString *)fAccount FrName:(NSString *)fName MyAccount:(NSString *)mAccount MyName:(NSString *)mName agree:(BOOL)isAgree success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//获取好友信息
- (void)acloudGetFriendWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//删除好友
- (void)acloudDeleteFridendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//互动推送
- (void)acloudDispatcherFriendAccount:(NSString *)fAccount content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//上传数据
- (void)acloudSyncAllDataWithAccount:(NSString *)account callBack:(void (^)(id finish)) callBack;
//- (void)acloudSyncAllDataWithAccount:(NSString *)account sportDic:(NSMutableArray *)sport sleepDic:(NSMutableArray *)sleep clockDic:(NSMutableArray *)clock HRDic:(NSMutableArray *)hr success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//下载数据
- (void)acloudDownLDataWithAccount:(NSString *)account callBack:(void (^)(id finish))callback;
//- (void)acloudDownLDataWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure;
// 上传MAC
- (void)uploadMACWithAccount:(NSString *)user MAC:(NSString *)mac watchType:(NSString *)smaName success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//校验MAC
- (void)acloudCheckMACtoWeChat:(NSString *)MAC callBack:(void(^)(NSString *mac,NSError *error))callback;

//插入排行步数
- (void)acloudSetScore:(int)score;

//获取所有用户步数及排行
- (void)acloudCheckRankingCallBack:(void(^)(NSMutableArray *list,NSError *error))callback;

//下载文件
- (void)acloudDownFileWithsession:(NSString *)url callBack:(void(^)(float progress,NSError * error))callback
                 CompleteCallback:(void (^)(NSString *filePath))completeCallback;

//下载表盘文件
- (void)acloudDownLoadWatchInfos:(NSString *)faceStr offset:(int)offset callBack:(void (^)(NSArray *finish,NSError *error))callback;

//获取固件版本信息
- (void)acloudDfuFileWithFirmwareType:(NSString *)type callBack:(void (^)(NSArray *finish,NSError *error))callback;

//根据表盘id获取缩略图
- (void)acloudDownLoadImageWithOffset:(int)offset callBack:(void (^)(id finish))callback;

//意见反馈
- (void)acloudFeedbackContact:(NSString *)contact content:(NSString *)content callBack:(void (^)(BOOL isSuccess, NSError *error))callback;
@end
