//
//  SMATrackDetailView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^pushAction)(UIButton *pushBut);
typedef void (^gestureAction)(BOOL gesture);
@interface SMATrackDetailView : UIView
@property(nonatomic,copy)pushAction block;
@property(nonatomic,copy)gestureAction blgestureBock;
+ (instancetype)initializeView;
- (void)updateUIwithData:(NSMutableDictionary *)dic;

- (void)tapPushBut:(pushAction)action;
- (void)tapGesture:(gestureAction)action;
- (void)tapAction:(UITapGestureRecognizer *)sender;
@end
