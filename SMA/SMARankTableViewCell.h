//
//  SMARankTableViewCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/16.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMARankTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *rankBut;
@property (nonatomic, weak) IBOutlet UIImageView *rankIma;
@property (nonatomic, weak) IBOutlet UILabel *nameLab, *stepsLab;
- (void)setrankList:(NSMutableArray *)list;
@end
