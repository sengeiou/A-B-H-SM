//
//  SMARankTableViewCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/16.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARankTableViewCell.h"

@implementation SMARankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}

- (void)createUI{
//    _rankIma.layer.shouldRasterize = YES;
//    _rankIma.layer.rasterizationScale =  [UIScreen mainScreen].scale;
    _rankIma.layer.masksToBounds = YES;
    _rankIma.layer.cornerRadius = 18.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setrankList:(NSDictionary *)list{
    SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [web acloudDownFileWithsession:[list objectForKey:@"IMAGE"] callBack:^(float progress, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rankIma.image = [UIImage imageNamed:@"img_head"];
                });
            }
        } CompleteCallback:^(NSString *filePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            self.rankIma.image = [[UIImage alloc] initWithData:data];
          });
        }];

    });
    self.nameLab.text = [list objectForKey:@"NAME"];
    self.stepsLab.text = [NSString stringWithFormat:@"%d%@",[[list objectForKey:@"SCORE"] intValue],[[list objectForKey:@"SCORE"] intValue] > 1 ? SMALocalizedString(@"device_SP_steps"):SMALocalizedString(@"device_SP_step")];
}

@end
