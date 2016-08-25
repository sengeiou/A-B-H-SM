//
//  SmaAnalysisWebServiceTool.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAnalysisWebServiceTool.h"
#import "ACAccountManager.h"
#import "ACloudLib.h"
#import "ACObject.h"
#import "ACFileManager.h"
//#import "ACNotificationManager.h"
#import "AFNetworking.h"
//#import "SmaDataDAL.h"
//192.168.0.137
//58.96.179.251
//#define NetWorkAddress @"http://58.96.179.251:8080/Smalife/services/userservice?wsdl"
//#define NameSpace @"http://webservice.smalife.com/"
//#define NetWorkShservice @"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"
//#define NetWorkfriendService @"http://58.96.179.251:8080/Smalife/services/friendService?wsdl"
//#define NetWorkSersion @"http://58.96.179.251:8080/Smalife/services/getIOSVersion?wsdl"
#define servicename @"mywatch"
#define service @"watch"
#define sportDict @"sportDict"
#define sleepDict @"sleepDict"
#define clockDict @"clockDict"

//#define NetWorkAddress @"http://192.168.0.137:8080/Smalife/services/userservice?wsdl"
//#define NameSpace @"http://webservice.smalife.com/"
//#define NetWorkShservice @"http://192.168.0.137:8080/Smalife/services/pushservice?wsdl"
//#define NetWorkfriendService @"http://192.168.0.137:8080/Smalife/services/friendService?wsdl"

@implementation SmaAnalysisWebServiceTool
{
    NSMutableDictionary *userInfoDic;
}
static  NSInteger versionInteger = 1;//1为正式环境，3测试环境
static NSString *user_acc = @"account";NSString *user_id = @"_id";NSString *user_nick = @"nickName";NSString *user_token = @"token";NSString *user_hi = @"hight";NSString *user_we= @"weight";NSString *user_sex = @"sex";NSString *user_age = @"age";NSString *user_he = @"header_url";NSString *user_fri = @"friend_account";NSString *user_fName = @"friend_nickName";NSString *user_agree = @"agree";NSString *user_aim = @"steps_Aim";NSString *user_rate = @"rate";
//****** account 用户账号；_id 蓝牙设备唯一ID；nickName 用户名；token 友盟token；hight 身高；weight 体重；sex 性别；age 年龄；header_url 头像链接；friend_account 好友账号；agree 是否同意好友；aim_steps 运动目标；*****//

