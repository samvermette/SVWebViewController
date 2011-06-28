//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVWebViewController.h"

@interface SVWebViewController (private)

- (void)layoutSubviews;
- (void)setupPhoneToolbar;
- (void)setupTabletToolbar;

- (void)stopLoading;

@end

@implementation SVWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		deviceIsTablet = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
		urlString = nil;
		navItem = nil;
		actionBarButton = nil;
		stoppedLoading = YES;
	}
	
	return self;
}

- (id)initWithAddress:(NSString*)string {
	
	if ([self initWithNibName:@"SVWebViewController" bundle:[NSBundle mainBundle]]) {
		urlString = [string copy];	
	}
		
	return self;
}

- (void)dealloc {
	
	if (urlString) {
		[urlString release];
	}
	
    [super dealloc];
}

- (void)viewDidLoadPhone {
	
	CGRect deviceBounds = [[UIApplication sharedApplication] keyWindow].bounds;
	CGFloat buttonWidth = 18.f;
	
	backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] 
													 style:UIBarButtonItemStylePlain 
													target:rWebView 
													action:@selector(goBack)];
	backBarButton.width = buttonWidth;
	
	forwardBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] 
														style:UIBarButtonItemStylePlain 
													   target:rWebView 
													   action:@selector(goForward)];
	forwardBarButton.width = buttonWidth;
	
	actionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																	target:self 
																	action:@selector(showActions)];
	
	if(self.navigationController == nil) {
		
		UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(deviceBounds),44)];
		navBar.autoresizesSubviews = YES;
		navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					target:self 
																					action:@selector(dismissController)];
		
		rWebView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), CGRectGetWidth(deviceBounds), CGRectGetMinY(toolbar.frame)-88);

		navItem = [[UINavigationItem alloc] initWithTitle:self.title];
		[navBar setItems:[NSArray arrayWithObject:navItem] animated:YES];
		[navItem setLeftBarButtonItem:doneButton animated:YES];

		[self.view addSubview:navBar];
		
		[doneButton release];
		[navBar release];
	}
	
}

