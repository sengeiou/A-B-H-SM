//
//  SMABottomPickView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMABottomPickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
typedef void (^cancelButton)(UIButton *canBut);
typedef void (^confiButton)(UIButton * confiBut);
typedef void (^pickerSelectRow)(NSInteger row,NSInteger component);
@property (nonatomic, strong) UIPickerView *pickView;
//@property (nonatomic, copy) 
- (instancetype)initWithTitles:(NSArray *)titles describes:(NSArray *)describe buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr;
- (void)selectConfirm:(confiButton)confirmBlock;
- (void)pickSelectCallBack:(pickerSelectRow)callBack;
@end