#pragma mark *******云平台接口*******
//登录
- (void)acloudLoginWithAccount:(NSString *)account Password:(NSString *)passowrd success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager loginWithUserInfo:account password:passowrd callback:^(ACUserInfo *user, NSError *error) {
        
        if (!error) {
            if (![user.phone isEqualToString:@""]) {
                [userInfoDic setValue:user.phone forKey:user_acc];
            }
            if (![user.email isEqualToString:@""]) {
                 [userInfoDic setValue:user.phone forKey:user_acc];
            }
            userInfoDic = [NSMutableDictionary dictionary];
            [userInfoDic setValue:user.nickName forKey:user_nick];
            
            [self acloudGetUserifnfoSuccess:^(NSMutableDictionary *userDict) {
                if (userDict) {
//                    [self acloudGetFriendWithAccount:account success:^(id userInfo) {
//                        [self acloudDownLDataWithAccount:account success:^(id result) {
//                            [self acloudCIDSuccess:^(id result) {
                    
                                if (success) {
                                    success(userInfoDic);
                                }
//                            } failure:^(NSError *error) {
//                                if (failure) {
//                                    failure(error);
//                                }
//                                
//                            }];
//                        } failure:^(NSError *error) {
//                            if (failure) {
//                                failure(error);
//                            }
//                            
//                        }];
                        
//                    } failure:^(NSError *error) {
//                        if (failure) {
//                            failure(error);
//                        }
//                    }];
                }
                else{
                    if (failure) {
                        failure(error);
                    }
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//第三方登录
- (void)acloudLoginWithOpenId:(NSString *)openId provider:(NSString *)provider accessToken:(NSString *)accessToken success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    [ACAccountManager registerWithOpenId:openId provider:provider accessToken:accessToken callback:^(ACUserInfo *user, NSError *error) {
        if (!error) {
            
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//退出登录
- (void)logOutSuccess:(void (^)(bool result))callBack {
    [ACAccountManager logout];
}

//检测是否存在该用户
- (void)acloudCheckExist:(NSString *)account success:(void (^)(bool))success failure:(void (^)(NSError *))failure{
    [ACAccountManager checkExist:account callback:^(BOOL exist, NSError *error) {
        if (!error) {
            if (success) {
                success(exist);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//发送验证码
- (void)acloudSendVerifiyCodeWithAccount:(NSString *)account template:(NSInteger)templat success:(void (^)(id))success failure:(void (^)(NSError *))failure{
      [ACAccountManager sendVerifyCodeWithAccount:account template:templat callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(error);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//注册用户
- (void)acloudRegisterWithPhone:(NSString *)phone email:(NSString *)email password:(NSString *)password verifyCode:(NSString *)verifiy success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager registerWithPhone:phone email:email password:password verifyCode:verifiy callback:^(NSString *uid, NSError *error) {
        if (!error) {
            if (success) {
                success(uid);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//修改密码
- (void)acloudResetPasswordWithAccount:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager resetPasswordWithAccount:account verifyCode:verifyCode password:password callback:^(NSString *uid, NSError *error) {
        if (!error) {
            if (success) {
                success(uid);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//设置个人信息
//- (void)acloudPutUserifnfo:(SmaUserInfo *)info success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
//    [ACAccountManager changeNickName:info.nickname callback:^(NSError *error) {
//        
//    }];
//    NSArray *quiteArr = [SmaUserDefaults objectForKey:@"quietDaArr"];
//    int quitHR;
//    if (quiteArr.count>1) {
//        quitHR = [[quiteArr[1][1] stringByReplacingOccurrencesOfString:@" bpm" withString:@""] intValue];
////        NSLog(@"fefw==%@ %@",ResDetalLab.text,quiteArr[1]);
//    }
//    else {
//        quitHR = 0;
//    }
//    ACObject *msg = [[ACObject alloc] init];
//    [msg putInteger:@"age" value:info.age.integerValue?info.age.integerValue:@"".integerValue];
//    [msg putString:@"client_id" value:[SmaUserDefaults objectForKey:@"clientId"]?[SmaUserDefaults objectForKey:@"clientId"]:@""];
//    [msg putString:@"device_type" value:@"ios"];
//    [msg putString:@"header_url" value:@""];
//    [msg putFloat:@"hight" value:info.height.floatValue?info.height.floatValue:@"".floatValue];
//    [msg putInteger:@"sex" value:info.sex.integerValue?info.sex.integerValue:@"".integerValue];
//    [msg putInteger:@"steps_Aim" value:[SmaUserDefaults objectForKey:@"stepPlan"]?[[SmaUserDefaults objectForKey:@"stepPlan"] integerValue]*1000:@"".integerValue];
//    [msg putFloat:@"weight" value:info.weight.floatValue?info.weight.floatValue:@"".floatValue];
//    [msg putInteger:@"rate" value:quitHR];
//    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
//        if (!error) {
//            if (success) {
//                success(error.debugDescription);
//            }
//        }
//        else{
//            if (failure) {
//                failure(error);
//            }
//        }
//    }];
//}

//发送CID 
- (void)acloudCIDSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    ACObject *msg = [[ACObject alloc] init];
    NSLog(@"CID==%@",[SMADefaultinfos getValueforKey:@"clientId"]);
     [msg putString:@"client_id" value:[SMADefaultinfos getValueforKey:@"clientId"]?[SMADefaultinfos getValueforKey:@"clientId"]:@""];
    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(@"1");
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];

}

//清除CID
- (void)acloudRemoveCIDSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    ACObject *msg = [[ACObject alloc] init];
    [msg putString:@"client_id" value:@""];
    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(@"1");
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
    
}

//发送照片
- (void)acloudHeadUrlSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    ACFileInfo * fileInfo = [[ACFileInfo alloc] initWithName:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userName] bucket:@"/sma/watch/header" Checksum:0];
    //照片路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userName]];
    fileInfo.filePath = uniquePath;
    fileInfo.acl = [[ACACL alloc] init];
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager uploadFileWithfileInfo:fileInfo progressCallback:^(float progress) {
        NSLog(@"progressCallback  %f",progress);
    } voidCallback:^(ACMsg *responseObject, NSError *error) {
        NSLog(@"error %@",error);
        if (!error) {
            if (success) {
                success(@"1");
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
        
    }];
}

//下载头像照片
- (void)acloudDownLHeadUrlWithAccount:(NSString *)account Success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [NSString stringWithFormat:@"%@/%@.jpg",[paths objectAtIndex:0],account];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   [fileManager removeItemAtPath:cachesDir error:nil];
    
    ACFileInfo * fileInfo1 = [[ACFileInfo alloc] initWithName:[NSString stringWithFormat:@"%@.jpg",account] bucket:@"/sma/watch/header" Checksum:0];
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager getDownloadUrlWithfile:fileInfo1 ExpireTime:0 payloadCallback:^(NSString *urlString, NSError *error) {
         [upManager downFileWithsession:urlString checkSum:0 callBack:^(float progress, NSError *error) {
            NSLog(@"callBack==%f   error==%@",progress,error);
            if (error) {
                if (failure) {
                    failure(error);
                }
            }
        } CompleteCallback:^(NSString *filePath) {

            if (filePath) {
                [userInfoDic setValue:filePath forKey:user_he];
                if (success) {
                    success(@"1");
                }
            }
            else{
                if (failure) {
                    failure(error);
                }
            }
        }];
    }];
}


//获取个人信息
- (void)acloudGetUserifnfoSuccess:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSError *))failure{
    
    [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
        if (!error) {
            userInfoDic = [self userDataWithACmsg:profile];
            if (success) {
                success(userInfoDic);
            }
        }
        if (failure) {
            failure(error);
        }
    }];
}

//好友添加请求
- (void)acloudRequestFriendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc]init];
    msg.name = @"askFriend";
    [msg putString:@"fAccount" value:fAccount?fAccount:@""];
    [msg putString:@"uAccount" value:account?account:@""];
    [msg putString:@"nickName" value:nickName?nickName:@""];
    [msg putString:@"device_type" value:@"ios"];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSString *result = [NSString stringWithFormat:@"%ld",[responseMsg getLong:@"rt"]];
        if (!error) {
            if (success) {
                success(result);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//应答好友
- (void)acloudReplyFriendAccount:(NSString *)fAccount FrName:(NSString *)fName MyAccount:(NSString *)mAccount MyName:(NSString *)mName agree:(BOOL)isAgree success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *mag = [[ACMsg alloc] init];
    mag.name = @"responseAsk";
    [mag putString:@"nickName" value:mName?mName:@""];
    [mag putString:@"uAccount" value:mAccount];
    [mag putString:@"fAccount" value:fAccount];
    [mag putString:@"fnickName" value:fName];
    [mag putInteger:@"agree" value:isAgree];
    [mag putString:@"device_type" value:@"ios"];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:mag callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                success(responseMsg);
            }
        }
        else{
            if (error) {
                failure(error);
            }
        }
    }];
}

//获取好友信息
- (void)acloudGetFriendWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"scanFriendInfo";
    [msg putString:@"uAccount" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                userInfoDic = [self friendDataWithACmsg:responseMsg];
                success(userInfoDic);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//删除好友
- (void)acloudDeleteFridendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"unBondFriends";
    [msg putString:@"uAccount" value:account];
    [msg putString:@"nickName" value:nickName];
    [msg putString:@"fAccount" value:fAccount];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                success(responseMsg);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//互动推送
- (void)acloudDispatcherFriendAccount:(NSString *)fAccount content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    ACMsg *msg = [[ACMsg alloc] init];
//    msg.name = @"dispatcherMsg";
//    [msg putString:@"dis_account" value:fAccount];
//    [msg putInteger:@"content_key" value:content.integerValue];
//    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
//        if (!error) {
//            if([content intValue]==32)
//            {
////                [SmaBleMgr setInteractone31];
//                [SmaBleMgr setBLInstructionMode:SETINTERACT31 IsSwitch:NO number:0 identifier:@"0" array:@"0"];
//            }else {
////                [SmaBleMgr setInteractone33];
//                [SmaBleMgr setBLInstructionMode:SETINTERACT33 IsSwitch:NO number:0 identifier:@"0" array:@"0"];
//            }
//            
//            if (success) {
//                success(responseMsg);
//            }
//        }
//        else{
//            if (failure) {
//                failure(error);
//            }
//        }
//    }];
}

//上传数据
//- (void)acloudSyncAllDataWithAccount:(NSString *)account sportDic:(NSMutableArray *)sport sleepDic:(NSMutableArray *)sleep clockDic:(NSMutableArray *)clock HRDic:(NSMutableArray *)hr success:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    __block int i = 0;
//    SmaSeatInfo *setInfo = [SmaAccountTool seatInfo];
//    
//    ACMsg *msg = [[ACMsg alloc] init];
//    msg.name = @"sync_all";
//    if (sport.count>0) {
//          [msg put:@"sport_list" value:sport];
//    }
//    if (sleep.count > 0) {
//          [msg put:@"sleep_list" value:sleep];
//    }
//    if (clock.count>0) {
//            [msg put:@"clock_list" value:clock];
//    }
//    if (hr.count > 0) {
//        [msg put:@"rate_list" value:hr];
//    }
//    [msg putString:@"user_account" value:account?account:@""];
//    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
//        if (!error) {
//            i++;
//            if (i==2) {
//                [self clearUserSportWithMsg:nil sportData:sport];
//                [self clearUserSleeptWithMsg:nil sleepData:sleep Account:account];
//                [self clearUserHRWithMsg:nil HRData:hr];
//                if (success) {
//                    success(error);
//                }
//            }
//        }
//        else {
//            if (failure) {
//                failure(error);
//            }
//        }
//    }];
//    
//    ACMsg *msg2= [[ACMsg alloc] init];
//    msg2.name = @"sync_sma_data";
//    [msg2 putInteger:@"lost_open" value:[SmaUserDefaults integerForKey:@"myLoseInt"]?[SmaUserDefaults integerForKey:@"myLoseInt"]:@"".integerValue];
//    [msg2 putInteger:@"msg_notic" value:[SmaUserDefaults integerForKey:@"mySmsRemindInt"]?[SmaUserDefaults integerForKey:@"mySmsRemindInt"]:@"".integerValue];
//    [msg2 putInteger:@"tel_notic" value:[SmaUserDefaults integerForKey:@"myTelRemindInt"]?[SmaUserDefaults integerForKey:@"myTelRemindInt"]:@"".integerValue];
//    [msg2 putInteger:@"long_sit_start" value:setInfo.beginTime.integerValue?setInfo.beginTime.integerValue:@"".integerValue];
//    [msg2 putInteger:@"long_sit_end" value:setInfo.endTime.integerValue?setInfo.endTime.integerValue:@"".integerValue];
//    [msg2 putInteger:@"long_min" value:setInfo.seatValue.integerValue?setInfo.seatValue.integerValue:@"".integerValue];
//    [msg2 putInteger:@"long_sit_open" value:setInfo.isOpen.integerValue?setInfo.isOpen.integerValue:@"0".integerValue];
//    [msg2 putString:@"weeks" value:[self getWeekStr:setInfo.pepeatWeek]?[self getWeekStr:setInfo.pepeatWeek]:@""];
//    [msg2 putString:@"user_account" value:account?account:@""];
//    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg2 callback:^(ACMsg *responseMsg, NSError *error) {
//        if (!error) {
//            i++;
//            if (i == 2) {
//                [self clearUserSportWithMsg:nil sportData:sport];
//                [self clearUserSleeptWithMsg:nil sleepData:sleep Account:account];
//                [self clearUserHRWithMsg:nil HRData:hr];
//                if (success) {
//                    success(responseMsg);
//                }
//            }
//        }
//        else {
//            if (failure) {
//                failure(error);
//            }
//        }
//    }];
//}

//下载数据
- (void)acloudDownLDataWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure{
   __block int i = 0;
    ACMsg *Spmsg = [[ACMsg alloc] init];
    Spmsg.name = @"sync_sport";
    [Spmsg putString:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:Spmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSportWithMsg:responseMsg sportData:nil];
            i++;
            if (i==5) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *Slmsg = [[ACMsg alloc] init];
    Slmsg.name = @"sync_sleep";
    [Slmsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:Slmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSleeptWithMsg:responseMsg sleepData:nil Account:account];
            i++;
            if (i==5) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *Clmsg = [[ACMsg alloc] init];
    Clmsg.name = @"sync_clock";
    [Clmsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:Clmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserClockWithMsg:responseMsg Account:account];
            i++;
            if (i==5) {
                if (success) {
                    success(error);
                }
            }
                   }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];

    ACMsg *smamsg = [[ACMsg alloc] init];
    smamsg.name = @"sync_sma";
    [smamsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:smamsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSatWithMsg:responseMsg];
            i++;
            if (i==5) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *HRmsg = [[ACMsg alloc] init];
    HRmsg.name = @"sync_rate";
    [HRmsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:HRmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserHRWithMsg:responseMsg HRData:nil];
            i++;
            if (i==5) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
   }

// 上传MAC
- (void)uploadMACWithAccount:(NSString *)user MAC:(NSString *)mac watchType:(NSString *)smaName success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"addAddresToWx";
//    [msg putString:@"user_account" value:user?user:@""];
    [msg putString:@"type" value:smaName?smaName:@""];
    [msg putString:@"address" value:mac?mac:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                success(error);
                }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

- (void)acloudCheckMACtoWeChat:(NSString *)MAC callBack:(void(^)(NSString *mac,NSError *error))callback{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"isAddressInWx";
    [msg put:@"address" value:MAC?MAC:@""];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSString *macStr;
        if (!error) {
            if (![responseMsg isEqual:@"none"]) {
                macStr = [[responseMsg get:@"address"] getString:@"address"];
            }
            if (!macStr || [macStr isEqualToString:@""]) {
                [self sendMACWeChat];
            }
        }
            callback(macStr,error);
    }];

}

//整理接收用户信息
- (NSMutableDictionary *)userDataWithACmsg:(ACObject *)responseMsg{
    if (![responseMsg isEqual:@"none"]) {
        NSMutableArray  *quietDaArr = [NSMutableArray array];
        [quietDaArr addObject:@[@"hearRate_quiet_last",@"hearReat_quietTitle"]];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy.MM.dd";
        NSString *str = [fmt stringFromDate:[NSDate date]];
        [quietDaArr addObject:@[str,[NSString stringWithFormat:@"%ld bpm",[responseMsg getLong:user_rate]]]];
        [SMADefaultinfos putKey:@"quietDaArr" andValue:quietDaArr];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_hi]] forKey:user_hi];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_we]] forKey:user_we];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_sex]] forKey:user_sex];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_age]] forKey:user_age];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_he]] forKey:user_he];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]] forKey:user_aim];
        [userInfoDic setObject:quietDaArr forKey:@"user_rate"];
