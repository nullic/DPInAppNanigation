//
//  DPInAppNanigationProtocol.h
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 30/03/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "UIViewController+DPInAppNanigation.h"

@interface DPInAppNanigationProtocol : NSURLProtocol
+ (void)registerWithScheme:(NSString *)scheme mainWindow:(UIWindow *)mainWindow;

+ (BOOL)canHandleURL:(NSURL *)url;
+ (BOOL)handleURL:(NSURL *)url;
@end
