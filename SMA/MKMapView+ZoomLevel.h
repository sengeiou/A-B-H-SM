//
//  MKMapView+ZoomLevel.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
