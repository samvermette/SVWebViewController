//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <UIKit/UIKit.h>

@class SVModalWebViewController;

@protocol SVModalWebViewControllerDelegate <UIWebViewDelegate>

@optional
- (void)controllerDidPressDoneButton:(SVModalWebViewController *)controller;

@end

@interface SVModalWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithAddress:(NSString*)urlString scalesPageToFit:(BOOL)scalesPageToFit;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL scalesPageToFit:(BOOL)scalesPageToFit;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithURLRequest:(NSURLRequest *)request scalesPageToFit:(BOOL)scalesPageToFit;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, weak) id<SVModalWebViewControllerDelegate> webViewDelegate;

@end
