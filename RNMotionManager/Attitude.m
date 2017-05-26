//
//  Attitude.m
//  RNMotionManager
//
//  Created by Zehao Li on 5/27/17.
//  Copyright © 2017 Patrick Williams. All rights reserved.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Attitude.h"

@implementation Attitude

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"Attitude");
    
    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Attitude
        if([self->_motionManager isDeviceMotionAvailable])
        {
            NSLog(@"Attitude available");
            /* Start the accelerometer if it is not active already */
            if([self->_motionManager isDeviceMotionActive] == NO)
            {
                NSLog(@"Attitude active");
            } else {
                NSLog(@"Attitude not active");
            }
        }
        else
        {
            NSLog(@"Attitude not Available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setAttitudeUpdateInterval:(double) interval) {
    NSLog(@"setAttitudeUpdateInterval: %f", interval);
    
    [self->_motionManager setDeviceMotionUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getAttitudeUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.deviceMotionUpdateInterval;
    NSLog(@"getAttitudeUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getAttitudeData:(RCTResponseSenderBlock) cb) {
    double roll = self->_motionManager.deviceMotion.attitude.roll;
    double yaw = self->_motionManager.deviceMotion.attitude.yaw;
    double pitch = self->_motionManager.deviceMotion.attitude.pitch;
    
    NSLog(@"getAttitudeData: %f, %f, %f", roll, yaw, pitch);
    
    cb(@[[NSNull null], @{
             @"attitude": @{
                     @"roll" : [NSNumber numberWithDouble:roll],
                     @"yaw" : [NSNumber numberWithDouble:yaw],
                     @"pitch" : [NSNumber numberWithDouble:pitch]
                     }
             }]
       );
}

RCT_EXPORT_METHOD(startAttitudeUpdates) {
    NSLog(@"startAttitudeUpdates");
    [self->_motionManager startDeviceMotionUpdates];
    
    /* Receive the ccelerometer data on this block */
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                               withHandler:^(CMDeviceMotion *motionData, NSError *error)
     {
         double roll = motionData.attitude.roll;
         double yaw = motionData.attitude.yaw;
         double pitch = motionData.attitude.pitch;
         NSLog(@"startAttitudeUpdates: %f, %f, %f", roll, yaw, pitch);
         
         [self.bridge.eventDispatcher sendDeviceEventWithName:@"AttitudeData" body:@{
                                                                                         @"attitude": @{
                                                                                                 @"roll" : [NSNumber numberWithDouble:roll],
                                                                                                 @"yaw" : [NSNumber numberWithDouble:yaw],
                                                                                                 @"pitch" : [NSNumber numberWithDouble:pitch]
                                                                                                 }
                                                                                         }];
     }];
    
}

RCT_EXPORT_METHOD(stopAttitudeUpdates) {
    NSLog(@"stopAttitudeUpdates");
    [self->_motionManager stopAttitudeUpdates];
}

@end
