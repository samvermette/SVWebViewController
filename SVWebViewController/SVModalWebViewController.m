//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController () <SVWebViewControllerDelegate>

@property (nonatomic, strong) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    self.webViewController.delegate = self;
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.navigationBar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

#pragma mark - WebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.webViewDelegate webViewDidStartLoad:webView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webViewDelegate webViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.webViewDelegate webView:webView didFailLoadWithError:error];
}

@end
