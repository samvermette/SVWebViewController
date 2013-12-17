//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityChrome.h"
#import "SVWebViewControllerActivitySafari.h"
#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic) NSUInteger webViewLoads;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)loadURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {

    UIWebView *wv = self.webView;

    [wv stopLoading];

    [NSOperationQueue.mainQueue addOperationWithBlock: ^{

        [wv loadRequest:
         [NSURLRequest requestWithURL: [NSURL URLWithString: @"about:blank"]]];
    }];
    if (!self.delegate) {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    wv.delegate = nil;
    self.delegate = nil;
}

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
    }
    
    return self;
}

- (void)loadURL:(NSURL *)pageURL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:pageURL]];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.webView;
    [self loadURL:self.URL];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _actionBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    id<SVWebViewControllerDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webViewControllerWillAppear:)]) {

        [delegate webViewControllerWillAppear: self];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    id<SVWebViewControllerDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webViewControllerDidAppear:)]) {

        [delegate webViewControllerDidAppear: self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    id<SVWebViewControllerDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webViewControllerWillDisappear:)]) {

        [delegate webViewControllerWillDisappear: self];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    id<SVWebViewControllerDelegate> delegate = self.delegate;

    if (!delegate) {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if ([delegate respondsToSelector: @selector(webViewControllerDidDisappear:)]) {

        [delegate webViewControllerDidDisappear: self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (UIWebView*)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerBack"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goBackClicked:)];
		_backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerNext"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(goForwardClicked:)];
		_forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
    self.actionBarButtonItem.enabled = !self.webViewLoads;

    UIBarButtonItem *refreshStopBarButtonItem = self.webViewLoads ? self.stopBarButtonItem : self.refreshBarButtonItem;

    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 35.0f;

        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          nil];

        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }

    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];

        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    id<UIWebViewDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webView:shouldStartLoadWithRequest:navigationType:)]) {

        return [delegate webView: webView shouldStartLoadWithRequest: request navigationType: navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

    self.webViewLoads++;
    [self updateToolbarItems];

    id<UIWebViewDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webViewDidStartLoad:)]) {

        [delegate webViewDidStartLoad: webView];
    }
    else { [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.webViewLoads = self.webViewLoads ? --self.webViewLoads : 0;
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self updateToolbarItems];

    id<UIWebViewDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webViewDidFinishLoad:)]) {

        [delegate webViewDidFinishLoad: webView];
    }
    else { [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    self.webViewLoads = self.webViewLoads ? --self.webViewLoads : 0;
    [self updateToolbarItems];

    id<UIWebViewDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector: @selector(webView:didFailLoadWithError:)]) {

        [delegate webView: webView didFailLoadWithError: error];
    }
    else { [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; }
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    self.webViewLoads = 0;
    [self.webView reload];
    [self updateToolbarItems];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    self.webViewLoads = 0;
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.request.URL] applicationActivities:activities];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)doneButtonClicked:(id)sender {
    [self.webView stopLoading];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
