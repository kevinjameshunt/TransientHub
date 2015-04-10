//
//  TWBaseEvent.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWBaseEvent.h"
#import "CDEvent.h"

@implementation TWBaseEvent

+(TWBaseEvent *)eventWithSavedEvent:(CDEvent *)cdEvent {
    TWBaseEvent *newEvent = [[TWBaseEvent alloc] init];
    [newEvent updateWithSavedEvent:cdEvent];
    return newEvent;
}

- (void)updateWithSavedEvent:(CDEvent *)cdEvent {
    self.name           = [cdEvent.name copy];
    self.type           = [cdEvent.type copy];
    self.alertTime      = [cdEvent.alertTime copy];
    self.eventTime      = [cdEvent.eventTime copy];
    self.magnitude      = [cdEvent.magnitude floatValue];
    self.ra             = [cdEvent.ra floatValue];
    self.dec            = [cdEvent.dec floatValue];
    self.finderChartUrl = [cdEvent.finderChartUrl copy];
    self.lightCurveUrl  = [cdEvent.lightCurveUrl copy];
    self.viewed         = [cdEvent.viewed boolValue];
}

@end
