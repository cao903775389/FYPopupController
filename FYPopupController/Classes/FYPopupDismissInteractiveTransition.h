//
//  FYPopupDismissInteractiveTransition.h
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPopupDismissInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak, nullable) UIView *presentedView;
@property (nonatomic, weak, nullable) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, copy, nullable) void (^percentBlock)(CGFloat percent);

@end

NS_ASSUME_NONNULL_END
