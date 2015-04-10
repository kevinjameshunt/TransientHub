//
//  TWBaseEvent.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDEvent;

@interface TWBaseEvent : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSDate * alertTime;
@property (nonatomic, strong) NSDate * eventTime;
@property (nonatomic) float magnitude;
@property (nonatomic) float ra;
@property (nonatomic) float dec;
@property (nonatomic, strong) NSString * finderChartUrl;
@property (nonatomic, strong) NSString * lightCurveUrl;
@property (nonatomic) BOOL viewed;

+(TWBaseEvent *)eventWithSavedEvent:(CDEvent *)cdEvent;

- (void)updateWithSavedEvent:(CDEvent *)cdEvent;

@end
