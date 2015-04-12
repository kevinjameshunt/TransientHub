//
//  AppDelegate.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-04.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

// Detection of Device Type
#define DEVICE_IS_IPAD      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_IS_IPHONE    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

