//
//  SMAMKMapView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/2/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAMKMapView.h"
#define MERCATOR_RADIUS 85445659.44705395 

@interface SMAMKMapView ()
@property (nonatomic, strong) NSMutableArray *polyliones;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, assign) int imageIndex;
@end

@implementation SMAMKMapView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _polyliones = [NSMutableArray array];
    _mapAnnotations = [NSMutableArray array];
    self.rotateEnabled = NO;
    self.delegate = self;
//    MKCoordinateRegion MKCoordinateRegionForMapRect(MKMapRect rect);
}

- (void)removeOverlayView{
    [self removeOverlays:_polyliones];
    [_polyliones removeAllObjects];
}

- (void)removeAnnotionsView{
    [self removeAnnotations:_mapAnnotations];
     [_mapAnnotations removeAllObjects];
}

//绘制轨迹
- (void)drawOverlayWithPoints:(NSMutableArray *)points{
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i ++) {//若坐标量少于2个，会引起地图出现一片红色区域，原因不明
        NSMutableArray *detailPoints = [points objectAtIndex:i];
        CLLocationCoordinate2D commonPolylineCoordss[detailPoints.count];
        for (int j = 0; j < detailPoints.count; j ++) {
            NSDictionary *locationDic = detailPoints[j];
            commonPolylineCoordss[j].latitude = [locationDic[@"LATITUDE"] doubleValue];
            commonPolylineCoordss[j].longitude = [locationDic[@"LONGITUDE"] doubleValue];
            CLLocationCoordinate2D code;
            code.latitude = [locationDic[@"LATITUDE"] doubleValue];
            code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
            MKMapPoint annotationPoint = MKMapPointForCoordinate(code);
            MKMapRect rect1 = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = rect1;
                
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect1);
            }
        }
        SMAPolyline *routeLine = [SMAPolyline polylineWithCoordinates:commonPolylineCoordss count:detailPoints.count];
        [_polyliones addObject:routeLine];
    }
     [self addOverlays:_polyliones];
    [self updateMapviewVisibleRegionWithPoints:points];
}

- (void)addAnnotationsWithPoints:(NSMutableArray *)points{
    _imageIndex = 0;
    for (int i = 0; i < points.count; i ++) {
//        PointAnnotation *annation=[[PointAnnotation alloc]init];
//        [_mapAnnotations addObject:annation];
            NSDictionary *locationDic = points[i];
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D code;
            code.latitude = [locationDic[@"LATITUDE"] doubleValue];
            code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
            point.coordinate = code;
            [_mapAnnotations addObject:point];
    }
    [self addAnnotations:_mapAnnotations];
}

//配置地图轨迹所有的点，计算地图显示轨迹区域
- (void)updateMapviewVisibleRegionWithPoints:(NSMutableArray *)points{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i ++) {//若坐标量少于2个，会引起地图出现一片红色区域，原因不明
        NSMutableArray *detailPoints = [points objectAtIndex:i];
        for (int j = 0; j < detailPoints.count; j ++) {
            NSDictionary *locationDic = detailPoints[j];
            CLLocationCoordinate2D code;
            code.latitude = [locationDic[@"LATITUDE"] doubleValue];
            code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
            MKMapPoint annotationPoint = MKMapPointForCoordinate(code);
            MKMapRect rect1 = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = rect1;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect1);
            }
        }
}
    zoomRect = [self mapRectThatFits:zoomRect];
    [self setVisibleMapRect:zoomRect animated:YES];
    
    int zoomlevel = [self getZoomLevel:self];
    //由于计算出区域刚好覆盖显示区域，所以需要进行调整
    NSLog(@"fwgeheh==%f  %f   %f",[self getZoomLevel:self],self.centerCoordinate.latitude ,self.centerCoordinate.longitude);
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomlevel > 2 ? (zoomlevel- 2) : zoomlevel animated:YES];
}

- (float)getZoomLevel:(MKMapView*)_mapView {
    return 21 - round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width)));
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if([overlay isKindOfClass:[SMAPolyline class]]){
        //轨迹
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 3.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:54/255.0 green:153/255.0 blue:230/255.0 alpha:1];
        return polylineRenderer;
    }
    return nil;
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *ID = @"anno";
    // 如果返回nil，系统会按照默认方式显示，如果自定义，是无法直接显示的，并且点击大头针之后不会显示标题，需要自己手动设置显示
    // 如果想要直接显示，应该调用MKPinAnnotationView
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        // 大头针属性
        //annoView.animatesDrop = YES; // MKPinAnnotaionView才有效，设置大头针坠落的动画
         annoView.centerOffset = CGPointMake(0, -10); // 设置大头针的偏移
        // 设置大头针气泡的左右视图、可以为任意UIView
//        annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        annoView.rightCalloutAccessoryView = [[UISwitch alloc] init];
        //[annoView setPinColor:MKPinAnnotationColorPurple]; // MKPinAnnotaionView才有效，设置大头针的颜色
    }
    
    // 设置大头针的图片
    annoView.image = [_pointImages objectAtIndex:_imageIndex];
    annoView.canShowCallout = YES; // 设置点击大头针是否显示气泡
    NSLog(@"fwgegr==%@", annoView.image);
    annoView.annotation = annotation;
    _imageIndex ++;
    if (_imageIndex == _pointImages.count) {
        _imageIndex = 0;
    }

    
    return annoView;
}
@end
