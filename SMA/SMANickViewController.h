//
//  SMANickViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMABottomSelView.h"
#import "AppDelegate.h"
@interface SMANickViewController : UIViewController<tapSelectCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *photoBut, *nextBut;
@property (nonatomic, weak) IBOutlet UILabel *nickLab, *setPhoLab;
@property (nonatomic, weak) IBOutlet UITextField *nameFie;
@end
