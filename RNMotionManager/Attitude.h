//
//  Attitude.h
//  RNMotionManager
//
//  Created by Zehao Li on 5/27/17.
//  Copyright © 2017 Patrick Williams. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <CoreMotion/CoreMotion.h>

@interface Attitude : NSObject <RCTBridgeModule> {
    CMMotionManager *_motionManager;
}
- (void) setAttitudeUpdateInterval:(double) interval;
- (void) getAttitudeUpdateInterval:(RCTResponseSenderBlock) cb;
- (void) getAttitudeData:(RCTResponseSenderBlock) cb;
- (void) startAttitudeUpdates;
- (void) stopAttitudeUpdates;

@end
