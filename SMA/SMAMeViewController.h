//
//  SMAMeViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+CKQ.h"
#import "SMAPhotoSelectView.h"
#import "SMACenterAlerView.h"
#import "SMAHelpViewController.h"
#import "SMARepairDfuCollectionController.h"
@interface SMAMeViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,BLConnectDelegate,cenAlerButDelegate>
@property (nonatomic, weak) IBOutlet UILabel *nicknameLab, *personalLab, *goalLab, *moreLab, *pairDfuLab, *helpLab, *signOutLab;
@property (nonatomic, weak) IBOutlet UIButton *photoBut;
@property (nonatomic, weak) IBOutlet UIImageView *photoIma;
@end