//        if ([NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]].intValue/1000==0) {
//            [SMADefaultinfos removeValueForKey:@"stepPlan"];
//        }
//        else{
//            [SMADefaultinfos putInt:@"stepPlan" andValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]].intValue/1000];
//        }
//        [userInfoDic setValue:[responseMsg getString:@"client_id"] forKey:@"client_id"];
    }
    return userInfoDic;
}

//整理接收好友信息
- (NSMutableDictionary *)friendDataWithACmsg:(ACObject *)responseMsg{
    if (![responseMsg isEqual:@"none"]) {
        if ([responseMsg get:@"friend"]) {
            [userInfoDic setValue:[[responseMsg get:@"friend"] getString:@"friend_account"] forKey:user_fri];
            [userInfoDic setValue:[[responseMsg get:@"friend"] getString:@"friendName"] forKey:user_fName];
        }
    }
    return userInfoDic;
}

//整理发送用户信息
//- (void)clearUserWithMsg:(ACMsg *)msg userInfo:(SMAUserInfo *)info{
//    [msg putString:user_acc value:info.userName?info.userName:@""];
//    [msg putString:user_nick value:info.nickname?info.nickname:@""];
//    [msg putString:user_token value:info.token?info.token:@""];
//    [msg putFloat:user_hi value:info.height.floatValue?info.height.floatValue:[NSString stringWithFormat:@""].floatValue];
//    [msg putFloat:user_we value:info.weight.floatValue?info.weight.floatValue:@"".floatValue];
//    [msg putInteger:user_id value:info.bli_id.integerValue?info.bli_id.integerValue:@"".integerValue];
//    [msg putInteger:user_sex value:info.sex.integerValue?info.sex.integerValue:@"".integerValue];
//    [msg putInteger:user_age value:info.age.integerValue?info.age.integerValue:@"".integerValue];
//    [msg putString:user_he value:info.header_url?info.header_url:@""];
//    [msg putString:user_fri value:info.friendAccount?info.friendAccount:@""];
//    [msg putString:user_fName value:info.nicknameLove?info.nicknameLove:@""];
//    [msg putInteger:user_aim value:info.aim_steps.integerValue?info.aim_steps.integerValue:@"".integerValue];
//    [msg putInteger:user_agree value:info.agree.integerValue?info.agree.integerValue:@"".integerValue];
//}


