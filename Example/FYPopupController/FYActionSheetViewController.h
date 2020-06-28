//
//  FYActionSheetViewController.h
//  FYPopupController_Example
//
//  Created by caofengyang on 2020/6/28.
//  Copyright © 2020 caofengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYActionSheetViewController : UIViewController

+ (FYActionSheetViewController *)actionSheetControllerWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