- (void)viewDidLoadTablet {
	
	CGRect deviceBounds = [[UIApplication sharedApplication] keyWindow].bounds;
	UINavigationBar *navBar = nil;
	
	[toolbar removeFromSuperview];
	
	if(self.navigationController == nil) {
		
		navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(deviceBounds),44)] autorelease];
		navBar.autoresizesSubviews = YES;
		navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.view addSubview:navBar];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					target:self 
																					action:@selector(dismissController)];
		UINavigationItem *tempItem = [[UINavigationItem alloc] initWithTitle:nil];
		tempItem.leftBarButtonItem = doneButton;
		
		[navBar setItems:[NSArray arrayWithObject:tempItem] animated:YES];
		
		// I wish we could use (automatically localized) doneButton.title, but it's nil
		titleLeftOffset = [@"Done" sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+33;
		[tempItem release];
		[doneButton release];
	}
	
	else {
		
		self.title = nil;
		navBar = self.navigationController.navigationBar;
		navBar.autoresizesSubviews = YES;
		
		NSArray* viewCtrlers = self.navigationController.viewControllers;
		UIViewController* prevCtrler = [viewCtrlers objectAtIndex:[viewCtrlers count]-2];
		titleLeftOffset = [prevCtrler.navigationItem.backBarButtonItem.title sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+26;
	}
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/back"] forState:UIControlStateNormal];
	backButton.frame = CGRectZero;
	[backButton addTarget:rWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	backButton.adjustsImageWhenHighlighted = NO;
	backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	backButton.showsTouchWhenHighlighted = YES;
	
	forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forwardButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/forward"] forState:UIControlStateNormal];
	forwardButton.frame = CGRectZero;
	[forwardButton addTarget:rWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
	forwardButton.adjustsImageWhenHighlighted = NO;
	forwardButton.showsTouchWhenHighlighted = YES;
	
	actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[actionButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/action"] forState:UIControlStateNormal];
	actionButton.frame = CGRectZero;
	[actionButton addTarget:self action:@selector(showActions) forControlEvents:UIControlEventTouchUpInside];
	actionButton.adjustsImageWhenHighlighted = NO;
	actionButton.showsTouchWhenHighlighted = YES;
	
	refreshStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
	refreshStopButton.frame = CGRectZero;
	refreshStopButton.adjustsImageWhenHighlighted = NO;
	refreshStopButton.showsTouchWhenHighlighted = YES;
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.textColor = [UIColor colorWithRed:0.42353 green:0.45098 blue:0.48235 alpha:1.];
	titleLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.7];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.textAlignment = UITextAlignmentRight;
	titleLabel.shadowOffset = CGSizeMake(0, 1);
	
	[navBar addSubview:titleLabel];	
	[navBar addSubview:refreshStopButton];	
	[navBar addSubview:backButton];	
	[navBar addSubview:forwardButton];	
	[navBar addSubview:actionButton];
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
		
	if(!deviceIsTablet)
		[self viewDidLoadPhone];
	else
		[self viewDidLoadTablet];
	
}

- (void)viewDidUnload {
	
	if (navItem) {
		[navItem release];
		navItem = nil;
	}

	if (backBarButton) {
		[backBarButton release];
		backBarButton = nil;
	}
	
	if (forwardBarButton) {
		[forwardBarButton release];
		forwardBarButton = nil;
	}
	
	if (actionBarButton) {
		[actionBarButton release];
		actionBarButton = nil;
	}
	
	if (titleLabel) {
		[titleLabel release];
		titleLabel = nil;
	}
	
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:YES];
	
	if (urlString && [urlString length]) {
		NSURL *searchURL = [NSURL URLWithString:urlString];
		[rWebView loadRequest:[NSURLRequest requestWithURL:searchURL]];
	}
	
	if(!deviceIsTablet)
		[self setupPhoneToolbar];
	else
		[self setupTabletToolbar];
	
	[self layoutSubviews];
	
	if(deviceIsTablet && self.navigationController) {
		titleLabel.alpha = 0;
		refreshStopButton.alpha = 0;
		backButton.alpha = 0;
		forwardButton.alpha = 0;
		actionButton.alpha = 0;
		
		[UIView animateWithDuration:0.3 animations:^{
			titleLabel.alpha = 1;
			refreshStopButton.alpha = 1;
			backButton.alpha = 1;
			forwardButton.alpha = 1;
			actionButton.alpha = 1;
		}];
	}
	
}



- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];

	[self stopLoading];
	
	if(deviceIsTablet && self.navigationController) {
		[UIView animateWithDuration:0.3 animations:^{
			titleLabel.alpha = 0;
			refreshStopButton.alpha = 0;
			backButton.alpha = 0;
			forwardButton.alpha = 0;
			actionButton.alpha = 0;
		}];
	}
	
}

#pragma mark -
#pragma mark Layout Methods

- (void)layoutSubviews {
	
	CGRect deviceBounds = self.view.bounds;
	
	if (deviceIsTablet) {
		if(self.navigationController)
			rWebView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds));
		else
			rWebView.frame = CGRectMake(0, 44, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-44);
		
		backButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-180, 0, 44, 44);
		forwardButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-120, 0, 44, 44);
		actionButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-60, 0, 44, 44);
		refreshStopButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-240, 0, 44, 44);
		titleLabel.frame = CGRectMake(titleLeftOffset, 0, CGRectGetWidth(deviceBounds)-240-titleLeftOffset-5, 44);
	}
	else {
		if(self.navigationController)
			rWebView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-44);
		else
			rWebView.frame = CGRectMake(0, 44, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-88);
	}
	
}