// 保存下载运动数据
- (void)clearUserSportWithMsg:(ACMsg *)msg sportData:(NSMutableArray *)sportArr{
//    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
//    NSMutableArray *infos=[NSMutableArray array];
//    if (msg) {
//        if (![msg isEqual:@"none"]) {
//            NSArray *spArr = [msg get:@"sport_sync_rt"];
//            if (spArr.count>0) {
//                for (int i =0; i<spArr.count; i++) {
//                    SmaSportInfo *info=[[SmaSportInfo alloc]init];
//                    info.sport_calory = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"calorie"] floatValue]];
//                    info.sport_data = [[spArr[i] objectForKey:@"count_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                    info.sport_distance = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"distance"] floatValue]];
//                    info.sport_time = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"offset"] floatValue]];
//                    info.sport_step = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"steps"] floatValue]];
//                    info.user_id = [NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"user_account"]];
//                    info.sport_id = [NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"sport_id"]];
//                    info.sport_activetime = @0;
//                    info.sport_web = @1;
//                    if (info.sport_calory.intValue > 0) {
//                         [infos addObject:info];
//                    }
//                    else{
//                         [smaDal insertSportWithUserID:info.user_id cuffID:info.sport_id Date:info.sport_data Time:[NSString stringWithFormat:@"%@",info.sport_time] Step:[NSString stringWithFormat:@"%@",info.sport_step] Ident:@"SM07" isWeb:@"1" finish:^(id finish) {
//                         }];
//                    }
//                }
//                if (infos.count > 0) {
//                    [smaDal insertSmaSport:infos];
//                }
//            }
//        }
//    }
//    else if (sportArr){
//        for (int i =0; i<sportArr.count; i++) {
//            SmaSportInfo *info=[[SmaSportInfo alloc]init];
//            info.sport_calory = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"calorie"] floatValue]];
//            info.sport_data = [[sportArr[i] objectForKey:@"count_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            info.sport_distance = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"distance"] floatValue]];
//            info.sport_time = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"offset"] floatValue]];
//            info.sport_step = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"steps"] floatValue]];
//            info.user_id = [NSString stringWithFormat:@"%@",[sportArr[i] objectForKey:@"user_account"]];
//            info.sport_id = [NSString stringWithFormat:@"%@",[sportArr[i] objectForKey:@"sport_id"]];
//            info.sport_activetime = @0;
//            info.sport_web = @1;
//            [infos addObject:info];
//        }
//        [smaDal insertSmaSport:infos];
//        
//    }
}

