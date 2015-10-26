//
//  SVWebViewControllerActivity.h
//  SVWeb
//
//  Created by Sam Vermette on 11/11/2013.
//
//

@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface SVWebViewControllerActivity : UIActivity

@property (nonatomic, strong) NSURL *URLToOpen;
@property (nonatomic, strong) NSString *schemePrefix;

@end
NS_ASSUME_NONNULL_END
