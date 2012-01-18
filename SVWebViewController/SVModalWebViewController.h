//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <UIKit/UIKit.h>

enum {
    SVWebViewControllerAvailableActionsNone             = 0,
    SVWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    SVWebViewControllerAvailableActionsMailLink         = 1 << 1,
    SVWebViewControllerAvailableActionsCopyLink         = 1 << 2
};

enum {
    SVWebViewControllerDoneBarButtonPositionLeft    = 1,
    SVWebViewControllerDoneBarButtonPositionRight   = 2
};

enum {
    SVWebViewControllerLoadingBarButtonTypeStop                 = 1,
    SVWebViewControllerLoadingBarButtonTypeActivityIndicator    = 2
};

typedef NSUInteger SVWebViewControllerAvailableActions;
typedef NSUInteger SVWebViewControllerDoneBarButtonPosition;
typedef NSUInteger SVWebViewControllerLoadingBarButtonType;

@class SVWebViewController;

@interface SVModalWebViewController : UINavigationController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL *)URL;

@property (nonatomic, retain) UIColor *barsTintColor;
@property (nonatomic, retain) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, assign) SVWebViewControllerAvailableActions availableActions;
@property (nonatomic, assign) SVWebViewControllerDoneBarButtonPosition doneBarButtonPosition;
@property (nonatomic, assign) SVWebViewControllerLoadingBarButtonType loadingBarButtonType;

@end
