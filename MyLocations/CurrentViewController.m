//
//  FirstViewController.m
//  MyLocations
//
//  Created by Leonardo Lee on 7/16/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "CurrentViewController.h"

@interface CurrentViewController ()

@end

@implementation CurrentViewController
{
	CLLocationManager *_locationManager;
	CLLocation *_location;
	BOOL _updatingLocation;
	NSError *_lastLocationError;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabels];
}
#pragma mark - VCMethods
-(IBAction)getLocation:(id)sender
{
//	Placed into StartLocationManager
//	_locationManager.delegate = self;
//	_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//	[_locationManager startUpdatingLocation];
	[self startLocationManager];
	[self updateLabels];
}
-(void)updateLabels
{
	if (_location != nil) {
		self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.latitude];
		self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", _location.coordinate.longitude];
		self.tagButton.hidden = NO;
		self.messageLabel.text = @"";
	} else {
		self.latitudeLabel.text = @"";
		self.longitudeLabel.text = @"";
		self.addressLabel.text = @"";
		self.tagButton.hidden = YES;
		
		NSString *statusMessage;
		if (_lastLocationError != nil) {
			if ([_lastLocationError.domain isEqualToString:kCLErrorDomain] && _lastLocationError.code == kCLErrorDenied) {
				statusMessage = @"Location Services Disabled";
			} else {
				statusMessage = @"Error Getting Location";
			}
		} else if (![CLLocationManager locationServicesEnabled]) {
			statusMessage = @"Location Services Disabled";
		} else if (_updatingLocation) {
			statusMessage = @"Searching...";
		} else {
			self.messageLabel.text = @"Press the Button to Start";
		}
		self.messageLabel.text = statusMessage;
	}
}
-(void)startLocationManager
{
	if ([CLLocationManager locationServicesEnabled]) {
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		[_locationManager startUpdatingLocation];
		_updatingLocation = YES;
	}
}
-(void)stopLocationManager
{
	if (_updatingLocation) {
		[_locationManager stopUpdatingLocation];
		_locationManager.delegate = nil;
		_updatingLocation = NO;
	}
}

#pragma mark - CLLocationManagerDelegate
-(id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		_locationManager = [[CLLocationManager alloc] init];
	}
	return self;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError %@", error);
	if (error.code == kCLErrorLocationUnknown) {
		return;
	}
	[self stopLocationManager];
	_lastLocationError = error;
	[self updateLabels];
	
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *newLocation = [locations lastObject];
	NSLog(@"didUpdateLocations %@", newLocation);
	
	_lastLocationError = nil;
	_location = newLocation;
	[self updateLabels];
}
@end
