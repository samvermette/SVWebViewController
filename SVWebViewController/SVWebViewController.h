//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface SVWebViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UIWebView *rWebView;
    UINavigationBar *navBar;
    UIToolbar *toolbar;
    
	// iPhone UI
	UINavigationItem *navItem;
	UIBarButtonItem *backBarButton, *forwardBarButton, *refreshStopBarButton, *actionBarButton;
	
	// iPad UI
	UIButton *backButton, *forwardButton, *refreshStopButton, *actionButton;
	UILabel *titleLabel;
	CGFloat titleLeftOffset;
	
	BOOL deviceIsTablet, stoppedLoading;
	BOOL _obtrusiveNavBar;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, assign) BOOL obtrusiveNavBar;

- (SVWebViewController*)initWithAddress:(NSString*)string;

@end
