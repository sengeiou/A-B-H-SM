//
//  SMAthirdPartyLoginTool.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAthirdPartyLoginTool.h"

static SMAthirdPartyLoginTool *g_instance = nil;
@interface SMAthirdPartyLoginTool ()

@end
@implementation SMAthirdPartyLoginTool
@synthesize oauth = _oauth;

+ (SMAthirdPartyLoginTool *)getinstance
{
    @synchronized(self)
    {
        if (nil == g_instance)
        {
            //g_instance = [[sdkCall alloc] init];
            g_instance = [[super allocWithZone:nil] init];
//            [g_instance setPhotos:[NSMutableArray arrayWithCapacity:1]];
//            [g_instance setThumbPhotos:[NSMutableArray arrayWithCapacity:1]];
        }
    }
    
    return g_instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getinstance];
}

- (id)init
{
    NSString *appid = __TencentDemoAppid_;
    _oauth = [[TencentOAuth alloc] initWithAppId:appid
                                     andDelegate:[SMAthirdPartyManager sharedManager]];
    
    return self;
}

+ (void)resetSDK
{
    g_instance = nil;
}

- (BOOL)QQlogin{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
   return [_oauth authorize:permissions];
}

- (BOOL)iphoneQQInstalled{
  return [TencentOAuth iphoneQQInstalled];
}

- (void)shareToQQShareImage:(UIImage *)image{
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:@"title"
                                                   description :@"description"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}

- (void)shareToQZoneShareImage:(UIImage *)image{
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[imgData] title:nil];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}

- (BOOL)WeChatLoginController:(UIViewController *)viewController{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = WXauthScope;
    req.state = WXauthState;
    req.openID = WXauthOpenId;
    return [WXApi sendAuthReq:req viewController:viewController delegate:[SMAthirdPartyManager sharedManager]];
}

- (BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

- (BOOL)shareToWeChatScene:(int)scene shareImage:(UIImage *)image{
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1);
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    /**< 聊天界面    0*/
    /**< 朋友圈      1*/
    /**< 收藏       2*/
    req.scene = scene;
   return [WXApi sendReq:req];
}

- (BOOL)isWBAppInstalled{
    return [WeiboSDK isWeiboAppInstalled];
}

- (BOOL)WeiboLogin{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
   return [WeiboSDK sendRequest:request];
}

- (BOOL)shareToWBWithShareImage:(UIImage *)image{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
     WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    return [WeiboSDK sendRequest:request];
}

- (void)shareToTwitterWithShareImage:(UIImage *)image controller:(UIViewController *)vc{
     SLComposeViewController *composeVc = (SLComposeViewController *)[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] || !composeVc) {
        [MBProgressHUD showError:SMALocalizedString(@"device_share_TWNOInsta")];
        NSLog(@"平台不可用,或者没有配置相关的帐号");
        return;
    }
   
    composeVc.view.backgroundColor = [UIColor greenColor];
    // 2.1.添加分享的文字
//    [composeVc setInitialText:@"测试系统分享"];
    
    // 2.2.添加一个图片
    [composeVc addImage:image];
    
    // 2.3.添加一个分享的链接,分享链接时要加上http协议头
//    [composeVc addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [vc presentViewController:composeVc animated:YES completion:^{
        
    }];

}

- (void)shareToFacebookWithShareImage:(UIImage *)image controller:(UIViewController *)vc{
    FBSDKShareDialog *facebookShareDialog = [[FBSDKShareDialog alloc] init];
    if ([facebookShareDialog canShow]) {
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        [FBSDKShareDialog showFromViewController:vc withContent:content  delegate:self];
    }
}

- (void)shareToInstagramWithShareImage:(UIImage *)image controller:(UIViewController *)vc{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"instagram:"]]){
        UIImage *imageToUse = image;
        NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.igo"];
        NSData *imageData=UIImagePNGRepresentation(imageToUse);
        [imageData writeToFile:saveImagePath atomically:YES];
        NSURL *imageURL=[NSURL fileURLWithPath:saveImagePath];
        self.documentInteractionController=[[UIDocumentInteractionController alloc]init];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageURL];
        self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectMake(1, 1, 1, 1) inView:vc.view animated:YES];
    } else {
        [MBProgressHUD showError:SMALocalizedString(@"device_share_INNOInsta")];
    }
}


#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"**********completed share:%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"************%ld sharing error:%@",error.code, error.localizedDescription);
    if (error.code == 2) {
        [MBProgressHUD showError:SMALocalizedString(@"device_share_FBNOInsta")];
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"***************share cancelled");
}
@end
