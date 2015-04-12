//
//  TWPebbleCommunicator.h
//  TransientHub
//
//  Created by Stephen Diadamo on 2015-04-11.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#ifndef TransientHub_TWPebbleCommunicator_h
#define TransientHub_TWPebbleCommunicator_h
#endif

#import <PebbleKit/PebbleKit.h>
#import "TWPebbleInfoListener.h"

@interface TWPebbleCommunicator : PBPebbleCentral {
    
}

@property PBWatch *watch;
@property NSString *cTitle;
@property NSString *cInfo;
@property BOOL watchAppRunning;
@property TWPebbleInfoListener *infoListener;

+ (TWPebbleCommunicator *)sharedPebbleCommunicator;
- (void)onReceive:(PBWatch *)watch :(NSDictionary *) dict;
- (void)notify: (NSString *)title :(NSString*) info;
- (void)setPebbleListner: (TWPebbleInfoListener *)infoListener;

@end

