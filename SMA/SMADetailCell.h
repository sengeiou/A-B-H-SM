//
//  SMADetailCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMADetailCell : UITableViewCell
@property (nonatomic, strong) CALayer *topLine, *botLine;
@property (nonatomic, strong) CAShapeLayer *oval;
@property (nonatomic, weak) IBOutlet UILabel *timeLab, *statelab, *distanceLab;
@property (nonatomic, weak) IBOutlet UIImageView *stateIma;
@end
