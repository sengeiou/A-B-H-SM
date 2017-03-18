//
//  SMADfuViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADfuButton.h"
#import "SMADfuView.h"
@interface SMADfuViewController : UIViewController<BLConnectDelegate,DfuUpdateDelegate>
@property (nonatomic, weak) IBOutlet UIButton *dfuBut;
@property (nonatomic, weak) IBOutlet UILabel *remindLab, *nowVerTitLab, *nowVerLab, *dfuVerTitLab, *dfuVerLab, *upDfuVerTitLab, *upDfuVerLab, *dfuLab;
@property (nonatomic, weak) IBOutlet UIView *backView, *dfu, *upVerView;
@property (nonatomic, weak) IBOutlet UITextView *repairTextView;
@property (nonatomic, weak) IBOutlet SMADfuView *dfuView;
@property (nonatomic, strong) NSString *dfuVersion;
@property (nonatomic, strong) NSDictionary *dfuInfoDic;
@property (nonatomic, strong) CBPeripheral *epairPeripheral;
@property (nonatomic, strong) NSString *repairBleCustom;
@property (nonatomic, strong) NSString *repairDeviceName;
@end
