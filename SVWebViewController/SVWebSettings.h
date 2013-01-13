//
//  SVWebSettings.h
//  SVWeb
//
//  Created by Ben Pettit on 13/12/12.
//  Copyright 2012 Digimulti. All rights reserved.
//

@interface SVWebSettings : NSObject <NSCoding>

@property BOOL mediaPlaybackRequiresUserAction;
@property BOOL mediaAllowsInlineMediaPlayback;
@property BOOL mediaPlaybackAllowsAirPlay;
@property BOOL isSwipeBackAndForward;
@property BOOL useAddressBarAsSearchBarWhenAddressNotFound;
@property BOOL isUseHTTPSWhenPossible;

@property (strong) UIBarButtonItem *customButton;

@property (nonatomic) id uiWebViewClassType;
@property (strong) id<UIWebViewDelegate> delegate;

@end
