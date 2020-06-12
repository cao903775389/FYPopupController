//
//  FYPopupPresentTransition.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/11.
//

#import "FYPopupPresentTransition.h"

@implementation FYPopupPresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? 0.35 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = transitionContext.containerView;

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    __unused CGRect fromInitFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    
    CGRect toInitFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    if (self.isPresenting) {
        // Present
        toInitFrame.origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
        toInitFrame.size = toFinalFrame.size;
        toView.frame = toInitFrame;
    } else {
        // Dismiss
        fromFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (self.isPresenting) {
            toView.frame = toFinalFrame;
        } else {
            fromView.frame = fromFinalFrame;
        }
    } completion:^(BOOL finished) {
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition
        // finished or not.
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
