//
//  SMADieviceDataCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/5.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDemoItemView.h"
#import "SDProgressView.h"
@interface SMADieviceDataCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titLab, *dialLab, *stypeLab, *detailsTitLab1, *detailsLab1, *detailsTitLab2, *detailsLab2, *detailsTitLab3, *detailsLab3;
@property (nonatomic, weak) IBOutlet UIView *backgrouView;
@property (nonatomic, weak) IBOutlet SDDemoItemView *roundView;
@property (nonatomic, weak) IBOutlet UIImageView *pulldownView,*roundView1, *roundView2, *roundView3;
@end
