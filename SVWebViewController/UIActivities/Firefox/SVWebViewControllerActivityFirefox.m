//  Created by Sam Vermette on 11 Nov, 2013.
//  Copyright 2013 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityFirefox.h"

@implementation SVWebViewControllerActivityFirefox

- (NSString *)activityTitle {
	return NSLocalizedStringFromTable(@"Open in Firefox", @"SVWebViewController", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"firefox://"]]) {
			return YES;
		}
	}
	return NO;
}

static NSString *encodeByAddingPercentEscapes(NSString *string) {
    NSString *encodedString = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes
     (kCFAllocatorDefault,
      (CFStringRef)string,
      NULL,
      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
      kCFStringEncodingUTF8));
    return encodedString;
}

- (void)performActivity {
    NSURL *inputURL = self.URLToOpen;
    NSString *scheme = inputURL.scheme;

	if (![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"https"]) {
    return;
	}

    NSString *urlString = [inputURL absoluteString];
    NSString *firefoxURLString = [NSString stringWithFormat: @"firefox://open-url?url=%@", encodeByAddingPercentEscapes(urlString)];
    NSURL *firefoxURL = [NSURL URLWithString: firefoxURLString];

    // Open the URL with Firefox.
    [[UIApplication sharedApplication] openURL:firefoxURL];
}

@end
