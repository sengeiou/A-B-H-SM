//
//  SMAWatchCollectionCell.m
//  ViewFrameDemo
//
//  Created by 有限公司 深圳市 on 2016/12/7.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import "SMAWatchCollectionCell.h"

@implementation SMAWatchCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale =  [UIScreen mainScreen].scale;
    self.layer.opaque = YES;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(5.0f, -5.0f);
    self.layer.shadowOpacity = 0.5f;
}

- (void)setWatchDic:(NSDictionary *)watchDic{
    _watchDic = watchDic;
    if (_watchDic) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",watchDic[@"filename"]]];
            NSData *data = [NSData dataWithContentsOfFile:uniquePath];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if (!img) {
                SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
                web.chaImageName = [NSString stringWithFormat:@"%@.png",watchDic[@"filename"]];
                [web acloudDownFileWithsession:[watchDic objectForKey:@"thumbnailUrl"] callBack:^(float progress, NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.switchView.image = [UIImage imageNamed:@"img_moren"];
                        });
                    }
                } CompleteCallback:^(NSString *filePath) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSData *data = [NSData dataWithContentsOfFile:filePath];
                        if (data) {
                            self.switchView.image = [[UIImage alloc] initWithData:data];
                        }
                        else{
                            self.switchView.image = [UIImage imageNamed:@"img_moren"];
                        }
                    });
                }];
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.switchView.image = img;
                });
            }
        });
    }
}
@end
