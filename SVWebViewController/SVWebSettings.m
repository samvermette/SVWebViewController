//
//  SVWebSettings.m
//  SVWeb
//
//  Created by eggers on 13/12/12.
//
//

#import "SVWebSettings.h"

@implementation SVWebSettings

- (id)init
{
    self = [super init];
    
    if (nil!=self) {
        [self loadDefaults];
    }
    
    return self;
}

- (void)loadDefaults
{
    self.isSwipeBackAndForward = NO;
    self.mediaAllowsInlineMediaPlayback = YES;
    self.mediaPlaybackAllowsAirPlay = YES;
    self.mediaPlaybackRequiresUserAction = NO;
}

@end
