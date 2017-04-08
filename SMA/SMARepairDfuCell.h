//
//  SMARepairDfuCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMARepairDfuCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) BOOL topShow;
@property (nonatomic, assign) BOOL leftpShow;
@property (nonatomic, assign) BOOL bottomShow;
@property (nonatomic, assign) BOOL rightShow;
@end
