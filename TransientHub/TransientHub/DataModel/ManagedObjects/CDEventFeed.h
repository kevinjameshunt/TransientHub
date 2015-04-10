//
//  CDEventFeed.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDEvent;

@interface CDEventFeed : NSManagedObject

@property (nonatomic, retain) NSString * feedName;
@property (nonatomic, retain) NSString * feedDesc;
@property (nonatomic, retain) NSString * feedHomeUrl;
@property (nonatomic, retain) NSSet * eventTypes;
@property (nonatomic, retain) NSNumber * feedId;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSSet *events;

@end
