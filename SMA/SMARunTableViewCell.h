//
//  SMARunTableViewCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMARunTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *beginLab, *beginDeLab, *endLab, *endDeLab,*disLab, *disDeLab, *perLab, *perDeLab;
@property (nonatomic, weak) IBOutlet UIImageView *perImageView, *disImageView;
- (void)createUIWithData:(NSMutableDictionary *)dataDic;
- (void)createUIWithCylingData:(NSMutableDictionary *)dataDic;
@end

