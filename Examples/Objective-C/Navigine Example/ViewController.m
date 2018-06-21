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
@property (weak, nonatomic) IBOutlet UIButton *btnIncreaseFloor;
@property (weak, nonatomic) IBOutlet UIButton *btnDecreaseFloor;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentFloor;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;

@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NCSublocation *sublocation;
@property (nonatomic, assign) NSInteger floor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _floor = 0;
     _isRouting = NO;
    
    _sv.delegate = self;
    _sv.pinchGestureRecognizer.enabled = YES;
    _sv.minimumZoomScale = 1.f;
    _sv.zoomScale = 1.f;
    _sv.maximumZoomScale = 2.f;
    
    _btnIncreaseFloor.hidden = YES;
    _btnDecreaseFloor.hidden = YES;
    _lblCurrentFloor.hidden  = YES;
    _btnDecreaseFloor.transform = CGAffineTransformMakeRotation(M_PI);
    
    [_sv addSubview:_imageView];
    
    _navigineCore = [[NavigineCore alloc] initWithUserHash: @"628B-9792-0789-C136"
                                                    server: @"https://api.navigine.com"];
    _navigineCore.delegate = self;
//    _navigineCore.navigationDelegate = self;
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

    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    tapPress.delaysTouchesBegan   = NO;
    [_sv addGestureRecognizer:tapPress];
//    [_navigineCore addBeaconGenerator:@"8EEB497E-4928-44C6-9D92-087521A3547C" major:9001 minor:36 timeout:10 rssiMin:-90 rssiMax:-70];
    [_navigineCore downloadLocationById:2475
                            forceReload:true
                           processBlock:^(NSInteger loadProcess) {
                               NSLog(@"%zd",loadProcess);
                           } successBlock:^(NSDictionary *userInfo) {
                               [self setupFloor: _floor];
                               _btnIncreaseFloor.hidden = (_navigineCore.location.sublocations.count == 1);
                               _btnDecreaseFloor.hidden = (_navigineCore.location.sublocations.count == 1);
                               _lblCurrentFloor.hidden  = (_navigineCore.location.sublocations.count == 1);
                           } failBlock:^(NSError *error) {
                               NSLog(@"%@",error);
                           }];
}

