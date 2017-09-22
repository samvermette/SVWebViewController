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

@interface SVWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation SVModalWebViewController

#pragma mark - Initialization


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithAddress:(NSString*)urlString scalesPageToFit:(BOOL)scalesPageToFit {
    return [self initWithURL:[NSURL URLWithString:urlString] scalesPageToFit:scalesPageToFit];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURL:(NSURL *)URL scalesPageToFit:(BOOL)scalesPageToFit {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL] scalesPageToFit:scalesPageToFit];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    return [self initWithURLRequest:request scalesPageToFit:YES];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request scalesPageToFit:(BOOL)scalesPageToFit {
    self.webViewController = [[SVWebViewController alloc] initWithURLRequest:request scalesPageToFit:scalesPageToFit];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(doneButtonTapped:)];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        else
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];

    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

#pragma mark - Delegate

- (void)setWebViewDelegate:(id<UIWebViewDelegate>)webViewDelegate {
    self.webViewController.delegate = webViewDelegate;
}

- (id<UIWebViewDelegate>)webViewDelegate {
    return self.webViewController.delegate;
}

- (void)doneButtonTapped:(id)sender {
    [self.webViewController doneButtonTapped:sender];
    
    if ([self.webViewDelegate respondsToSelector:@selector(controllerDidPressDoneButton:)]) {
        [self.webViewDelegate controllerDidPressDoneButton:self];
    }
}

@end
