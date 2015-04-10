//
//  TWEventFeed.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWBaseEventFeed.h"
#import "TWBaseEvent.h"
#import "CDEventFeed.h"
#import "CDEvent.h"

@implementation TWBaseEventFeed

+(TWBaseEventFeed *)eventFeedWithSavedFeed:(CDEventFeed *)cdEventFeed {
    TWBaseEventFeed *newEventFeed = [[TWBaseEventFeed alloc] init];
    [newEventFeed updateWithSavedFeed:cdEventFeed];
    return newEventFeed;
}

- (void)updateWithSavedFeed:(CDEventFeed *)cdEventFeed {
    self.feedId         = [cdEventFeed.feedId integerValue];
    self.feedName       = [cdEventFeed.feedName copy];
    self.feedDesc       = [cdEventFeed.feedDesc copy];
    self.feedHomeUrl    = [cdEventFeed.feedHomeUrl copy];
    self.eventTypes     = [cdEventFeed.eventTypes allObjects];
    self.lastUpdate     = [cdEventFeed.lastUpdate copy];
    
    NSArray *cdEventArray         = [cdEventFeed.events allObjects];
    NSMutableArray *newEventArray = [[NSMutableArray alloc] initWithCapacity:[cdEventArray count]];
    
    for (CDEvent *cdEvent in cdEventArray) {
        TWBaseEvent *newEvent = [TWBaseEvent eventWithSavedEvent:cdEvent];
        [newEventArray addObject:newEvent];
    }
    
    self.events = newEventArray;
}

@end
