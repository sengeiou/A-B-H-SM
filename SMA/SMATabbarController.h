//
//  SMATabbarController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMATabbarController : UITabBarController<UITabBarControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong)  UIImagePickerController *picker;
@end
