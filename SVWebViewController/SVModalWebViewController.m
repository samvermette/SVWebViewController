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
    return [self initWithURL:URL hidingToolbar:NO];
}
    
- (id)initWithAddress:(NSString*)urlString hidingToolbar:(BOOL)toobarHidden {
    return [self initWithURL:[NSURL URLWithString:urlString] hidingToolbar:toobarHidden];
}

- (id)initWithURL:(NSURL *)URL hidingToolbar:(BOOL)toobarHidden {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    self.toolbarHidden = toobarHidden;
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    if (self.barButtonItemPosition == SVWebViewControllerLeftBarButtonItem) {
        self.webViewController.navigationItem.leftBarButtonItem = self.barButtonItem;
    } else {
        self.webViewController.navigationItem.rightBarButtonItem = self.barButtonItem;
    }

    if (self.barsTintColor) {
        self.navigationBar.tintColor = self.barsTintColor;
    }
}

- (void)setToolbarHidden:(BOOL)toolbarHidden
{
    [super setToolbarHidden:toolbarHidden];
    [self.webViewController setToolbarHidden:toolbarHidden];
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

@end
