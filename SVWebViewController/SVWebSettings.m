//
//  SVWebSettings.m
//  SVWeb
//
//  Created by Ben Pettit on 13/12/12.
//  Copyright 2012 Digimulti. All rights reserved.
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
