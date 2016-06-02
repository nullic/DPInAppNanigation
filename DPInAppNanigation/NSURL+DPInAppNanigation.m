//
//  NSURL+DPInAppNanigation.m
//  DPInAppNavigationDemo
//
//  Created by Dmitriy Petrusevich on 30/03/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "NSURL+DPInAppNanigation.h"
#import <objc/runtime.h>


static NSString * const dp_queryDictionaryKey = @"dp_queryDictionaryKey";

@implementation NSURL (DPInAppNanigation)

- (void)_setDP_queryDictionary:(NSDictionary *)dictionary {
    objc_setAssociatedObject(self, (__bridge const void *)(dp_queryDictionaryKey), dictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)_dp_queryDictionary {
    return objc_getAssociatedObject(self, (__bridge const void *)(dp_queryDictionaryKey));
}

- (NSDictionary *)dp_queryDictionary {
    NSDictionary *result = [self _dp_queryDictionary];

    if (result == nil) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

        for (NSString *param in [[self query] componentsSeparatedByString:@"&"]) {
            NSArray *comps = [param componentsSeparatedByString:@"="];
            if (comps.count == 2)  {
                NSString *key = [[comps[0] lowercaseString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *value = [comps[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [params setValue:value forKey:key];
            }
        }

        [self _setDP_queryDictionary:params];
        result = params;
    }

    return result;
}

@end
