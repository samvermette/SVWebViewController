//
//  RootViewController.h
//  SVWebViewController
//
//  Created by Sam Vermette on 21.02.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *useActivityViewControllerSwitch;

- (IBAction)pushWebViewController;
- (IBAction)presentWebViewController;

@end
