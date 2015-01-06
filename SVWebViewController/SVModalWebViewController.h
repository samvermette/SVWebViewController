//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <UIKit/UIKit.h>

@interface SVModalWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, assign, getter=isBarsTranslucent) BOOL barsTranslucent;
@property (nonatomic, assign) UIBarStyle barsStyle;
@property (nonatomic, assign, getter=toolBarHidden) BOOL toolBarHidden;

@end
