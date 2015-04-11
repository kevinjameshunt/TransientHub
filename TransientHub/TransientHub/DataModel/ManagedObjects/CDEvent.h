//
//  CDEvent.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDEventFeed;

@interface CDEvent : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * alertTime;
@property (nonatomic, retain) NSDate * eventTime;
@property (nonatomic, retain) NSNumber * magnitude;
@property (nonatomic, retain) NSNumber * ra;
@property (nonatomic, retain) NSNumber * dec;
@property (nonatomic, retain) NSString * refImgUrl;
@property (nonatomic, retain) NSString * finderChartUrl;
@property (nonatomic, retain) NSString * lightCurveUrl;
@property (nonatomic, retain) NSString * pastImg;
@property (nonatomic, retain) NSSet * recentImgs;
@property (nonatomic, retain) NSString * firstIVORNRef;
@property (nonatomic, retain) NSString * triggerIVORN;
@property (nonatomic, retain) NSString * localIVORN;
@property (nonatomic, retain) NSString * findingChartImage;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) CDEventFeed *eventFeed;

@end