- (void) navigationTick: (NSTimer *)timer {
    NCDeviceInfo *res = _navigineCore.deviceInfo;
    if (res.error.code == 0) {
        _current.hidden = res.sublocation != _sublocation.id;
        _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                      _imageView.height / _sv.zoomScale * (1.0 - res.ky));
    }
    else {
        _current.hidden = YES;
    }
    if (_isRouting) {
        NCRoutePath *devicePath = res.paths.firstObject;
        if (devicePath) {
            NSArray *path = devicePath.points;
            float distance = devicePath.lenght;
            [self drawRouteWithPath:path andDistance:distance];
        }
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
            NCLocationPoint *point = path[i];
            
            if (point.sublocation != _sublocation.id)
                continue;
            
            CGSize imageSizeInMeters = CGSizeMake(_sublocation.width, _sublocation.height);
            
            CGFloat xPoint =  (point.x.doubleValue / imageSizeInMeters.width) * (_imageView.width / _sv.zoomScale);
            CGFloat yPoint =  (1. - point.y.doubleValue / imageSizeInMeters.height)  * (_imageView.height / _sv.zoomScale);
            if (uipath.empty) {
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
    
    CGSize imageSizeInMeters = CGSizeMake(_sublocation.width, _sublocation.height);
    CGFloat xPoint = _pressedPin.centerX /_imageView.width * imageSizeInMeters.width;
    CGFloat yPoint = (1. - _pressedPin.centerY /_imageView.height) * imageSizeInMeters.height;
    
    NCLocationPoint *point = [NCLocationPoint pointWithLocation: res.location
                                                    sublocation: _sublocation.id
                                                              x: @(xPoint)
                                                              y: @(yPoint)];
    [_navigineCore cancelTargets];
    [_navigineCore setTarget:point];
    
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

-(void) setupFloor: (NSInteger) floor {
    [_navigineCore startNavigine];
    [_navigineCore startPushManager];
    
    [_imageView removeAllSubviews];
    _imageView.layer.sublayers = nil;
    [_imageView addSubview:_current];
    
    _sublocation = _navigineCore.location.sublocations[floor];
    
    NSData *imageData = _sublocation.pngImage;
    UIImage *image = [UIImage imageWithData:imageData];
    
    float scale = 1.f;
    if (image.size.width / image.size.height >
        self.view.frame.size.width / self.view.frame.size.height) {
        scale = self.view.frame.size.height / image.size.height;
    }
    else {
        scale = self.view.frame.size.width / image.size.width;
    }
    
    _imageViewWidthConstraint.constant = image.size.width * scale;
    _imageViewHeightConstraint.constant = image.size.height * scale;
    
    _imageViewTopConstraint.constant = 0;
    _imageViewLeadingConstraint.constant = 0;
    
    _imageView.image = image;
    
    _sv.contentSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    _sv.contentOffset = CGPointMake(-(_imageViewWidthConstraint.constant - self.view.frame.size.width) / 2.0, -(_imageViewHeightConstraint.constant - self.view.frame.size.height) / 2.0);
    _lblCurrentFloor.text = [NSString stringWithFormat:@"%ld", (long)_floor];
    
    [self.view layoutIfNeeded];
    
    [self drawZones];
    [self drawVenues];
}

- (void) drawVenues {
    for (NCVenue *venue in _sublocation.venues) {
        CGFloat xPoint =  venue.x.doubleValue * _imageView.width / _sublocation.width;
        CGFloat yPoint =  _imageView.height * (1 - venue.y.doubleValue / _sublocation.height);
        
        CGPoint point = CGPointMake(xPoint, yPoint);
        MapPin *mapPin = [[MapPin alloc] initWithVenue:venue];
        UIImage *image = [UIImage imageNamed:@"elmVenueIcon"];
        [mapPin setImage:image forState:UIControlStateNormal];
        [mapPin setImage:image forState:UIControlStateHighlighted];
        [mapPin addTarget:self action:@selector(mapPinPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mapPin sizeToFit];
        [_imageView addSubview:mapPin];
        [_sv bringSubviewToFront:mapPin];
        
        mapPin.center  = point;
    }
}

- (void) drawZones {
    for (NCZone *zone in _sublocation.zones) {
        UIBezierPath *zonePath     = [[UIBezierPath alloc] init];
        CAShapeLayer *zoneLayer = [CAShapeLayer layer];
        NSArray *points = zone.points;
        NCLocationPoint *point0 = points[0];
        
        [zonePath moveToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / _sublocation.width,
                                          _imageView.height * (1. - point0.y.doubleValue / _sublocation.height))];
        for (NCLocationPoint *point in zone.points) {
                [zonePath addLineToPoint:CGPointMake(_imageView.width * point.x.doubleValue / _sublocation.width,
                                                     _imageView.height * (1. - point.y.doubleValue / _sublocation.height))];
        }
        [zonePath addLineToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / _sublocation.width,
                                             _imageView.height *(1. - point0.y.doubleValue / _sublocation.height))];
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

- (IBAction)btnIncreaseFloorPressed:(id)sender {
    if (_floor == _navigineCore.location.sublocations.count - 1)
        return;
    [self setupFloor: ++_floor];
}


- (IBAction)btnDecreaseFloorPressed:(id)sender {
    if (_floor == 0)
        return;
    [self setupFloor: --_floor];
}

# pragma mark NavigineCoreDelegate methods

- (void) navigineCore:(NavigineCore *)navigineCore didUpdateDeviceInfo:(NCDeviceInfo *)deviceInfo {
    NSLog(@"");
}
@end
