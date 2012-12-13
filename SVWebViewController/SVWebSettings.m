//
//  SVWebSettings.m
//  SVWeb
//
//  Created by eggers on 13/12/12.
//
//

#import "SVWebSettings.h"

@implementation SVWebSettings


- (void)setupMediaSettings
{
    mainWebView.mediaPlaybackRequiresUserAction = self;
    mainWebView.allowsInlineMediaPlayback = SVWebViewMediaAllowsInlineMediaPlayback;
    if([mainWebView respondsToSelector:@selector(mediaPlaybackAllowsAirPlay)])
        mainWebView.mediaPlaybackAllowsAirPlay = SVWebViewMediaPlaybackAllowsAirPlay;
}
@end
