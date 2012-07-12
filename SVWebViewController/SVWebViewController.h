//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

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


@interface SVWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, readwrite) BOOL alwaysShowNavigationBar;

@end
