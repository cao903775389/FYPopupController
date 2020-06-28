//
//  UIViewController+FYPopup.h
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/28.
//

#import <UIKit/UIKit.h>
#import "FYPopupPresentationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FYPopup)

@property (nonatomic, strong, nullable) FYPopupPresentationController *popUpController;

- (void)show:(UIViewController *)contentViewController;

- (void)show:(UIViewController *)contentViewController style:(FYPopupStyle)style;

@end

NS_ASSUME_NONNULL_END
