//
//  TWCRTSEvent.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-10.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWCRTSEvent.h"
#import "CDEvent.h"

@implementation TWCRTSEvent

+(TWBaseEvent *)crtsEventWithSavedEvent:(CDEvent *)cdEvent {
    TWCRTSEvent *newEvent = [[TWCRTSEvent alloc] init];
    [newEvent updateWithSavedCRTSEvent:cdEvent];
    return newEvent;
}

- (void)updateWithSavedCRTSEvent:(CDEvent *)cdEvent {
    [super updateWithSavedVOEvent:cdEvent];

    self.refImgUrl          = [cdEvent.refImgUrl copy];
    self.pastImg            = [cdEvent.refImgUrl copy];
    self.recentImgs         = [cdEvent.recentImgs allObjects];
    self.findingChartImage  = [cdEvent.findingChartImage copy];
}

@end
