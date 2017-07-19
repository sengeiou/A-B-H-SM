//
//  SMASportStypeView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMASportStypeView : UIView
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSMutableArray *leftTits;//左则标注
@property (nonatomic, strong) NSArray *YleftTits;//左则坐标标注
@property (nonatomic, strong) NSMutableArray *rightTits;//左则标注
@property (nonatomic, strong) NSArray *XbottomTits;//底部坐标标注
@property (nonatomic, strong) NSMutableArray *hrDatas;//心率数据
@property (strong, nonatomic) NSDictionary *textStyleDict;
@end
