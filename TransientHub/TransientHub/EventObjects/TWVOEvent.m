//
//  TWVOEvent.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWVOEvent.h"
#import "TWBaseEvent.h"
#import "CDEvent.h"

@implementation TWVOEvent

+(TWBaseEvent *)voEventWithSavedEvent:(CDEvent *)cdEvent {
    TWVOEvent *newEvent = [[TWVOEvent alloc] init];
    [newEvent updateWithSavedVOEvent:cdEvent];
    return newEvent;
}

- (void)updateWithSavedVOEvent:(CDEvent *)cdEvent {
    [super updateWithSavedEvent:cdEvent];
    
    self.firstIVORNRef  = [cdEvent.firstIVORNRef copy];
    self.triggerIVORN   = [cdEvent.triggerIVORN copy];
    self.localIVORN     = [cdEvent.triggerIVORN copy];
}

@end