//保存下载睡眠数据
- (void)clearUserSleeptWithMsg:(ACMsg *)msg sleepData:(NSMutableArray *)sleepArr Account:(NSString *)account{
//    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
//    NSMutableArray *infos=[NSMutableArray array];
//    if (msg) {
//        if (![msg isEqual:@"none"]) {
//            NSArray *slArr = [msg get:@"sleep_sync_rt"];
//            if (slArr.count>0) {
//                for (int i =0; i<slArr.count; i++) {
//                    SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
//                    info.user_id = account;
//                    info.sleep_id = [NSString stringWithFormat:@"%@",[slArr[i] objectForKey:@"sleep_id"]];
//                    info.sleep_data = [[slArr[i] objectForKey:@"sleep_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                    info.sleep_mode = [NSNumber numberWithInt:[[slArr[i] objectForKey:@"time_type"] intValue]];;
//                    info.sleep_time = [NSString stringWithFormat:@"%@",[slArr[i] objectForKey:@"action_time"]];
//                    info.sleep_type = [NSNumber numberWithInt:[[slArr[i] objectForKey:@"sleep_type"] intValue]];
//                    info.sleep_softly = @0;
//                    info.sleep_strong = @0;
//                    info.sleep_wear = @1;
//                    info.sleep_web = @1;
//                    [infos addObject:info];
//                }
//                [smaDal insertSleepInfo:infos];
//            }
//        }
//    }
//    else if (sleepArr){
//        
//        for (int i =0; i<sleepArr.count; i++) {
//            SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
//            info.user_id = account;
//            info.sleep_id = [NSString stringWithFormat:@"%@",[sleepArr[i] objectForKey:@"sleep_id"]];
//            info.sleep_data = [[sleepArr[i] objectForKey:@"sleep_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            info.sleep_mode = [NSNumber numberWithInt:[[sleepArr[i] objectForKey:@"time_type"] intValue]];;
//            info.sleep_time = [NSString stringWithFormat:@"%@",[sleepArr[i] objectForKey:@"action_time"]];
//            info.sleep_type = [NSNumber numberWithInt:[[sleepArr[i] objectForKey:@"sleep_type"] intValue]];
//            info.sleep_softly = @0;
//            info.sleep_strong = @0;
//            info.sleep_wear = @1;
//            info.sleep_web = @0;
//            [infos addObject:info];
//        }
//        [smaDal insertSleepInfo:infos];
//        
//    }
}
//保存下载闹钟数据
- (void)clearUserClockWithMsg:(ACMsg *)msg Account:(NSString *)account{
//    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
//    NSMutableArray *infos=[NSMutableArray array];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"HH:mm";
//
//    if (![msg isEqual:@"none"]) {
//        NSArray *AlArr = [msg get:@"clock_sync_rt"];
//        if (AlArr.count>0) {
//            for (int i =0; i<AlArr.count; i++) {
//                SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
//                info.userId = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"user_account"]];
//                info.year = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"year"]];
//                info.mounth = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"month"]];
//                info.day = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"day"]];
//                NSString *time = [fmt stringFromDate:[fmt dateFromString:[AlArr[i] objectForKey:@"clock_time"]]];
//                info.hour = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(0, 2)]];
//                info.minute = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(3, 2)]];
//                info.tagname = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"name"]];
//                info.isopen = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"clockOpen"]];
//                info.dayFlags = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[AlArr[i] objectForKey:@"mon_day"],[AlArr[i] objectForKey:@"tues_day"],[AlArr[i] objectForKey:@"wes_day"],[AlArr[i] objectForKey:@"thur_day"],[AlArr[i] objectForKey:@"frid_day"],[AlArr[i] objectForKey:@"sta_day"],[AlArr[i] objectForKey:@"sun_day"]];
//                info.web = @"1";
//                [infos addObject:info];
//            }
//            if (infos>0) {
//               [smaDal deleteClockUserInfo:account success:^(id result) {
//                   for (int i=0; i<infos.count; i++) {
//                       [smaDal insertClockInfo:infos[i]];
//                   }
// 
//               } failure:^(id result) {
//                   
//               } ];
//             
//            }
//        }
//    }
    
}

