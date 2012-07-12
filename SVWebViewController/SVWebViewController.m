//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"

@interface SVActivity()

@property (nonatomic, strong) SVWebViewController* webViewController;

@end

@interface SVActivitySafari : SVActivity
@end

NSString *const SVActivityTypeSafari = @"activity.Safari";

@interface NSActivityCopyToPasteboard : SVActivity
@end

NSString *const SVActivityTypeCopyToPasteboard = @"activity.CopyToPasteboard";

@interface SVActivityMail : SVActivity<MFMailComposeViewControllerDelegate>
@end

NSString *const SVActivityTypeMail = @"activity.Mail";

#pragma mark -
#pragma mark SVWebViewController

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;
@property (nonatomic, strong, readonly) NSArray *presentedActivities;
@property (nonatomic, strong, readonly) UIViewController *presentedActivityViewController;
@property (nonatomic, strong, readonly) SVActivity *selectedActivity;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, readonly) UIScrollView *webViewScrollView;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

- (void)updateWebViewScrollViewContentInset;
- (void)updateNavigationBarPositionWithAnimationAndReset:(BOOL)animationAndReset;

- (BOOL)hasActivities;
- (void)activityDidFinish:(SVActivity*)activity;

@end

@implementation SVWebViewController

@synthesize excludedActivityTypes, applicationActivities;

@synthesize URL, mainWebView, alwaysShowNavigationBar;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem;
@synthesize pageActionSheet, presentedActivities, selectedActivity, presentedActivityViewController;

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

- (BOOL)hasActivities {
    if(self.applicationActivities.count > 0)
        return YES;
    NSMutableArray *remainingBuiltinActivityTypes = [NSMutableArray arrayWithObjects:SVActivityTypeSafari, SVActivityTypeMail, SVActivityTypeCopyToPasteboard, nil];
    [remainingBuiltinActivityTypes removeObjectsInArray:self.excludedActivityTypes];
    return remainingBuiltinActivityTypes.count > 0;
}

- (NSArray*)presentedActivities {
    if(!presentedActivities) {
        NSMutableArray* activities = [NSMutableArray array];
        if(![self.excludedActivityTypes containsObject:SVActivityTypeSafari])
           [activities addObject:[SVActivitySafari new]];
        if(![self.excludedActivityTypes containsObject:SVActivityTypeMail])
            [activities addObject:[SVActivityMail new]];
        if(![self.excludedActivityTypes containsObject:SVActivityTypeCopyToPasteboard])
            [activities addObject:[NSActivityCopyToPasteboard new]];
        
        presentedActivities = activities;
    }
    return presentedActivities;
}

