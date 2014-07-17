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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateLabels];
}
#pragma mark - VCMethods
-(IBAction)getLocation:(id)sender
{
	_locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	[_locationManager startUpdatingLocation];
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
		self.messageLabel.text = @"Press the Button to Start";
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
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *newLocation = [locations lastObject];
	NSLog(@"didUpdateLocations %@", newLocation);
	
	_location = newLocation;
	[self updateLabels];
}
@end
