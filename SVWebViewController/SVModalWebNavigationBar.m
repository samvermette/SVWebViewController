//
//  SVModalWebNavigationBar.m
//
//  Created by Ben Pettit on 4/2/13.
//  Copyright 2013 Digimulti. All rights reserved.
//
// Thanks to Mackross for his answer at this page: http://stackoverflow.com/questions/2133257/iphone-how-set-uinavigationbar-height


#import "SVModalWebNavigationBar.h"


#pragma mark - Declaration

@interface SVModalWebNavigationBar()

@property CGFloat originalNavigationBarHeight;
@property CGAffineTransform originalTransform;

@end

static CGFloat const CustomNavigationBarHeight = 44;
static CGFloat const NavigationBarHeight = 44;
static CGFloat const CustomNavigationBarHeightDelta = CustomNavigationBarHeight - NavigationBarHeight;


#pragma mark - Definition

@implementation SVModalWebNavigationBar

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [self resetBackgroundImageFrame];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        size.width = self.frame.size.width;
        size.height = CustomNavigationBarHeight;
        
    } else {
        size = [super sizeThatFits:size];
    }
    
    return size;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform translate;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        translate = CGAffineTransformMakeTranslation(0, -CustomNavigationBarHeightDelta / 2.0);
        [self resetBackgroundImageFrame];
    } else {
        translate = CGAffineTransformMakeTranslation(0, +CustomNavigationBarHeightDelta / 2.0);
    }
    self.transform = translate;
}

- (void)resetBackgroundImageFrame
{
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"BarBackground"].length != 0) {
            view.frame = CGRectMake(0, CustomNavigationBarHeightDelta / 2.0, self.bounds.size.width, self.bounds.size.height);
        }
    }
}

@end