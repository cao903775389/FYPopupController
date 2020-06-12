//
//  FYPopupTransitionDelegate.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/10.
//

#import "FYPopupController.h"
#import "FYPopupPresentTransition.h"
#import "FYPopupPresentationController.h"

@interface FYPopupController ()

@property (nonatomic, strong, nullable) FYPopupPresentTransition *presentTransition;


@end

@implementation FYPopupController

- (void)dealloc {
    NSLog(@"%@ delloc", [self class]);
}

- (instancetype)init {
    if (self = [super init]) {
        _presentTransition = [[FYPopupPresentTransition alloc] init];
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
///  animation for present and dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _presentTransition.isPresenting = YES;
    return _presentTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _presentTransition.isPresenting = NO;
    return _presentTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[FYPopupPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
