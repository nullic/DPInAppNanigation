//
//  DPInAppNanigationProtocol.m
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 30/03/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "DPInAppNanigationProtocol.h"
#import <objc/runtime.h>

static NSString * _applicationScheme = nil;
static UIWindow * __weak _mainWindow = nil;

#pragma mark - UIApplication hidden method

@interface UIApplication (DPInAppNanigation)
@end

@implementation UIApplication (DPInAppNanigation)

- (BOOL)dp_inapp_nav_openURL:(NSURL *)url {
    BOOL result = NO;

    if ([DPInAppNanigationProtocol canHandleURL:url] == NO) {
        result = [self dp_inapp_nav_openURL:url];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(application:openURL:options:)]) {
            [self.delegate application:self openURL:url options:@{}];
        }
        else {
            result = [DPInAppNanigationProtocol handleURL:url];
        }
    }

    return result;
}

- (BOOL)dp_inapp_nav_canOpenURL:(NSURL *)url {
    BOOL result = [DPInAppNanigationProtocol canHandleURL:url];
    return result ?: [self dp_inapp_nav_canOpenURL:url];
}

@end

#pragma mark - DPInAppNanigationProtocol implementation

@implementation DPInAppNanigationProtocol

+ (void)registerWithScheme:(NSString *)scheme mainWindow:(UIWindow *)mainWindow {
    _applicationScheme = scheme;
    _mainWindow = mainWindow;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSURLProtocol registerClass:[self class]];

        Class class = [UIApplication class];
        
        {
            SEL originalSelector = @selector(openURL:);
            SEL swizzledSelector = @selector(dp_inapp_nav_openURL:);

            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }

        {
            SEL originalSelector = @selector(canOpenURL:);
            SEL swizzledSelector = @selector(dp_inapp_nav_canOpenURL:);

            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [self canHandleURL:request.URL];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

#pragma mark -

- (void)startLoading {
    NSURL *url = self.request.URL;
    NSInteger statusCode = [[self class] handleURL:url] ? 200 : 404;
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:statusCode HTTPVersion:@"1.1" headerFields:nil];

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:[NSData data]];
    [self.client URLProtocolDidFinishLoading:self];
}

+ (UIViewController *)applicationRootViewController {
    UIViewController *rootViewController = _mainWindow.rootViewController;
    if (rootViewController == nil) {
        NSLog(@"Error: Can't find root view controller");
    }
    return rootViewController;
}

#pragma mark -

+ (BOOL)canHandleURL:(NSURL *)url {
    NSString *scheme = [url scheme];
    if (url && scheme == nil) {
        NSLog(@"Error: Invalid scheme in URL (%@)", url);
    }
    return (scheme && [scheme caseInsensitiveCompare:_applicationScheme] == NSOrderedSame);
}

+ (BOOL)handleURL:(NSURL *)url {
    BOOL result = NO;

    if ([self canHandleURL:url]) {
        result = [[self applicationRootViewController] handleURL:url];
    }

    return result;
}

@end
