//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

-(NSArray *)excludedActivityTypes {
    return self.webViewController.excludedActivityTypes;
}

-(void)setExcludedActivityTypes:(NSArray *)excludedActivityTypes {
    self.webViewController.excludedActivityTypes = excludedActivityTypes;
}

-(NSArray *)applicationActivities {
    return self.webViewController.excludedActivityTypes;
}

-(void)setApplicationActivities:(NSArray *)applicationActivities {
    self.webViewController.applicationActivities = applicationActivities;
}

-(void)setAlwaysShowNavigationBar:(BOOL)alwaysShowNavigationBar {
    self.webViewController.alwaysShowNavigationBar = alwaysShowNavigationBar;
}

-(BOOL)alwaysShowNavigationBar {
    return self.webViewController.alwaysShowNavigationBar;
}

@end
