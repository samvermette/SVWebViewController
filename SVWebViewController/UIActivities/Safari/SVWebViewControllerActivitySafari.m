//
//  SVWebViewControllerActivitySafari.m
//
//  Created by Sam Vermette on 11 Nov, 2013.
//  Copyright 2013 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController


#import "SVWebViewControllerActivitySafari.h"

@implementation SVWebViewControllerActivitySafari

- (NSString *)activityTitle {
	return NSLocalizedStringFromTable(@"Open in Safari", @"SVWebViewController", nil);
}

- (BOOL) canPerformWithActivityItems: (NSArray *) activityItems {

    BOOL canPerform = NO;

    for (NSURL *url in activityItems) {

        if ([url isKindOfClass:[NSURL class]]) {

            NSString *scheme = url.scheme;

            canPerform |= (([scheme isEqualToString: @"http"] ||
                            [scheme isEqualToString: @"https"]) &&
                           [[UIApplication sharedApplication] canOpenURL: url]);
        }
    }
	return canPerform;

} // -canPerformWithActivityItems:


- (void)performActivity {
	BOOL completed = [[UIApplication sharedApplication] openURL:self.URLToOpen];
	[self activityDidFinish:completed];
}

@end
