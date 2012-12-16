//
//  SVWebSettings.h
//  SVWeb
//
//  Created by Ben Pettit on 13/12/12.
//  Copyright 2012 Digimulti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVWebSettings : NSObject

@property BOOL mediaPlaybackRequiresUserAction;
@property BOOL mediaAllowsInlineMediaPlayback;
@property BOOL mediaPlaybackAllowsAirPlay;
@property BOOL isSwipeBackAndForward;
@property (strong) id<UIWebViewDelegate> delegate;

@end
