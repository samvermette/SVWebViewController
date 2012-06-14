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

@synthesize barsTintColor, availableActions, modalWebViewControllerDelegate, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.navigationBar.tintColor = self.toolbar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

#pragma mark - Delegation

- (void)setModalWebViewControllerDelegate:(id<SVModalWebViewControllerDelegate>)_modalWebViewControllerDelegate {
    modalWebViewControllerDelegate = _modalWebViewControllerDelegate;
    if ([self.modalWebViewControllerDelegate respondsToSelector:@selector(modalWebViewControllerDoneButtonTouched:)]) {
        
        self.webViewController.navigationItem.leftBarButtonItem.target = self.modalWebViewControllerDelegate;
        self.webViewController.navigationItem.leftBarButtonItem.action = @selector(modalWebViewControllerDoneButtonTouched:);
    }
}

@end
