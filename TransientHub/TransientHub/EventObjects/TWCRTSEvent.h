//
//  TWCRTSEvent.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-10.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWVOEvent.h"

@interface TWCRTSEvent : TWVOEvent

@property (nonatomic, strong) NSString * refImgUrl;
@property (nonatomic, strong) NSString * pastImg;
@property (nonatomic, strong) NSArray  * recentImgs;
@property (nonatomic, strong) NSString * findingChartImage;

+(TWCRTSEvent *)crtsEventWithSavedEvent:(CDEvent *)cdEvent;

- (void)updateWithSavedCRTSEvent:(CDEvent *)cdEvent;

@end