// 保存下载心率数据
- (void)clearUserHRWithMsg:(ACMsg *)msg HRData:(NSMutableArray *)HRArr{
//    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
//    if (msg) {
//        if (![msg isEqual:@"none"]) {
//            NSArray *hrArr = [msg get:@"ratelist"];
//            if (hrArr.count>0) {
//                for (int i =0; i<hrArr.count; i++) {
//                    NSString *hr_id = [NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"rate_id"]];
//                    NSString *userid = [NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"user_account"]];
//                    NSString *hr_date = [[NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"rate_date"]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                    NSString *hr_time = [NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"rate_time"]];
//                    NSString *hr_static = [NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"rate_status"]];
//                    NSString *hr = [NSString stringWithFormat:@"%@",[hrArr[i] objectForKey:@"rate_value"]];
//                    [smaDal insertHRDataWithUserID:userid HRid:hr_id HRdate:hr_date HRtime:hr_time HRStatic:hr_static HRreal:hr HRWeb:@"0"];
//                }
//            }
//        }
//    }
//    else if (HRArr){
//        for (int i =0; i<HRArr.count; i++) {
//            NSString *hr_id = [NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"rate_id"]];
//            NSString *userid = [NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"user_account"]];
//            NSString *hr_date = [[NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"rate_date"]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//             NSString *hr_time = [NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"rate_time"]];
//             NSString *hr_static = [NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"rate_status"]];
//             NSString *hr = [NSString stringWithFormat:@"%@",[HRArr[i] objectForKey:@"rate_value"]];
//             [smaDal insertHRDataWithUserID:userid HRid:hr_id HRdate:hr_date HRtime:hr_time HRStatic:hr_static HRreal:hr HRWeb:@"0"];
//        }
//        
//    }
}
//保存下载设置数据
- (void)clearUserSatWithMsg:(ACMsg *)msg{
//    SmaSeatInfo *seatInfo=[[SmaSeatInfo alloc]init];
//    ACObject *object = [msg get:@"sma_data"];
//     if (![msg isEqual:@"none"]) {
//         seatInfo.beginTime = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_start"]];
//         seatInfo.endTime = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_end"]];
//         seatInfo.seatValue = [NSString stringWithFormat:@"%ld",[object getLong:@"long_min"]];
//         seatInfo.isOpen = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_open"]];
//         seatInfo.pepeatWeek = [self setStringWith:[object getString:@"weeks"]];
//         [SmaAccountTool saveSeat:seatInfo];
//         [SmaUserDefaults setInteger:[object getLong:@"lost_open"] forKey:@"myLoseInt"];
//         [SmaUserDefaults setInteger:[object getLong:@"msg_notic"] forKey:@"mySmsRemindInt"];
//         [SmaUserDefaults setInteger:[object getLong:@"tel_notic"] forKey:@"myTelRemindInt"];
//     }
}

