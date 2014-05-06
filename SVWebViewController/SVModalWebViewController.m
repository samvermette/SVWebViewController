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

- (void) initializeDoneButton;

@property (nonatomic, strong) SVWebViewController *webViewController;

@end

@implementation SVModalWebViewController

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        [self initializeDoneButton];
    }
    return self;
}

- (id)initWithHTMLString:(NSString *)htmlString andBaseUrl:(NSURL *)baseUrl {
    self.webViewController = [[SVWebViewController alloc] initWithHTMLString:htmlString andBaseUrl:baseUrl];
    if (self = [super initWithRootViewController:self.webViewController]) {
        [self initializeDoneButton];
    }
    return self;
}

- (void) initializeDoneButton {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self.webViewController
                                                                                action:@selector(doneButtonClicked:)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.webViewController.navigationItem.leftBarButtonItem = doneButton;
    else
        self.webViewController.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

@end
