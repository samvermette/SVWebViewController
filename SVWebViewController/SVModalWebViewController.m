//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"


@interface SVWebViewController()
@property (strong) UIWebView *mainWebView;
@end

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;

@end

static const CGFloat kNavBarHeight = 52.0f;
static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;


@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    self = [self initWebViewController:self.webViewController];
    return self;
}

- (id)initWithURL:(NSURL *)URL withView:(UIWebView *)view {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL withView:view];
    self = [self initWebViewController:self.webViewController];
    return self;
}

- (id)initWebViewController:(SVWebViewController *)theWebViewController
{
    self = [super initWithRootViewController:theWebViewController];
    return self;
}

- (void)viewDidLoad
{
    CGRect navBarFrame = self.view.bounds;
    navBarFrame.size.height = kNavBarHeight;
    
    self.navigationBar.frame = navBarFrame;
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addTitleToNavBar:self.navigationBar];
    [self addAddressField:self.addressField intoNavBar:self.navigationBar];
    [self resizeTheWebViewToFitInTheNavBar:self.navigationBar];
}

- (void)addTitleToNavBar:(UINavigationBar *)navBar
{
    CGRect labelFrame = CGRectMake(kMargin, kSpacer,
                                   navBar.bounds.size.width - 2*kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentCenter;
    
    self.pageTitle = label;
    
    [navBar addSubview:label];
}

- (void)addAddressField:(UITextField *)address intoNavBar:(UINavigationBar *)navBar
{
    const NSUInteger WIDTH_OF_NETWORK_ACTIVITY_ANIMATION=4;
    CGRect addressFrame = CGRectMake(kMargin, kSpacer*2.0 + kLabelHeight,
                                     navBar.bounds.size.width - WIDTH_OF_NETWORK_ACTIVITY_ANIMATION*kMargin, kAddressHeight);
    address = [[UITextField alloc] initWithFrame:addressFrame];
    address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.font = [UIFont systemFontOfSize:17];
    [address addTarget:self
                action:@selector(loadAddress:event:)
      forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.addressField = address;
    
    [navBar addSubview:address];
}

- (void)loadAddress:(id)sender event:(UIEvent *)event
{
    NSString* urlString = self.addressField.text;
    BOOL httpProtocolNameFound=NO;
    if (0 ==[urlString rangeOfString:@"http://"].location) {
        httpProtocolNameFound=YES;
        
    } else if (0 ==[urlString rangeOfString:@"https://"].location) {
        httpProtocolNameFound=YES;
    }
    
    if (NO==httpProtocolNameFound) {
        urlString = [@"https://" stringByAppendingString:urlString];
        self.addressField.text = urlString;
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webViewController.mainWebView loadRequest:request];
}

- (void)resizeTheWebViewToFitInTheNavBar:(UINavigationBar *)navBar
{
    CGRect webViewFrame = self.webViewController.mainWebView.frame;
    webViewFrame.origin.y = navBar.frame.origin.y + navBar.frame.size.height;
    webViewFrame.size.height = self.toolbar.frame.origin.y - webViewFrame.origin.y;
    self.webViewController.mainWebView.frame = webViewFrame;
}

- (void)updateTitle:(UIWebView *)webView
{
    NSString* pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    self.navigationBar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

- (void)viewWillLayoutSubviews
{
    if (self.isApplyFullscreenExitViewBoundsSizeFix) {
        [self landscapeOrientationBugFixForExitingFullscreenVideo];
        self.isApplyFullscreenExitViewBoundsSizeFix=NO;
    }
}

- (void)landscapeOrientationBugFixForExitingFullscreenVideo
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint center;
    center.x = self.view.center.x;
    center.y = self.view.center.y;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        if (screenFrame.size.width < screenFrame.size.height) {
            screenFrame.size.width = [UIScreen mainScreen].bounds.size.height;
            screenFrame.size.height = [UIScreen mainScreen].bounds.size.width;
        }
    }
    self.view.bounds = screenFrame;
    self.view.center = center;
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

@end
