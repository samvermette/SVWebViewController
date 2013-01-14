//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"
#import "SVWebSettings.h"

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *customBarButtonItem;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) SVWebSettings *settings;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end


@implementation SVWebViewController

@synthesize availableActions;

@synthesize mainWebView;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, customBarButtonItem, pageActionSheet;

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return actionBarButtonItem;
}

- (UIBarButtonItem *)customBarButtonItem {
    
    if (nil!=self.settings.customButton && !customBarButtonItem) {
        customBarButtonItem = self.settings.customButton;
    }
    
    return customBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    
    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc]
                           initWithTitle:self.mainWebView.request.URL.absoluteString
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Copy Link", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & SVWebViewControllerAvailableActionsMailLink) == SVWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link to this Page", @"")];
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [backButton setImage:[UIImage imageNamed:@"BackButton"]  forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
        self.URL = pageURL;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
        
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = self.class;
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)URL withSettings:(SVWebSettings *)settings
{
    self = [self initWithURL:URL];
    
    if (nil!=self) {
        self.settings = settings;
    }
    
    return self;
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadURL:(NSURL*)url
{
    [mainWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.URL = url;
}

- (void)loadAddress:(NSString*)address;
{
    [self loadURL:[NSURL URLWithString:address]];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    UIWebView *uiWebView = [[self.settings.uiWebViewClassType alloc] initWithFrame:self.view.frame];
    uiWebView.restorationIdentifier=NSStringFromClass(uiWebView.class);
    self.view = uiWebView;
    self.mainWebView = uiWebView;
    
    if (nil!=self.URL) {
        [self loadURL:self.URL];
    }
    
    self.mainWebView.delegate = self;
    self.mainWebView.scalesPageToFit = YES;
    
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.hidesWhenStopped = YES;
    [self.indicator stopAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    
    [self updateToolbarItems];
    
    if (nil!=self.settings) {
        if (YES==self.settings.isSwipeBackAndForward) {
            [self setupSwipeGestures:self.mainWebView];
        }
        [self setupMediaSettings];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    self.indicator.center = self.mainWebView.center;
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc
{
    [mainWebView stopLoading];
 	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    mainWebView.delegate = nil;
}

#pragma mark - Media player settings

- (void)setupMediaSettings
{
    mainWebView.mediaPlaybackRequiresUserAction = self.settings.mediaPlaybackRequiresUserAction;
    mainWebView.allowsInlineMediaPlayback = self.settings.mediaAllowsInlineMediaPlayback;
    if([mainWebView respondsToSelector:@selector(mediaPlaybackAllowsAirPlay)])
        mainWebView.mediaPlaybackAllowsAirPlay = self.settings.mediaPlaybackAllowsAirPlay;
}

#pragma mark - Gestures

- (void)setupSwipeGestures:(UIWebView *)webView
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [webView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [webView addGestureRecognizer:swipeLeft];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)swipeRightAction:(id)ignored
{
    NSLog(@"Swipe Right");
        //add Function
    [self.mainWebView goBack];
}

- (void)swipeLeftAction:(id)ignored
{
    NSLog(@"Swipe Left");
        //add Function
    [self.mainWebView goForward];
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = YES;//self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = YES;//self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = YES;//!self.mainWebView.isLoading;
    self.refreshBarButtonItem.enabled = YES;
    
    UIBarButtonItem *refreshStopBarButtonItem = /*self.mainWebView.isLoading ? self.stopBarButtonItem :*/ self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    NSMutableArray *items = [NSMutableArray arrayWithObjects:
                 fixedSpace,
                 self.backBarButtonItem,
                 flexibleSpace,
                 self.forwardBarButtonItem,
                 flexibleSpace,
                 refreshStopBarButtonItem,
                 fixedSpace,
                 nil];
    
    if(0!=self.availableActions) {
        [items insertObject:flexibleSpace atIndex:items.count-1];
        [items insertObject:self.actionBarButtonItem atIndex:items.count-1];
    }
    
    if (nil!=self.settings.customButton) {
        self.customBarButtonItem.enabled = YES;
        [items insertObject:flexibleSpace atIndex:items.count-1];
        [items insertObject:self.customBarButtonItem atIndex:items.count-1];
    }
    
    self.toolbarItems = items;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (nil!=self.settings.delegate) {
        if ([self.settings.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
            [self.settings.delegate webViewDidStartLoad:webView];
        }
    }
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.indicator startAnimating];
    
    [self updateToolbarItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (nil!=self.settings.delegate) {
        if ([self.settings.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
            [self.settings.delegate webViewDidFinishLoad:webView];
        }
    }
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.indicator stopAnimating];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    
    if (nil!=self.settings.delegate) {
        if ([self.settings.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
            [self.settings.delegate webView:webView didFailLoadWithError:error];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL isStartLoad=YES;
    
    if (nil!=self.settings.delegate) {
        if ([self.settings.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
            [self.settings.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        }
    }
    
    return isStartLoad;
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    if(pageActionSheet)
        return;
	
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    else
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:NSLocalizedString(@"Open in Safari", @"")])
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    
    if([title isEqualToString:NSLocalizedString(@"Copy Link", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }
    
    else if([title isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"")]) {
        
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		[self presentModalViewController:mailViewController animated:YES];
#else
        [self presentViewController:mailViewController animated:YES completion:NULL];
#endif
	}
    
    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
	[self dismissModalViewControllerAnimated:YES];
#else
    [self dismissViewControllerAnimated:YES completion:NULL];
#endif
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Bookmarks", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - UI State Restoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    SVWebViewController *thisViewController=nil;
    
    if ([[identifierComponents objectAtIndex:0] isEqualToString:NSStringFromClass(SVModalWebViewController.class)]) {
        SVModalWebViewController *modalView = [coder decodeObjectForKey:NSStringFromClass(UINavigationController.class)];
        thisViewController = modalView.webViewController;
        
    } else {
        SVWebSettings *settings = [coder decodeObjectForKey:NSStringFromClass(SVWebSettings.class)];
        thisViewController = [[SVWebViewController alloc] initWithURL:nil withSettings:settings];
        thisViewController.restorationIdentifier = identifierComponents.lastObject;
        thisViewController.restorationClass = self.class;
    }
    
    return thisViewController;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.navigationController forKey:NSStringFromClass(UINavigationController.class)];
    
    [coder encodeObject:self.settings forKey:NSStringFromClass(self.settings.class)];
    [coder encodeObject:self.URL forKey:[SVWebViewController KEY_URL]];
    [coder encodeObject:self.mainWebView forKey:[SVWebViewController KEY_WEBVIEW]];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.URL = [coder decodeObjectForKey:[SVWebViewController KEY_URL]];
    self.mainWebView = [coder decodeObjectForKey:[SVWebViewController KEY_WEBVIEW]];
}

+ (NSString *)KEY_URL
{
    return @"URL";
}

+ (NSString *)KEY_WEBVIEW
{
    return @"WEBVIEW";
}

@end
