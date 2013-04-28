//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"

extern BOOL SVWebViewMediaPlaybackRequiresUserAction;
extern BOOL SVWebViewMediaAllowsInlineMediaPlayback;
extern BOOL SVWebViewMediaPlaybackAllowsAirPlay;

@interface SVWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, readwrite) BOOL alwaysShowNavigationBar;

@end
