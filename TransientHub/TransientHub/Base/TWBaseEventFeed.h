//
//  TWEventFeed.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDEventFeed;

@interface TWBaseEventFeed : NSObject

@property (nonatomic) NSInteger feedId;
@property (nonatomic, strong) NSString * feedName;
@property (nonatomic, strong) NSString * feedDesc;
@property (nonatomic, strong) NSString * feedHomeUrl;
@property (nonatomic, strong) NSArray * eventTypes;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSDate * lastUpdate;

+(TWBaseEventFeed *)eventFeedWithSavedFeed:(CDEventFeed *)cdEventFeed;

- (void)updateWithSavedFeed:(CDEventFeed *)cdEventFeed;

@end
