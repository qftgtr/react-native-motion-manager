//
//  DeviceMotion.h
//  RNMotionManager
//
//  Created by Zehao Li on 5/27/17.
//  Copyright © 2017 Patrick Williams. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface DeviceMotion : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}
- (void) setDeviceMotionUpdateInterval:(double) interval;
- (void) getDeviceMotionUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getDeviceMotionData:(RCTResponseSenderBlock) cb;
- (void) startDeviceMotionUpdates;
- (void) stopDeviceMotionUpdates;

@end
