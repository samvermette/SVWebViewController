//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

@import UIKit;

@protocol SVWebViewControllerDelegate;
@protocol SVWebViewPresenter <UIWebViewDelegate, SVWebViewControllerDelegate>
@end

@interface SVWebViewController : UIViewController

@property (nonatomic) UIWebView *webView;
@property (weak, nonatomic) id<SVWebViewPresenter> delegate;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

#define kDoneButtonClicked  (@selector(doneButtonClicked:))
- (void) doneButtonClicked: (id) sender;

@end

@protocol SVWebViewControllerDelegate <NSObject>

@optional

- (void) webViewControllerWillAppear: (SVWebViewController *) wvc;
- (void) webViewControllerDidAppear:  (SVWebViewController *) wvc;

- (void) webViewControllerWillDisappear: (SVWebViewController *) wvc;
- (void) webViewControllerDidDisappear:  (SVWebViewController *) wvc;

@end
