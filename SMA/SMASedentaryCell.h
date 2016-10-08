//
//  SMASedentaryCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/26.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^touchSwit)(UISwitch *swit);
@interface SMASedentaryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *amLab, *pmLab, *repeatLab, *weekLab;
@property (nonatomic, weak) IBOutlet UISwitch *sedSwitch;
@property(nonatomic,copy)touchSwit block;
@end
