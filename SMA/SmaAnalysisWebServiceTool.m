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
#import "ACUserInfo.h"
#import "ACRankingManager.h"
#import "ACRankingValue.h"
//#import "ACNotificationManager.h"
#import "AFNetworking.h"
#define servicename @"mywatch"
#define service @"watch"
#define sportDict @"sportDict"
#define sleepDict @"sleepDict"
#define clockDict @"clockDict"



@implementation SmaAnalysisWebServiceTool
{
    NSMutableDictionary *userInfoDic;
}
static  NSInteger versionInteger = 1;//1为正式环境，3测试环境
static NSString *user_acc = @"account";NSString *user_id = @"_id";NSString *user_nick = @"nickName";NSString *user_token = @"token";NSString *user_hi = @"hight";NSString *user_we= @"weight";NSString *user_sex = @"sex";NSString *user_age = @"age";NSString *user_he = @"_avatar";NSString *user_fri = @"friend_account";NSString *user_fName = @"friend_nickName";NSString *user_agree = @"agree";NSString *user_aim = @"steps_Aim";NSString *user_rate = @"rate";
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
                    if (success) {
                        success(userInfoDic);
                    }
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
    //    [ACAccountManager registerWithOpenId:openId provider:provider accessToken:accessToken callback:^(ACUserInfo *user, NSError *error) {
    //        if (!error) {
    //            if (success) {
    //                success(user);
    //            }
    //        }
    //        else{
    //            if (failure) {
    //                failure(error);
    //            }
    //        }
    //    }];
    
    [ACAccountManager loginWithOpenId:openId provider:provider accessToken:accessToken callback:^(ACUserInfo *user, NSError *error) {
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
                    if (success) {
                        success(userInfoDic);
                    }
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

//退出登录
- (void)logOutSuccess:(void (^)(bool result))callBack {
    [ACAccountManager logout];
}

//检测是否存在该用户  ［QQ］48F26B4B9AECBCEDE457E9AB3F334AA1
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
            [self acloudLoginWithAccount:phone?phone:email Password:password success:^(id result) {
                if (success) {
                    success(result);
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

//重置密码
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

//修改密码
- (void)acloudChangePasswordWithOld:(NSString *)old new:(NSString *)newPassword callback:(void (^)(NSString *uid, NSError *error))callback{
    [ACAccountManager changePasswordWithOld:old new:newPassword callback:^(NSString *uid, NSError *error) {
        callback(uid,error);
    }];
}

//设置个人信息
- (void)acloudPutUserifnfo:(SMAUserInfo *)info success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [ACAccountManager changeNickName:info.userName callback:^(NSError *error) {
        
    }];
    ACObject *msg = [[ACObject alloc] init];
    [msg putInteger:@"age" value:info.userAge.integerValue?info.userAge.integerValue:@"".integerValue];
    //    [msg putString:@"client_id" value:[SmaUserDefaults objectForKey:@"clientId"]?[SmaUserDefaults objectForKey:@"clientId"]:@""];
    [msg putString:@"device_type" value:@"ios"];
    [msg putString:@"_avatar" value:info.userHeadUrl?info.userHeadUrl:@""];
    [msg putFloat:@"hight" value:info.userHeight.floatValue?info.userHeight.floatValue:@"".floatValue];
    [msg putInteger:@"sex" value:info.userSex.integerValue?info.userSex.integerValue:@"".integerValue];
    [msg putInteger:@"steps_Aim" value:info.userGoal.integerValue?info.userGoal.integerValue:@"".integerValue];
    [msg putFloat:@"weight" value:info.userWeigh.floatValue?info.userWeigh.floatValue:@"".floatValue];
    [msg putInteger:@"unit" value:info.unit.intValue];
    //    [msg putFloat:@"weight" value:info.userGoal.floatValue?info.userGoal.floatValue:@"".floatValue];
    //    [msg putInteger:@"rate" value:quitHR];
    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(error.debugDescription);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

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
    ACFileInfo * fileInfo = [[ACFileInfo alloc] initWithName:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID] bucket:@"/sma/watch/header" Checksum:0];
    NSLog(@"[SMAAccountTool userInfo].userID] :%@",[SMAAccountTool userInfo].userID);
    //照片路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID]];
    fileInfo.filePath = uniquePath;
    fileInfo.acl = [[ACACL alloc] init];
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager uploadFileWithfileInfo:fileInfo progressCallback:^(float progress) {
    } voidCallback:^(ACMsg *responseObject, NSError *error) {
        NSLog(@"error %@",error);
        if (!error) {
            [upManager getDownloadUrlWithfile:fileInfo ExpireTime:0 payloadCallback:^(NSString *urlString, NSError *error) {
                if (urlString) {
                    SMAUserInfo *user = [SMAAccountTool userInfo];
                    user.userHeadUrl = urlString;
                    [SMAAccountTool saveUser:user];
                    [self acloudPutUserifnfo:user success:^(NSString *success) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
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
        [self acloudDownFileWithsession:urlString callBack:^(float progress, NSError *error) {
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

- (void)acloudDownFileWithsession:(NSString *)url callBack:(void(^)(float progress,NSError * error))callback
                 CompleteCallback:(void (^)(NSString *filePath))completeCallback{
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager downFileWithsession:url checkSum:0 callBack:^(float progress, NSError *error) {
      NSLog(@"callBack==%f   error==%@  %@",progress,error,url);
        if (error) {
            if (callback) {
                callback(progress,error);
            }
        }
    } CompleteCallback:^(NSString *filePath) {
        NSLog(@"filePath==%@",filePath);
        if (filePath) {
            NSString *toPath;
            if (_chaImageName) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSFileManager *fm = [NSFileManager defaultManager];
                toPath = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],_chaImageName];
                [fm createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
                NSError *error;
                BOOL isSuccess;
                isSuccess = [fm moveItemAtPath:filePath toPath:toPath error:&error];
            }
            else{
                toPath = filePath;
            }
            if (completeCallback) {
                completeCallback(toPath);
            }
        }
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
        else{
            if (failure) {
                failure(error);
            }
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
- (void)acloudSyncAllDataWithAccount:(NSString *)account callBack:(void (^)(id finish)) callBack{
    SMADatabase *dal = [[SMADatabase alloc] init];
    NSMutableArray *spArr = [dal readNeedUploadSPData];
    NSMutableArray *slArr = [dal readNeedUploadSLData];
    NSMutableArray *rhArr = [dal readNeedUploadHRData];
    NSMutableArray *alArr = [dal readNeedUploadALData];
    ACObject *hrSetObject = [SMAWebDataHandleInfo heartRateSetObject];
    ACObject *sedentObject = [SMAWebDataHandleInfo sedentarinessSetObject];
    
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"upload_all_data";
    
    ACObject *dataObject = [[ACObject alloc] init];
    [dataObject putString:@"account" value:account];
    
    if (spArr.count > 0) {
//        ACObject *obje = [[ACObject alloc] init];
//        [obje putString:@"account" value:[[spArr objectAtIndex:0] objectForKey:@"account"]];
//        [obje putString:@"date" value:[[spArr objectAtIndex:0] objectForKey:@"date"]];
//        [obje putLongLong:@"time" value:[[[spArr objectAtIndex:0] objectForKey:@"time"] longLongValue]/1000];
//        [obje putInteger:@"step" value:[[[spArr objectAtIndex:0] objectForKey:@"step"] integerValue]];
//        [obje putInteger:@"mode" value:[[[spArr objectAtIndex:0] objectForKey:@"mode"] integerValue]];
        [dataObject put:@"sport_list" value:spArr];
    }
    if (slArr.count > 0) {
        [dataObject put:@"sleep_list" value:slArr];
    }
    if (rhArr.count > 0) {
        [dataObject put:@"rate_list" value:rhArr];
    }
    if (alArr.count > 0) {
        [dataObject put:@"alarm_list" value:alArr];
    }
    if (hrSetObject) {
        [dataObject put:@"heart_rate_settings" value:hrSetObject];
    }
    if (sedentObject) {
        [dataObject put:@"sedentariness_settings" value:sedentObject];
    }
    [msg put:@"data" value:dataObject];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSLog(@"sendToService %@  %@",responseMsg,error);
        if (error) {
            callBack(error);
            return ;
        }
        
        [SMAWebDataHandleInfo updateSPData:spArr finish:^(id finish) {
            
        }];
        [SMAWebDataHandleInfo updateSLData:slArr finish:^(id finish) {
            
        }];
        [SMAWebDataHandleInfo updateHRData:rhArr finish:^(id finish) {
            
        }];
        [SMAWebDataHandleInfo updateALData:alArr finish:^(id finish) {
            
        }];
        
    }];
}

//下载数据
- (void)acloudDownLDataWithAccount:(NSString *)account callBack:(void (^)(id finish))callback{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"download_all_data";
    ACObject *dataObject = [[ACObject alloc] init];
    [dataObject putString:@"account" value:account];
    [msg put:@"data" value:dataObject];
    __block NSInteger saveAccount = 0;
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSLog(@"acloudDownLDataWithAccount %@  %@",responseMsg,error);
        if (error) {
            callback(error.localizedDescription);
            return ;
        }
        ACObject *backObject = [responseMsg getACObject:@"data"];
        NSInteger backAccount = [[backObject getKeys] count];
        NSMutableArray *spArr = [(NSMutableArray *)[backObject get:@"sport_list"] mutableCopy];
        NSMutableArray *slArr = [(NSMutableArray *)[backObject get:@"sleep_list"] mutableCopy];
        NSMutableArray *hrArr = [(NSMutableArray *)[backObject get:@"rate_list"] mutableCopy];
        NSMutableArray *alArr = [(NSMutableArray *)[backObject get:@"alarm_list"] mutableCopy];
        ACObject *sedentObject = [backObject getACObject:@"sedentariness_settings"];
        ACObject *hrObject = [backObject getACObject:@"heart_rate_settings"];
        if (backAccount == 0) {
             callback(@"finish");
        }
        if (sedentObject) {
            saveAccount ++;
            [SMAWebDataHandleInfo saveWebSedentarinessSetObject:sedentObject];
            if (saveAccount == backAccount) {
                callback(@"finish");
            }
        }
        if (hrObject) {
            saveAccount ++;
            [SMAWebDataHandleInfo saveWebHeartRateSetObject:hrObject];
            if (saveAccount == backAccount) {
                callback(@"finish");
            }

        }
        if (spArr.count > 0) {
            [SMAWebDataHandleInfo updateSPData:spArr finish:^(id finish) {
                NSLog(@"spArr===%@",finish);
                saveAccount ++;
                if (saveAccount == backAccount) {
                    callback(@"finish");
                }
            }];
        }
        if (slArr.count > 0) {
            [SMAWebDataHandleInfo updateSLData:slArr finish:^(id finish) {
                NSLog(@"slArr===%@",finish);
                saveAccount ++;
                if (saveAccount == backAccount) {
                    callback(@"finish");
                }
            }];
        }
        if (hrArr.count > 0) {
            [SMAWebDataHandleInfo updateHRData:hrArr finish:^(id finish) {
                NSLog(@"hrArr===%@",finish);
                saveAccount ++;
                if (saveAccount == backAccount) {
                    callback(@"finish");
                }
            }];
        }
        if (alArr.count > 0) {
            [SMAWebDataHandleInfo updateALData:alArr finish:^(id finish) {
                NSLog(@"alArr===%@",finish);
                saveAccount ++;
                if (saveAccount == backAccount) {
                    callback(@"finish");
                }
            }];
        }
    }];
}

//下载表盘文件
- (void)acloudDownLoadWatchInfos:(NSString *)faceStr offset:(int)offset callBack:(void (^)(NSArray *finish,NSError *error))callback{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name  = @"get_watch_faces";
    [msg put:@"data" value:faceStr];
    [msg putInteger:@"offset" value:offset];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSArray *array = [responseMsg getArray:@"data"];
        callback(array,error);
    }];
}

//获取固件版本信息
- (void)acloudDfuFileWithFirmwareType:(NSString *)type callBack:(void (^)(NSArray *finish,NSError *error))callback{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name  = type;
//    [msg put:@"data" value:faceStr];
//    [msg putInteger:@"offset" value:offset];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSArray *array = [responseMsg getArray:@"data"];
        callback(array,error);
    }];

}

//根据表盘id获取缩略图
- (void)acloudDownLoadImageWithOffset:(int)offset callBack:(void (^)(id finish))callback{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"get_watch_face_thumbnail";
    [msg putInteger:@"offset" value:offset];
    [ACloudLib sendToService:service serviceName:servicename version:versionInteger msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            NSDictionary *diction = [[responseMsg getArray:@"data"] firstObject];
            callback (diction);
        }
    }];
}

//获取升级文件数据
- (void)acloudDownloadDfuWithcallBack:(void (^)(id finish))callback{
    
}

//意见反馈
- (void)acloudFeedbackContact:(NSString *)contact content:(NSString *)content callBack:(void (^)(BOOL isSuccess, NSError *error))callback{
    ACFeedBack *feedback = [[ACFeedBack alloc] init];
//    feedback.subDomain = @"watch";
    //1.手机系统版本：9.1
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
   // 2.手机类型：iPhone 6
    NSString* phoneModel = [self iphoneType];//方法在下面
    
    //3.手机系统：iPhone OS
    NSString * iponeM = [[UIDevice currentDevice] systemName];
    
    //4.app版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    [feedback addFeedBackWithKey:@"contact_way" value:contact];
    [feedback addFeedBackWithKey:@"content" value:[NSString stringWithFormat:@"[SMA CARE][%@][Ph Ver]%@[Ph Model]%@[App Ver]%@[Firm name]%@[Firm Ver]%@[Content]%@",iponeM,phoneVersion,phoneModel,appVersion,[SMAAccountTool userInfo].scnaName,[SMAAccountTool userInfo].watchVersion,content]];
    [ACFeedBackManager submitFeedBack:feedback callback:^(BOOL isSuccess, NSError *error) {
        callback(isSuccess,error);
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

- (void)acloudSetScore:(int)score{
    [ACRankingManager setScore:score forName:@"china" withTimestamp:0 callback:^(NSError *error) {
        NSLog(@"上传排行榜  %@",error);
        if (error) {
            //插入失败
            return;
        }
        //插入成功
    }];
}

//获取所有用户步数及排行
- (void)acloudCheckRankingCallBack:(void(^)(NSMutableArray *lis,NSError *error))callback{
    NSMutableArray *listArr = [NSMutableArray array];
    [ACRankingManager scanWithName:@"china" period:ACRankingPeriodDay timestamp:0 startRank:1 endRank:10 order:ACRankingOrderDESC callback:^(NSArray<ACRankingValue *> *list, NSError *error) {
        if (error) {   //错误处理
            if (callback) {
                callback([list mutableCopy],error);
                return;
            }
        }
        for (int i = 0; i < list.count; i ++) {
            ACRankingValue *value = [list objectAtIndex:i];
            NSString *icon_url = [value.profile getString:@"_avatar"] ? [value.profile getString:@"_avatar"]:@"";
            NSString *nickName = [value.profile getString:@"nick_name"] ? [value.profile getString:@"nick_name"]:@"";
            double score = value.score;
            long place = value.place;
            __block NSDictionary *rankDic;
            NSLog(@"fwgfwgg==%@  %@",[NSNumber numberWithDouble:score],[NSNumber numberWithLong:place]);
            rankDic = [NSDictionary dictionaryWithObjectsAndKeys:nickName,@"NAME",icon_url,@"IMAGE",[NSNumber numberWithDouble:score],@"SCORE",[NSNumber numberWithLong:place],@"PLACE", nil];
            [listArr addObject:rankDic];
        }
        callback(listArr,nil);
    }];
}

//
//整理接收用户信息
- (NSMutableDictionary *)userDataWithACmsg:(ACObject *)responseMsg{
    if (![responseMsg isEqual:@"none"]) {
        NSMutableArray  *quietDaArr = [NSMutableArray array];
        [quietDaArr addObject:@[@"hearRate_quiet_last",@"hearReat_quietTitle"]];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy.MM.dd";
        NSString *str = [fmt stringFromDate:[NSDate date]];
        [quietDaArr addObject:@[str,[NSString stringWithFormat:@"%ld bpm",[responseMsg getLong:user_rate]]]];
        //        [SMADefaultinfos putKey:@"quietDaArr" andValue:quietDaArr];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_hi]] forKey:user_hi];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_we]] forKey:user_we];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_sex]] forKey:user_sex];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_age]] forKey:user_age];
        [userInfoDic setValue:[NSString stringWithFormat:@"%@",[responseMsg getString:user_he]] forKey:user_he];
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
            NSDictionary *parameters = @{@"device_num":@"1",@"device_list":@[@{@"id":deviceid,@"mac":(NSString *)[[SMADefaultinfos getValueforKey:DEVICEMAC] stringByReplacingOccurrencesOfString:@":" withString:@""],@"connect_protocol":@"3",@"auth_key":@"1234567890ABCDEF1234567890ABCDEF",@"close_strategy":@"1",@"conn_strategy":@"1",@"crypt_method":@"1",@"auth_ver":@"1",@"manu_mac_pos":@"-1",@"ser_mac_pos":@"-2",@"ble_simple_protocol":@"1"}],@"op_type":@"1"};
            
            [manager POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/device/authorize_device?access_token=%@",tocken] parameters:parameters
                  success:^(NSURLSessionDataTask *operation,id responseObject) {
                      
                      NSLog(@"Success: %@  %@", responseObject,[[[responseObject objectForKey:@"resp"] firstObject] objectForKey:@"errmsg"]);
                      NSArray *arr = [responseObject objectForKey:@"resp"];
                      if (arr.count > 0) {
                          if([[[[responseObject objectForKey:@"resp"] firstObject] objectForKey:@"errmsg"]isEqualToString:@"ok"])
                              //                              [SmaUserDefaults setBool:YES forKey:@"weChat"];
                              [self uploadMACWithAccount:@"" MAC:[SMADefaultinfos getValueforKey:DEVICEMAC] watchType:[SMADefaultinfos getValueforKey:BANDDEVELIVE] success:^(id success) {
                                  
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

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

@end
