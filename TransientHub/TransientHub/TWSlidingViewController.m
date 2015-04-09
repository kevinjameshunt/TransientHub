//
//  TWSlidingViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c)  2015 Prophet Studios All rights reserved.
//

#import "TWSlidingViewController.h"

@interface TWSlidingViewController ()

@end

@implementation TWSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // iPhone 40 pts from right, according to storyboard. iPad 280
    self.anchorRightRevealAmount = DEVICE_IS_IPHONE ? CGRectGetWidth(self.view.frame) - 44.f : 280.f;
}

- (void)setTopViewController:(UIViewController *)topViewController {
    [super setTopViewController:topViewController];
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {1.f, CGRectGetHeight(topViewController.view.frame)}}];
    lineView.backgroundColor = [UIColor colorWithRed:56.f/255.f green:8.f/255.f blue:59.f/255.f alpha:1.f];
    [topViewController.view addSubview:lineView];
}

- (NSUInteger)supportedInterfaceOrientations {
    if (DEVICE_IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
