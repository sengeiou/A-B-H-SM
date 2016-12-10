//
//  SMAPickerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMAPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
typedef void (^cancelButton)(UIButton *canBut);
typedef void (^confiButton)(NSInteger okBut);
typedef void (^pickerSelectRow)(NSInteger row,NSInteger component);
@property (nonatomic, copy) cancelButton cancel;
@property (nonatomic, copy) confiButton confirm;
@property (nonatomic, copy) pickerSelectRow row;
@property (nonatomic, strong) UIPickerView *pickView;
- (id)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)titles ickerMessage:(NSArray *)mesArr;
@end
