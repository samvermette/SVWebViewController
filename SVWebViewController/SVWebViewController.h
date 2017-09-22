//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

@interface SVWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithAddress:(NSString*)urlString scalesPageToFit:(BOOL)scalesPageToFit;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURL:(NSURL*)URL scalesPageToFit:(BOOL)scalesPageToFit;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithURLRequest:(NSURLRequest*)request scalesPageToFit:(BOOL)scalesPageToFit;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

@end
