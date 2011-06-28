//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface SVWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UIWebView *rWebView;
	NSString *urlString;
	
	// iPhone UI
	UINavigationItem *navItem;
	IBOutlet UIBarButtonItem *backBarButton, *forwardBarButton, *actionBarButton;
	IBOutlet UIToolbar *toolbar;
	
	// iPad UI
	UIButton *backButton, *forwardButton, *refreshStopButton, *actionButton;
	UILabel *titleLabel;
	CGFloat titleLeftOffset;
	
	BOOL deviceIsTablet, stoppedLoading;
}

@property (nonatomic, assign) NSString *address;
- (id)initWithAddress:(NSString*)string;

@end
