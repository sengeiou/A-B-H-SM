//
//  SMAPolyline.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAPolyline.h"

@implementation SMAPolyline

//需要配置边界范围，否则默认的会引起边界出现阴影，原因大概是由于边界过小引起
-(MKMapRect)boundingMapRect{
    MKMapPoint origin;
    origin.x = 187413395.90200892;
    origin.y = 68232832.391458735;
    MKMapSize size = MKMapSizeWorld;
    size.width =67108864;
    size.height = 67108864.000000015;
    MKMapRect boundingMapRect = (MKMapRect) {origin, size};
    
    return boundingMapRect;
}
@end
