//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

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
    self = [self initWebViewController:self.webViewController];
    return self;
}

- (id)initWithURL:(NSURL *)URL withView:(UIWebView *)view{
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL withView:view];
    self = [self initWebViewController:self.webViewController];
    return self;
}

- (id)initWebViewController:(SVWebViewController *)theWebViewController
{
    if (self = [super initWithRootViewController:theWebViewController]) {
        theWebViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:theWebViewController action:@selector(doneButtonClicked:)];
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

@end
