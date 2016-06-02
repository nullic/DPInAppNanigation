//
//  UIViewController+DPInAppNanigation.m
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 30/03/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "UIViewController+DPInAppNanigation.h"

#pragma mark - UIViewController

@implementation UIViewController (DPInAppNanigation)

- (BOOL)canHandleURL:(NSURL *)url {
    return NO;
}

- (BOOL)handleURL:(NSURL *)url {
    return NO;
}

@end

#pragma mark - UINavigationController

@implementation UINavigationController (DPInAppNanigation)

- (BOOL)canHandleURL:(NSURL *)url {
    return [[self.viewControllers firstObject] canHandleURL:url];
}

- (BOOL)handleURL:(NSURL *)url {
    BOOL result = NO;
    if ([self canHandleURL:url]) {
        [self popToRootViewControllerAnimated:NO];
        result = [[self.viewControllers firstObject] handleURL:url];
    }
    return result;
}

@end

#pragma mark - UITabBarController

@implementation UITabBarController (DPInAppNanigation)

- (BOOL)canHandleURL:(NSURL *)url {
    BOOL result = NO;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc canHandleURL:url]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (BOOL)handleURL:(NSURL *)url {
    BOOL result = NO;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc canHandleURL:url]) {
            self.selectedViewController = vc;
            result = [vc handleURL:url];
            break;
        }
    }
    return result;
}

@end