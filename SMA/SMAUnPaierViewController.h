//
//  SMAUnPaierViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/25.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMACenterAlerView.h"
@interface SMAUnPaierViewController : UIViewController<cenAlerButDelegate>
@property (nonatomic, weak) IBOutlet UIButton *unPairBut, *dfuBut;
@property (nonatomic, weak) IBOutlet UILabel *dfuVerLab, *verLab;
@property (nonatomic, weak) IBOutlet UIImageView *updateIma;
@property (nonatomic, weak) IBOutlet UIView *unPairView;
@end
