//
//  SMAPolyline.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SMAPolyline : MKPolyline
@property (copy, nullable) NSArray<NSNumber *> *lineDashPattern; // defaults to nil
@property (strong, nullable) UIColor *strokeColor;
@end
