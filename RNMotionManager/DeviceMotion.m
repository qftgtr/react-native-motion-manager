//
//  DeviceMotion.m
//  RNMotionManager
//
//  Created by Zehao Li on 5/27/17.
//  Copyright © 2017 Patrick Williams. All rights reserved.
//

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "DeviceMotion.h"

@implementation DeviceMotion

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"DeviceMotion");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        // DeviceMotion
        if([self->_motionManager isDeviceMotionAvailable])
        {
            NSLog(@"DeviceMotion available");
            /* Start the DeviceMotion if it is not active already */
            if([self->_motionManager isDeviceMotionActive] == NO)
            {
                NSLog(@"DeviceMotion active");
            } else {
                NSLog(@"DeviceMotion not active");
            }
        }
        else
        {
            NSLog(@"DeviceMotion not Available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setDeviceMotionUpdateInterval:(double) interval) {
    NSLog(@"setDeviceMotionUpdateInterval: %f", interval);
    [self->_motionManager setDeviceMotionUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getDeviceMotionUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.deviceMotionUpdateInterval;
    NSLog(@"getDeviceMotionUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getDeviceMotionData:(RCTResponseSenderBlock) cb) {
    double gravity_x = self->_motionManager.deviceMotion.gravity.x;
    double gravity_y = self->_motionManager.deviceMotion.gravity.y;
    double gravity_z = self->_motionManager.deviceMotion.gravity.z;
    double userAcceleration_x = self->_motionManager.deviceMotion.userAcceleration.x;
    double userAcceleration_y = self->_motionManager.deviceMotion.userAcceleration.y;
    double userAcceleration_z = self->_motionManager.deviceMotion.userAcceleration.z;
    // double roll = self->_motionManager.deviceMotion.attitude.roll;
    // double yaw = self->_motionManager.deviceMotion.attitude.yaw;
    // double pitch = self->_motionManager.deviceMotion.attitude.pitch;
    CMRotationMatrix m = self->_motionManager.deviceMotion.attitude.rotationMatrix;

    NSLog(@"getDeviceMotionData (gravity): %f, %f, %f", gravity_x, gravity_y, gravity_z);
    NSLog(@"getDeviceMotionData (userAcceleration): %f, %f, %f", userAcceleration_x, userAcceleration_y, userAcceleration_z);

    cb(@[[NSNull null], @{
             @"gravity": @{
                     @"x" : [NSNumber numberWithDouble:gravity_x],
                     @"y" : [NSNumber numberWithDouble:gravity_y],
                     @"z" : [NSNumber numberWithDouble:gravity_z]
             },
             @"userAcceleration": @{
                     @"x" : [NSNumber numberWithDouble:userAcceleration_x],
                     @"y" : [NSNumber numberWithDouble:userAcceleration_y],
                     @"z" : [NSNumber numberWithDouble:userAcceleration_z]
             },
             @"rotationMatrix": @{
                     @"m11" : [NSNumber numberWithDouble:m.m11],
                     @"m12" : [NSNumber numberWithDouble:m.m12],
                     @"m13" : [NSNumber numberWithDouble:m.m13],
                     @"m21" : [NSNumber numberWithDouble:m.m21],
                     @"m22" : [NSNumber numberWithDouble:m.m22],
                     @"m23" : [NSNumber numberWithDouble:m.m23],
                     @"m31" : [NSNumber numberWithDouble:m.m31],
                     @"m32" : [NSNumber numberWithDouble:m.m32],
                     @"m33" : [NSNumber numberWithDouble:m.m33]
             },
            //  @"attitude": @{
            //          @"roll" : [NSNumber numberWithDouble:roll],
            //          @"yaw" : [NSNumber numberWithDouble:yaw],
            //          @"pitch" : [NSNumber numberWithDouble:pitch]
            //          }
             }]
       );
}

RCT_EXPORT_METHOD(startDeviceMotionUpdates) {
    NSLog(@"startMagnetometerUpdates");
    [self->_motionManager startDeviceMotionUpdates];

    /* Receive the DeviceMotion data on this block */
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                              withHandler:^(CMDeviceMotion *motionData, NSError *error)
     {
         double gravity_x = motionData.gravity.x;
         double gravity_y = motionData.gravity.y;
         double gravity_z = motionData.gravity.z;
         double userAcceleration_x = motionData.userAcceleration.x;
         double userAcceleration_y = motionData.userAcceleration.y;
         double userAcceleration_z = motionData.userAcceleration.z;
        //  double roll = motionData.attitude.roll;
        //  double yaw = motionData.attitude.yaw;
        //  double pitch = motionData.attitude.pitch;
         CMRotationMatrix m = motionData.attitude.rotationMatrix;

         NSLog(@"startDeviceMotionUpdates (gravity): %f, %f, %f", gravity_x, gravity_y, gravity_z);
         NSLog(@"startDeviceMotionUpdates (userAcceleration): %f, %f, %f", userAcceleration_x, userAcceleration_y, userAcceleration_z);
        //  NSLog(@"startAttitudeUpdates: %f, %f, %f", roll, yaw, pitch);

         [self.bridge.eventDispatcher sendDeviceEventWithName:@"MotionData" body:@{
                                                                                   @"gravity": @{
                                                                                           @"x" : [NSNumber numberWithDouble:gravity_x],
                                                                                           @"y" : [NSNumber numberWithDouble:gravity_y],
                                                                                           @"z" : [NSNumber numberWithDouble:gravity_z]
                                                                                           },
                                                                                   @"userAcceleration": @{
                                                                                           @"x" : [NSNumber numberWithDouble:userAcceleration_x],
                                                                                           @"y" : [NSNumber numberWithDouble:userAcceleration_y],
                                                                                           @"z" : [NSNumber numberWithDouble:userAcceleration_z]
                                                                                           },
                                                                                  //  @"attitude": @{
                                                                                  //          @"roll" : [NSNumber numberWithDouble:roll],
                                                                                  //          @"yaw" : [NSNumber numberWithDouble:yaw],
                                                                                  //          @"pitch" : [NSNumber numberWithDouble:pitch]
                                                                                  //          }
                                                                                  @"rotationMatrix": @{
                                                                                          @"m11" : [NSNumber numberWithDouble:m.m11],
                                                                                          @"m12" : [NSNumber numberWithDouble:m.m12],
                                                                                          @"m13" : [NSNumber numberWithDouble:m.m13],
                                                                                          @"m21" : [NSNumber numberWithDouble:m.m21],
                                                                                          @"m22" : [NSNumber numberWithDouble:m.m22],
                                                                                          @"m23" : [NSNumber numberWithDouble:m.m23],
                                                                                          @"m31" : [NSNumber numberWithDouble:m.m31],
                                                                                          @"m32" : [NSNumber numberWithDouble:m.m32],
                                                                                          @"m33" : [NSNumber numberWithDouble:m.m33]
                                                                                  }
                                                                                   }];
     }];
}

RCT_EXPORT_METHOD(stopDeviceMotionUpdates) {
    NSLog(@"stopDeviceMotionUpdates");
    [self->_motionManager stopDeviceMotionUpdates];
}

@end
