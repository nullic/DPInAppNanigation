//
//  UIViewController+DPInAppNanigation.h
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 30/03/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURL+DPInAppNanigation.h"

@interface UIViewController (DPInAppNanigation)
- (BOOL)canHandleURL:(NSURL *)url;
- (BOOL)handleURL:(NSURL *)url;
@end

@interface UINavigationController (DPInAppNanigation)
- (BOOL)canHandleURL:(NSURL *)url;
- (BOOL)handleURL:(NSURL *)url;
@end

@interface UITabBarController (DPInAppNanigation)
- (BOOL)canHandleURL:(NSURL *)url;
- (BOOL)handleURL:(NSURL *)url;
@end