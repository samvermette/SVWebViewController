//
//  RootViewController.m
//  SVWebViewController
//
//  Created by Sam Vermette on 21.02.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "ViewController.h"
#import "SVWebViewController.h"

@interface MyCustomActivity : SVActivity
@end

@implementation MyCustomActivity

-(NSString *)activityTitle {
    return @"Custom Activity";
}

-(void)performActivity {
    // if you want to display a view controller override activityViewController instead
    NSString *message = self.webView.request.URL.absoluteString;
    [[[UIAlertView alloc] initWithTitle:@"custom activity" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
}

@end

@implementation ViewController


- (void)pushWebViewController {
    NSURL *URL = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Friday_(Rebecca_Black_song)"];
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
    webViewController.alwaysShowNavigationBar = NO;
	[self.navigationController pushViewController:webViewController animated:YES];
}


- (void)presentWebViewController {
	NSURL *URL = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Friday_(Rebecca_Black_song)"];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.excludedActivityTypes = [NSArray arrayWithObjects:SVActivityTypeMail, SVActivityTypeSafari, nil];
    webViewController.applicationActivities = [NSArray arrayWithObject:[MyCustomActivity new]];
    webViewController.alwaysShowNavigationBar = NO;
	[self presentModalViewController:webViewController animated:YES];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end

