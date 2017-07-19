//
//  SMAMKMapView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SMAPolyline.h"
#import "MKMapView+ZoomLevel.h"
//#import "PointAnnotation.h"
@interface SMAMKMapView : MKMapView<MKMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *pointImages;
- (void)drawOverlayWithPoints:(NSMutableArray *)points;
- (void)addAnnotationsWithPoints:(NSMutableArray *)points;
@end
