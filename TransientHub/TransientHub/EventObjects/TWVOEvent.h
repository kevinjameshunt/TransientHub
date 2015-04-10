//
//  TWVOEvent.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWBaseEvent.h"

@interface TWVOEvent : TWBaseEvent

@property (nonatomic, strong) NSString * firstIVORNRef;
@property (nonatomic, strong) NSNumber * triggerIVORN;
@property (nonatomic, strong) NSNumber * localIVORN;

+(TWVOEvent *)voEventWithSavedEvent:(CDEvent *)cdEvent;

- (void)updateWithSavedVOEvent:(CDEvent *)cdEvent;

@end
