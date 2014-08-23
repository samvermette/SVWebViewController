//
//  SVWebViewControllerActivityChrome.h
//
//  Created by Sam Vermette on 11 Nov, 2013.
//  Copyright 2013 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityChrome.h"
#import "OpenInChromeController.h"

@implementation SVWebViewControllerActivityChrome

- (NSString *)activityTitle {
	return NSLocalizedStringFromTable(@"Open in Chrome", @"SVWebViewController", nil);
}

- (BOOL) canPerformWithActivityItems: (NSArray *) activityItems {

    if ([[OpenInChromeController sharedInstance] isChromeInstalled]) {

        BOOL canPerform = NO;
        
        for (NSURL *url in activityItems) {

            if ([url isKindOfClass:[NSURL class]]) {

                NSString *scheme = url.scheme;

                canPerform |= ([scheme isEqualToString: @"http"] ||
                               [scheme isEqualToString: @"https"]);
            }
        }
        return canPerform;
    }
	return NO;

} // -canPerformWithActivityItems:


- (void) performActivity {

    [[OpenInChromeController sharedInstance] openInChrome: self.URLToOpen];

	[self activityDidFinish: YES];

} // -performActivity

@end
