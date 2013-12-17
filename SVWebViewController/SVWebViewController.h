//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"

@protocol SVWebViewControllerDelegate <NSObject>

@optional

- (void) webViewControllerWillAppear: (SVWebViewController *) wvc;
- (void) webViewControllerDidAppear:  (SVWebViewController *) wvc;

- (void) webViewControllerWillDisappear: (SVWebViewController *) wvc;
- (void) webViewControllerDidDisappear:  (SVWebViewController *) wvc;

@end

@interface SVWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (weak, nonatomic) id<UIWebViewDelegate, SVWebViewControllerDelegate> delegate;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

#define kDoneButtonClicked  (@selector(doneButtonClicked:))
- (void) doneButtonClicked: (id) sender;

@end
