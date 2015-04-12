//
//  TWSlidingViewController.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c)  2015 Prophet Studios All rights reserved.
//

// Detection of Device Type
#define DEVICE_IS_IPAD      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_IS_IPHONE    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#import "ECSlidingViewController.h"

@interface TWSlidingViewController : ECSlidingViewController

@end
