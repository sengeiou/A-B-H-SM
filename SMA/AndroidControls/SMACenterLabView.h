//
//  SMACenterLabView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBlock)(UIButton *but, NSString *titleStr);
typedef void (^pickBlock)(NSInteger row, NSInteger component);
@interface SMACenterLabView : UIView<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UITextField *tableField;
@property (nonatomic, strong) UIPickerView *pickView;
- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons;
- (instancetype)initWithPickTitle:(NSString *)title buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr;
- (void)lableDidSelectRow:(MyBlock)callBack;
- (void)pickDidSelectRow:(pickBlock)callBack;
@end
