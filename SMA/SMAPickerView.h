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
typedef void (^pickerSelectRow)(NSInteger row);
@property (nonatomic, copy) cancelButton cancel;
@property (nonatomic, copy) confiButton confirm;
@property (nonatomic, copy) pickerSelectRow row;
- (id)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)titles ickerMessage:(NSArray *)mesArr;
@end
