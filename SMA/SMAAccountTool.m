//
//  SMAAccountTool.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAccountTool.h"
#import "SMAUserInfo.h"
#import "SmaHRHisInfo.h"
@implementation SMAAccountTool
/*用户登录归档文件 */
#define SmaAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
#define SmaHRHisFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hrHist.data"]
+ (void)saveUser:(SMAUserInfo *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:SmaAccountFile];
}

+ (SMAUserInfo *)userInfo
{
    SMAUserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:SmaAccountFile];
    return account;
}

+ (void)saveHRHis:(SmaHRHisInfo *)HRHisInfo
{
    [NSKeyedArchiver archiveRootObject:HRHisInfo toFile:SmaHRHisFile];
}

+ (SmaHRHisInfo *)HRHisInfo
{
    SmaHRHisInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:SmaHRHisFile];
    return account;
}
@end
