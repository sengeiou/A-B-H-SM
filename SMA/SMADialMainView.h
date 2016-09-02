//
//  SMADialMainView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADialView.h"
@protocol smaDialViewDelegate<NSObject>
- (void) moveViewFinish:(NSString *)selectTit;
@end
@interface SMADialMainView : UIView
@property (nonatomic, strong) SMADialView *dialView;
@property (nonatomic, weak) id<smaDialViewDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray *dialText;
@property (nonatomic, assign) int patientiaDial;
@end
