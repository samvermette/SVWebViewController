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

- (void)viewWillLayoutSubviews
{
    if (self.isApplyFullscreenExitViewBoundsSizeFix) {
        [self landscapeOrientationBugFixForExitingFullscreenVideo];
        self.isApplyFullscreenExitViewBoundsSizeFix=NO;
    }
}

- (void)landscapeOrientationBugFixForExitingFullscreenVideo
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center;
    center.x = self.view.center.x;
    center.y = self.view.center.y;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        if (screenFrame.size.width < screenFrame.size.height) {
            screenFrame.size.width = [UIScreen mainScreen].bounds.size.height;
            screenFrame.size.height = [UIScreen mainScreen].bounds.size.width;
        }
    }
    self.view.bounds = screenFrame;
    self.view.center = center;
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

@end
