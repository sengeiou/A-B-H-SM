//
//  SMASedentEditCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMASedentEditCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIButton *editBut,*deleBut,*pushBut;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *timeLab, *titleLab, *weakLab;
@property (nonatomic, weak) IBOutlet UISwitch *alarmSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *accessoryIma;
@property (nonatomic, assign) BOOL edit;
@end
