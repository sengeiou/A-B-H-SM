//
//  SmaQuietView.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol smaQuietViewDelegate <NSObject>
- (void)keyboardWillShow;
- (void)keyboardWillHide;
- (void)cancelWithBut:(UIButton *)sender;
- (void)confirmWithBut:(UIButton *)sender;
@end
@interface SmaQuietView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLab ,*dateLab, *unitLab;
@property (nonatomic, strong) UITextField *quietField;
@property (nonatomic, strong) UIButton *cancleBut, *confirmBut;
@property (nonatomic, weak) id<smaQuietViewDelegate> delegate;
- (void)createUI;
@end
