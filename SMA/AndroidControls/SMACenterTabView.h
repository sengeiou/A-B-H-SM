//
//  SMACenterTabView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBlock)(NSIndexPath *indexPath);

@interface SMACenterTabView : UIView<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithMessages:(NSArray *)message selectMessage:(NSString *)select selName:(NSString *)selImaName;
- (void)tabViewDidSelectRow:(MyBlock)callBack;
@end