//整理设置数据
-(NSString *)getWeekStr:(NSString *)weekStr{
    
    NSArray *week=[weekStr componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            if ([str isEqualToString:@""]) {
                str=[NSString stringWithFormat:@"%@",[self stringWith:i]];

            }
            else{
            str=[NSString stringWithFormat:@"%@,%@",str,[self stringWith:i]];
            }
        }
    }
    return str;
}

-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SMALocalizedString(@"clockadd_monday");
            break;
        case 1:
            weekStr= SMALocalizedString(@"clockadd_tuesday");
            break;
        case 2:
            weekStr= SMALocalizedString(@"clockadd_wednesday");
            break;
        case 3:
            weekStr= SMALocalizedString(@"clockadd_thursday");
            break;
        case 4:
            weekStr=SMALocalizedString(@"clockadd_friday");
            break;
        case 5:
            weekStr= SMALocalizedString(@"clockadd_saturday");
            break;
        default:
            weekStr= SMALocalizedString(@"clockadd_sunday");
    }
    return weekStr;
}

- (NSString *)setStringWith:(NSString *)WeekStr{
    NSArray *week=[WeekStr componentsSeparatedByString: @","];
    NSString *str = @"";
    NSMutableArray *WeekArr = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    for (int i = 0; i<week.count; i++) {
       WeekArr = [self createWeekWith:week[i] WeekArr:WeekArr];
    }
    for (int i = 0; i<7; i++) {
        if ([str isEqualToString:@""]) {
            str=[NSString stringWithFormat:@"%@",WeekArr[i]];
            
        }
        else{
            str=[NSString stringWithFormat:@"%@,%@",str,WeekArr[i]];
        }

    }
    
    return str;
}

