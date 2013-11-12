//
//  SVWebViewControllerActivityMail.h
//
//  Created by Benjamin Michotte on 12 Nov, 2013.
//  Copyright 2013 Benjamin Michotte. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewControllerActivityMail.h"
#import <MessageUI/MessageUI.h>

@interface SVWebViewControllerActivityMail() <MFMailComposeViewControllerDelegate>
@end

@implementation SVWebViewControllerActivityMail

- (NSString *)activityTitle {
    return NSLocalizedStringFromTable(@"Mail this Page", @"SVWebViewController", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]
                && [[UIApplication sharedApplication] canOpenURL:activityItem]
                && [MFMailComposeViewController canSendMail]
                && self.webView) {
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)activityViewController {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];

    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    NSString *pageContent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    if (pageContent && ![pageContent isEqualToString:@""]) {
        [mailViewController setMessageBody:pageContent isHTML:YES];
    }
    else {
        NSData *pageData = [NSData dataWithContentsOfURL:self.URLToOpen];
        NSDictionary *mimeBundle = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SVWebViewController.bundle/MIME" ofType:@"plist"]];
        NSString *mimeType = [mimeBundle objectForKey:[self.URLToOpen pathExtension]];
        if (mimeType) {
            [mailViewController addAttachmentData:pageData mimeType:mimeType fileName:[self.URLToOpen lastPathComponent]];
        }
    }

    mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;

    return mailViewController;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    BOOL completed = result == MFMailComposeResultSaved || result == MFMailComposeResultSent;
    [self activityDidFinish:completed];
}

@end