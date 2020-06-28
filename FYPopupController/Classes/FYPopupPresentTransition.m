//
//  FYPopupPresentTransition.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/11.
//

#import "FYPopupPresentTransition.h"

@implementation FYPopupPresentTransition

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

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
    
    __unused CGRect toInitFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    if (_isPresenting) {
        // For a presentation, the toView starts off-screen and slides in.
        toView.frame = CGRectMake(0, containerView.frame.size.height, toFinalFrame.size.width, toFinalFrame.size.height);
    } else {
        fromFinalFrame = CGRectMake(0, containerView.frame.size.height, fromFinalFrame.size.width, fromFinalFrame.size.height);
    }
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (self.isPresenting) {
            toView.frame = toFinalFrame;
        } else {
            fromView.frame = fromFinalFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
