//
//  SVWebSettings.h
//  SVWeb
//
//  Created by eggers on 13/12/12.
//
//

#import <Foundation/Foundation.h>

@interface SVWebSettings : NSObject

@property BOOL mediaPlaybackRequiresUserAction;
@property BOOL mediaAllowsInlineMediaPlayback;
@property BOOL mediaPlaybackAllowsAirPlay;
@property BOOL isSwipeBackAndForward;
@property (strong) id<UIWebViewDelegate> delegate;

@end
