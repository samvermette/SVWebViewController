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

@property (nonatomic, assign) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, doneBarButtonItem, availableActions, doneBarButtonPosition, webViewController;

#pragma mark - Initialization

- (void)dealloc {
    self.barsTintColor = nil;
    [super dealloc];
}

- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[[SVWebViewController alloc] initWithURL:URL] autorelease];
    self.doneBarButtonPosition = SVWebViewControllerDoneBarButtonPositionLeft;
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.doneBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)] autorelease];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (self.doneBarButtonPosition) {
        case SVWebViewControllerDoneBarButtonPositionLeft:
            self.webViewController.navigationItem.leftBarButtonItem = self.doneBarButtonItem;
            break;
        case SVWebViewControllerDoneBarButtonPositionRight:
            self.webViewController.navigationItem.rightBarButtonItem = self.doneBarButtonItem;
            break;
    }
    
    self.navigationBar.tintColor = self.toolbar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

@end
