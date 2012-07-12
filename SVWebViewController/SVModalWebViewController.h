//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <UIKit/UIKit.h>

@class SVWebViewController;

@interface SVModalWebViewController : UINavigationController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL *)URL;

@property (nonatomic, strong) UIColor *barsTintColor;

@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, readwrite) BOOL alwaysShowNavigationBar;

@end

@interface SVActivity : NSObject 

@property (strong, readonly) UIWebView *webView;

- (NSString *)activityTitle;
- (UIViewController *)activityViewController;
- (void)performActivity;

- (void)activityDidFinish:(BOOL)completed;

@end

extern NSString *const SVActivityTypeSafari;
extern NSString *const SVActivityTypeMail;
extern NSString *const SVActivityTypeCopyToPasteboard;
