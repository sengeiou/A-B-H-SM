//
//  SMARepeatCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^tapButton)(NSString *weekStr);
@interface SMARepeatCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *repeatLab;
@property (nonatomic, weak) IBOutlet UIButton *monBut, *tueBut, *wedBut, *thuBut, *firBut, *satBut, *sunBut;
- (void)weekStrConvert:(NSString *)weekStr;
@property(nonatomic,copy)tapButton repeatBlock;

@end