- (void)setupPhoneToolbar {
	
	NSString *evalString = [rWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(self.navigationController != nil)
		self.navigationItem.title = evalString;
	else if (navItem)
		navItem.title = evalString;
	
	if(![rWebView canGoBack])
		backBarButton.enabled = NO;
	else
		backBarButton.enabled = YES;

	if(![rWebView canGoForward])
		forwardBarButton.enabled = NO;
	else
		forwardBarButton.enabled = YES;
		
	UIBarButtonItem *refreshStopBarButton = nil;
	if(rWebView.loading && !stoppedLoading) {
		refreshStopBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop 
																			 target:self 
																			 action:@selector(stopLoading)];
	}		
	else {
		refreshStopBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			 target:rWebView 
																			 action:@selector(reload)];
	}
		
	UIBarButtonItem *flSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	flSeparator.enabled = NO;
	
	NSArray *newButtons = [[NSArray alloc] initWithObjects:backBarButton, flSeparator, forwardBarButton, flSeparator, refreshStopBarButton, flSeparator, actionBarButton, nil];
	[toolbar setItems:newButtons];
	
	[refreshStopBarButton release];
	[flSeparator release];
	[newButtons release];
	
}


- (void)setupTabletToolbar {
	
	titleLabel.text = [rWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(![rWebView canGoBack])
		backButton.enabled = NO;
	else
		backButton.enabled = YES;
	
	if(![rWebView canGoForward])
		forwardButton.enabled = NO;
	else
		forwardButton.enabled = YES;
	
	if(rWebView.loading && !stoppedLoading) {
		[refreshStopButton removeTarget:rWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton addTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/stop"] forState:UIControlStateNormal];
	}
	else {
		[refreshStopButton removeTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton addTarget:rWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
	}
	
}


#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self layoutSubviews];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	stoppedLoading = NO;

	if(!deviceIsTablet)
		[self setupPhoneToolbar];
	else
		[self setupTabletToolbar];
	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	stoppedLoading = YES;

	if(!deviceIsTablet)
		[self setupPhoneToolbar];
	else
		[self setupTabletToolbar];
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	stoppedLoading = YES;
}


#pragma mark -
#pragma mark Action Methods

- (void)stopLoading {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	stoppedLoading = YES;

	[rWebView stopLoading];
	
	if(!deviceIsTablet)
		[self setupPhoneToolbar];
	else
		[self setupTabletToolbar];
	
}

- (void)showActions {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
						  initWithTitle: nil
						  delegate: self 
						  cancelButtonTitle: nil   
						  destructiveButtonTitle: nil   
						  otherButtonTitles: NSLocalizedString(@"Open in Safari", @"Action sheet button"), nil]; 
	
	
	if([MFMailComposeViewController canSendMail])
		[actionSheet addButtonWithTitle:NSLocalizedString(@"Email this", @"Action sheet button")];
	
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"Action sheet button")];
	actionSheet.cancelButtonIndex = [actionSheet numberOfButtons]-1;
	
	if (actionBarButton)
		[actionSheet showFromBarButtonItem:actionBarButton animated:YES];
	else if(!deviceIsTablet)
		[actionSheet showFromToolbar:toolbar];
	else if(!self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -5) inView:self.view animated:YES];
	else if(self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -49) inView:self.view animated:YES];
	
	[actionSheet release];
	
}


- (void)dismissController {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Open in Safari", @"Action sheet button")])
		[[UIApplication sharedApplication] openURL:rWebView.request.URL];
	
	else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Email this", @"Action sheet button")]) {
		
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
		
		[emailComposer setMailComposeDelegate: self]; 
		[emailComposer setSubject:[rWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
		[emailComposer setMessageBody:rWebView.request.URL.absoluteString isHTML:NO];
		emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		[self presentModalViewController:emailComposer animated:YES];
		[emailComposer release];
	}
	
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Property Accessors

- (NSString *)address {
	return urlString;
}

- (void)setAddress:(NSString *)newAddress {

	[self willChangeValueForKey: @"address"];
	if (urlString) {
		[urlString release];
	}
	urlString = [newAddress copy];
	[self didChangeValueForKey: @"address"];

	if (![self isViewLoaded])
		return;

	if (urlString && [urlString length]) {
		NSURL *searchURL = [NSURL URLWithString:urlString];
		[rWebView loadRequest:[NSURLRequest requestWithURL:searchURL]];
	}
	
}

@end