- (UIActionSheet *)pageActionSheet {
    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc] 
                        initWithTitle:self.mainWebView.request.URL.absoluteString
                        delegate:self 
                        cancelButtonTitle:nil   
                        destructiveButtonTitle:nil   
                        otherButtonTitles:nil]; 

        for(SVActivity* activity in self.presentedActivities) {
            [pageActionSheet addButtonWithTitle:activity.activityTitle];
        }
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if(self) {
        self.alwaysShowNavigationBar = YES;
        self.excludedActivityTypes = [NSArray arrayWithObject:SVActivityTypeCopyToPasteboard];
    }
    return self;
}

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [self init]) {
        self.URL = pageURL;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    self.webViewScrollView.delegate = self;
    [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    self.view = mainWebView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
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
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

-(void)viewWillLayoutSubviews {
    [self updateWebViewScrollViewContentInset];
    [self updateNavigationBarPositionWithAnimationAndReset:NO];
    
    [super viewWillLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && ![self.parentViewController isKindOfClass:SVModalWebViewController.class]) {
        [self updateNavigationBarPositionWithAnimationAndReset:YES];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items;
        CGFloat toolbarWidth = 250.0f;
        
        if(!self.hasActivities) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     fixedSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    } 
    
    else {
        NSArray *items;
        
        if(!self.hasActivities) {
            items = [NSArray arrayWithObjects:
                     flexibleSpace,
                     self.backBarButtonItem, 
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
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
        }
        
        self.toolbarItems = items;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
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

- (void)doneButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex < presentedActivities.count) {
        selectedActivity = [presentedActivities objectAtIndex:buttonIndex];
        selectedActivity.webViewController = self;
        
        presentedActivityViewController = selectedActivity.activityViewController;
        if(presentedActivityViewController) {
            [self presentModalViewController:presentedActivityViewController animated:YES];
        } else {
            [selectedActivity performActivity];
        }
    }
    pageActionSheet = nil;
    presentedActivities = nil;
}

- (void)activityDidFinish:(SVActivity*)activity {
    [self.presentedActivityViewController dismissModalViewControllerAnimated:YES];
    selectedActivity = nil;
    presentedActivityViewController = nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate / alwaysShowNavigationBar

-(UIScrollView *)webViewScrollView {
    return [self.mainWebView.subviews lastObject];
}

-(void)setAlwaysShowNavigationBar:(BOOL)value {
    alwaysShowNavigationBar = value;
    [self updateWebViewScrollViewContentInset];
}

-(void)updateWebViewScrollViewContentInset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(self.navigationController.navigationBar) {
            self.webViewScrollView.contentInset = self.alwaysShowNavigationBar ? UIEdgeInsetsZero
                : UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0);
            if(!pageActionSheet) // prevent scrolling when showing action sheet
                self.webViewScrollView.contentOffset = CGPointMake(0, -self.webViewScrollView.contentInset.top);
        }
        self.mainWebView.frame = CGRectMake(0, -self.webViewScrollView.contentInset.top, self.mainWebView.superview.frame.size.width, self.mainWebView.superview.frame.size.height+self.webViewScrollView.contentInset.top);
    }
}

- (void)updateNavigationBarPositionWithAnimationAndReset:(BOOL)animationAndReset {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !self.alwaysShowNavigationBar) {
        if(animationAndReset) {
            [UIView beginAnimations:@"navigationBarAnimation" context:nil];
        }
        UINavigationBar *navBar = self.navigationController.navigationBar;
        CGRect navRect = navBar.frame;
        navRect.origin = [navBar.superview convertPoint:CGPointMake(0, 0) fromView:self.mainWebView];
        if(!animationAndReset)
            navRect.origin.y -= self.webViewScrollView.contentOffset.y + self.webViewScrollView.contentInset.top;
        navBar.frame = navRect;
        if(animationAndReset){
            [UIView commitAnimations];
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.mainWebView.loading && -scrollView.contentOffset.y < scrollView.contentInset.top) {
        scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !self.alwaysShowNavigationBar) {
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MAX(scrollView.contentInset.top, - scrollView.contentOffset.y), 0, 0, 0);
    } else {
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self updateNavigationBarPositionWithAnimationAndReset:NO];
}

@end

#pragma mark -
#pragma mark SVActivities

@implementation SVActivity

@synthesize webViewController;

-(UIWebView *)webView {
    return webViewController.mainWebView;
}

- (void)activityDidFinish:(BOOL)completed {
    [self.webViewController activityDidFinish:self];
}

-(NSString *)activityTitle {
    // to be implemented by descendent
    return nil;
}

- (UIViewController *)activityViewController {
    // to be implemented by descendent if it does not provied performActivity
    return nil;
}

-(void)performActivity {
    // to be implemented by descendent if it does not provied activityViewController
}

@end


@implementation SVActivitySafari

-(NSString *)activityTitle {
    return NSLocalizedString(@"Open in Safari", @"");
}

-(void)performActivity {
    BOOL succeeded = [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    [self activityDidFinish:succeeded];
}

@end

@implementation SVActivityMail

-(NSString *)activityTitle {
    return NSLocalizedString(@"Mail Link to this Page", @"");
}

-(UIViewController *)activityViewController {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    [mailViewController setMessageBody:self.webView.request.URL.absoluteString isHTML:NO];
    mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return mailViewController;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error 
{
	[self activityDidFinish:result == MFMailComposeResultSaved || result == MFMailComposeResultSent];
}

@end

@implementation NSActivityCopyToPasteboard

-(NSString *)activityTitle {
    return NSLocalizedString(@"Copy Link", @"");
}

-(void)performActivity {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.webView.request.URL.absoluteString;
    [self activityDidFinish:YES];
}

@end