- (NSMutableArray *)createWeekWith:(NSString *)week WeekArr:(NSMutableArray *)array{
    NSMutableArray *arr = array;
    if ([week isEqualToString:SMALocalizedString(@"clockadd_monday")]) {
        [arr replaceObjectAtIndex:0 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_tuesday")]){
        [arr replaceObjectAtIndex:1 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_wednesday")]){
        [arr replaceObjectAtIndex:2 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_thursday")]){
        [arr replaceObjectAtIndex:3 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_friday")]){
        [arr replaceObjectAtIndex:4 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_saturday")]){
        [arr replaceObjectAtIndex:5 withObject:@"1"];
    }
    else if ([week isEqualToString:SMALocalizedString(@"clockadd_sunday")]){
        [arr replaceObjectAtIndex:6 withObject:@"1"];
    }
    return arr;
}

- (void)sendMACWeChat{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxf71013eb5678c378&secret=04d04762ffde3117b823f9aa53b6ee72" parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *tocken = [responseObject objectForKey:@"access_token"];
        
        [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/device/getqrcode?access_token=%@&product_id=5275",tocken] parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSString *deviceid = [responseObject objectForKey:@"deviceid"];
            NSDictionary *parameters = @{@"device_num":@"1",@"device_list":@[@{@"id":deviceid,@"mac":(NSString *)[[SMADefaultinfos getValueforKey:@"MAC"] stringByReplacingOccurrencesOfString:@":" withString:@""],@"connect_protocol":@"3",@"auth_key":@"1234567890ABCDEF1234567890ABCDEF",@"close_strategy":@"1",@"conn_strategy":@"1",@"crypt_method":@"1",@"auth_ver":@"1",@"manu_mac_pos":@"-1",@"ser_mac_pos":@"-2",@"ble_simple_protocol":@"1"}],@"op_type":@"1"};
            
            [manager POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/device/authorize_device?access_token=%@",tocken] parameters:parameters
                  success:^(NSURLSessionDataTask *operation,id responseObject) {
                      
                      NSLog(@"Success: %@  %@", responseObject,[[[responseObject objectForKey:@"resp"] firstObject] objectForKey:@"errmsg"]);
                      NSArray *arr = [responseObject objectForKey:@"resp"];
                      if (arr.count > 0) {
                          if([[[[responseObject objectForKey:@"resp"] firstObject] objectForKey:@"errmsg"]isEqualToString:@"ok"])
                              //                              [SmaUserDefaults setBool:YES forKey:@"weChat"];
                              [self uploadMACWithAccount:@"" MAC:[SMADefaultinfos getValueforKey:@"MAC"] watchType:[SMADefaultinfos getValueforKey:@"BANDWATCH"] success:^(id success) {
                                  
                              } failure:^(NSError *error) {
                                  
                              }];
                      }
                  }failure:^(NSURLSessionDataTask *operation,NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
}
@end
