//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

@class SVWebSettings;

@interface SVWebViewController : UIViewController <UISplitViewControllerDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate>

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)loadURL:(NSURL*)URL;
- (void)loadAddress:(NSString*)address;

@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong) SVWebSettings *settings;

@end
