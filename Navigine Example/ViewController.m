//
//  ViewController.m
//  Navigine Example
//
//  Created by Pavel Tychinin on 19/07/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (){
    UIBezierPath   *uipath;
    CAShapeLayer   *routeLayer;
}
@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, strong) NavigineCore *navigineCore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _sv.frame = self.view.frame;
    _sv.delegate = self;
    _sv.pinchGestureRecognizer.enabled = YES;
    _sv.minimumZoomScale = 1.f;
    _sv.zoomScale = 1.f;
    _sv.maximumZoomScale = 2.f;
    [_sv addSubview:_imageView];
    _navigineCore = [[NavigineCore alloc] initWithUserHash: @"1385-6098-F9A9-6178"
                                                    server: @"https://api.navigine.com"];
    _navigineCore.delegate = self;
    
    // Point on map
    _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _current.backgroundColor = [UIColor redColor];
    _current.layer.cornerRadius = _current.frame.size.height/2.f;
    [_imageView addSubview:_current];
    _imageView.userInteractionEnabled = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(navigationTick:)
                                   userInfo:nil
                                    repeats:YES];
    _isRouting = NO;
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.delaysTouchesBegan   = NO;
    [_sv addGestureRecognizer:tapPress];
    
    [_navigineCore downloadLocationById:1783
                            forceReload:true
                           processBlock:^(NSInteger loadProcess) {
//                               NSLog(@"%zd",loadProcess);
                           } successBlock:^(NSDictionary *userInfo) {
                               [self setupNavigine];
                           } failBlock:^(NSError *error) {
                               NSLog(@"%@",error);
                           }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navigationTick: (NSTimer *)timer {
    NCDeviceInfo *res = _navigineCore.deviceInfo;
    if (res.error.code == 0) {
//        NSLog(@"RESULT: %lf %lf", res.x, res.y);
        _current.hidden = NO;
        _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                      _imageView.height / _sv.zoomScale * (1. - res.ky));
    }
    else {
        _current.hidden = YES;
//        NSLog(@"Error code:%zd",res.error.code);
    }
    if (_isRouting) {
        NCRoutePath *devicePath = res.paths.firstObject;
        NSArray *path = devicePath.points;
        float distance = devicePath.lenght;
        [self drawRouteWithPath:path andDistance:distance];
    }
}

-(void) drawRouteWithPath: (NSArray *)path
              andDistance: (float)distance {
    //    // We check that we are close to the finish point of the route
    if (distance <= 3.) {
        [self stopRoute];
    }
    else {
        [routeLayer removeFromSuperlayer];
        [uipath removeAllPoints];
        
        uipath     = [[UIBezierPath alloc] init];
        routeLayer = [CAShapeLayer layer];
        
        for (int i = 0; i < path.count; i++ ) {
            NCVertex *vertex = path[i];
            NCSublocation *sublocation = _navigineCore.location.sublocations[0];
            CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
            
            CGFloat xPoint =  (vertex.x.doubleValue / imageSizeInMeters.width) * (_imageView.width / _sv.zoomScale);
            CGFloat yPoint =  (1. - vertex.y.doubleValue / imageSizeInMeters.height)  * (_imageView.height / _sv.zoomScale);
            if(i == 0) {
                [uipath moveToPoint:CGPointMake(xPoint, yPoint)];
            }
            else {
                [uipath addLineToPoint:CGPointMake(xPoint, yPoint)];
            }
        }
    }
    routeLayer.hidden = NO;
    routeLayer.path            = [uipath CGPath];
    routeLayer.strokeColor     = [kColorFromHex(0x4AADD4) CGColor];
    routeLayer.lineWidth       = 2.0;
    routeLayer.lineJoin        = kCALineJoinRound;
    routeLayer.fillColor       = [[UIColor clearColor] CGColor];
    
    [_imageView.layer addSublayer:routeLayer];
    [_imageView bringSubviewToFront:_current];
}

