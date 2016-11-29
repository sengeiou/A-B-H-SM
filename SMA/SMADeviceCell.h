//
//  SMADeviceCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMADeviceCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *peripheralName;
@property (nonatomic, strong) IBOutlet UILabel *UUID;
@property (nonatomic, strong) IBOutlet UILabel *RSSI;
@property (nonatomic, weak) IBOutlet UIImageView *rrsiIma;
@end
