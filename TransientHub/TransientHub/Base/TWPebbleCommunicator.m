//
//  TWPebbleCommunicator.m
//  TransientHub
//
//  Created by Stephen Diadamo on 2015-04-11.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PebbleKit/PebbleKit.h>
#import <PebbleKit/PBWatch+AppMessages.h>
#import "TWPebbleCommunicator.h"

@implementation TWPebbleCommunicator


static TWPebbleCommunicator *pebbleCommunicator = nil;

+ (TWPebbleCommunicator *) sharedPebbleCommunicator {
    if (pebbleCommunicator == nil){ 
        pebbleCommunicator = [[super alloc] init];
    }
    return pebbleCommunicator;
}

-  (void)setPebbleListner: (TWPebbleInfoListener *)infoListener {
    self.infoListener = infoListener;
}

- (id)init {
    if (self = [super init]) {
        self.watch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];

        NSLog(@"CONNECTED WATCH");
        self.infoListener = nil;
        
        uuid_t appUUIDbytes;
        NSUUID *appUUID = [[NSUUID alloc] initWithUUIDString: @"3ee5b570-d689-4d87-8d6d-a30610b0b2f3"];
        [appUUID getUUIDBytes:appUUIDbytes];
        
        [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:appUUIDbytes length:16]];
        
        [self.watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
            [self onReceive:watch :update];
             return YES;
        }];
    }
    return self;
}

- (void)onReceive:(PBWatch *)watch :(NSDictionary *) dict {
    if ([[dict objectForKey:@(0)]intValue] == 1) {
        NSDictionary *update = @{ @(1): self.cTitle,
                                  @(2): self.cInfo };
        
        [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
            if (!error){
                NSLog(@"Success");
            } else {
                NSLog(@"Failed receive - Error: %@", error);
            }
        }];
        self.watchAppRunning = true;
    } else if ([[dict objectForKey:@(0)]intValue] == 2) {
        if (self.infoListener != nil) {
            [self.infoListener displayInfo:self.cTitle];
        }
    }
}

- (void)notify: (NSString *)title :(NSString*) info {
    self.watchAppRunning = false;
    self.cTitle = title;
    self.cInfo = info;
    [self.watch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        } else {
            NSLog(@"Failed launch - Error: %@", error);
        }
    }];
}

@end