- (void)addPinToMapWithVenue:(NCVenue *)v andImage:(UIImage *)image{
    CGFloat xPoint = v.kX.doubleValue * _imageView.width;
    CGFloat yPoint = (1. - v.kY.doubleValue) * _imageView.height;
    
    CGPoint point = CGPointMake(xPoint, yPoint);
    MapPin *mapPin = [[MapPin alloc] initWithVenue:v];
    [mapPin setImage:image forState:UIControlStateNormal];
    [mapPin setImage:image forState:UIControlStateHighlighted];
    [mapPin addTarget:self action:@selector(mapPinPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapPin sizeToFit];
    [_imageView addSubview:mapPin];
    [_sv bringSubviewToFront:mapPin];
    
    mapPin.center  = point;
}

- (void)mapPinPressed:(id)sender {
    MapPin *mapPin = (MapPin *)sender;
    [_pressedPin.popUp removeFromSuperview];
    _pressedPin.popUp.hidden = YES;
    
    _pressedPin = mapPin;
    [_imageView addSubview:mapPin.popUp];
    mapPin.popUp.hidden = NO;
    
    mapPin.popUp.bottom   = mapPin.top - 9.0f;
    mapPin.popUp.centerX  = mapPin.centerX;
    
    [mapPin.popUp addTarget:self action:@selector(popUpPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popUpPressed:(id)sender {
    NCDeviceInfo *res = _navigineCore.deviceInfo;
    NCSublocation *sublocation = _navigineCore.location.sublocations[0];
    CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
    CGFloat xPoint = _pressedPin.centerX /_imageView.width * imageSizeInMeters.width;
    CGFloat yPoint = (1. - _pressedPin.centerY /_imageView.height) * imageSizeInMeters.height;
    NCVertex *vertex = [[NCVertex alloc] init];
    vertex.sublocation = res.subLocation;
    vertex.x = @(xPoint);
    vertex.y = @(yPoint);
    [_navigineCore addTatget:vertex];
    [_pressedPin.popUp removeFromSuperview];
    _pressedPin.popUp.hidden = YES;
    _isRouting = YES;
}

- (void)stopRoute {
    _isRouting = NO;
    
    [routeLayer removeFromSuperlayer];
    routeLayer = nil;
    
    [uipath removeAllPoints];
    uipath = nil;
    [_navigineCore cancelTargets];
}

- (void)tapPress:(UITapGestureRecognizer *)gesture {
    [_pressedPin.popUp removeFromSuperview];
    _pressedPin.popUp.hidden = YES;
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

#pragma mark NavigineCoreDelegate methods

- (void) didRangePushWithTitle:(NSString *)title
                       content:(NSString *)content
                         image:(NSString *)image
                            id:(NSInteger)id{
    // Your code
}

-(void) setupNavigine {
    [_navigineCore startNavigine];
    [_navigineCore startPushManager];
    
    [_imageView removeAllSubviews];
    _imageView.layer.sublayers = nil;
    [_imageView addSubview:_current];
//    [self presentViewController:_navigineCore.location.viewController animated:YES completion:nil];
    
    NCLocation *location = _navigineCore.location;
    NCSublocation *sublocation = location.sublocations[0];
    
    NSData *imageData = sublocation.pngImage;
    UIImage *image = [UIImage imageWithData:imageData];
    
    float scale = 1.f;
    if (image.size.width / image.size.height >
        self.view.frame.size.width / self.view.frame.size.height) {
        scale = self.view.frame.size.height / image.size.height;
    }
    else {
        scale = self.view.frame.size.width / image.size.width;
    }
    _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
    _imageView.image = image;
    _sv.contentSize = _imageView.frame.size;
    [self drawZones];
}

- (void) drawZones {
    NCSublocation *sublocation = _navigineCore.location.sublocations[0];
    NSArray *zones = sublocation.zones;
    for (NCZone *zone in zones) {
        UIBezierPath *zonePath     = [[UIBezierPath alloc] init];
        CAShapeLayer *zoneLayer = [CAShapeLayer layer];
        NSArray *points = zone.points;
        NCVertex *point0 = points[0];
        [zonePath moveToPoint:CGPointMake(_imageView.width * point0.kX.doubleValue,
                                          _imageView.height * (1. - point0.kY.doubleValue))];
        for (NCVertex *point in zone.points) {
                [zonePath addLineToPoint:CGPointMake(_imageView.width * point.kX.doubleValue,
                                                     _imageView.height * (1. - point.kY.doubleValue))];
        }
        [zonePath addLineToPoint:CGPointMake(_imageView.width * point0.kX.doubleValue,
                                             _imageView.height *(1. - point0.kY.doubleValue))];
        unsigned int result = 0;
        NSScanner *scanner = [NSScanner scannerWithString:zone.color];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&result];
        
        zoneLayer.hidden = NO;
        zoneLayer.path            = [zonePath CGPath];
        zoneLayer.strokeColor     = [kColorFromHex(result) CGColor];
        zoneLayer.lineWidth       = 2.0;
        zoneLayer.lineJoin        = kCALineJoinRound;
        zoneLayer.fillColor       = [[kColorFromHex(result) colorWithAlphaComponent:0.5] CGColor];
        
        [_imageView.layer addSublayer:zoneLayer];
    }
}
@end
