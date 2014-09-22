//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"

@interface SVWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@end
