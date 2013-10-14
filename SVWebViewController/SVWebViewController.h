//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

@protocol SVWebViewDelegate <NSObject>

@optional
- (void)svWebViewDidStartLoad:(UIWebView*)webView;
- (void)svWebViewDidFinishLoad:(UIWebView*)webView;
- (void)svWebView:(UIWebView*)webView didFailLoadWithError:(NSError *)error;

@end


@interface SVWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;
@property (nonatomic, strong) id<SVWebViewDelegate> svDelegate;

@end
