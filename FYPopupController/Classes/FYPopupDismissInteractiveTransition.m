//
//  FYPopupDismissInteractiveTransition.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/24.
//

#import "FYPopupDismissInteractiveTransition.h"

@interface FYPopupDismissInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, weak) UIViewController *presentingController;

@end

@implementation FYPopupDismissInteractiveTransition

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (void)setGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    _gestureRecognizer = gestureRecognizer;
    [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    self.presentingController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toView];
    self.toView = toView;
}

#pragma mark - Private Methods
- (CGFloat)_percentForGesture:(UIPanGestureRecognizer *)gesture {
    if (self.presentedView) {
        CGFloat translation = [gesture translationInView:self.presentedView].y;
        CGFloat height = self.presentedView.frame.size.height;
        CGFloat percent = height == 0.f ? 0.f : MAX(0.f, translation / height);
        return percent;
    }
    return 0.f;
}

- (void)_panGestureChanged:(UIPanGestureRecognizer *)gesture {
    if (self.presentedView) {
        CGFloat percent = [self _percentForGesture:gesture];
        self.presentedView.transform = CGAffineTransformMakeTranslation(0, percent * self.presentedView.frame.size.height);
        [self updateInteractiveTransition:percent];
        if (self.percentBlock) {
            self.percentBlock(percent);
        }
    }
}

- (void)_panGestureEnded:(UIPanGestureRecognizer *)gesture {
    CGFloat percent = [self _percentForGesture:gesture];
    if (percent >= 0.5f) {
        [self _done];
    } else {
        [self _cancel];
    }
}

- (void)_done {
    [self finishInteractiveTransition];
    [UIView animateWithDuration:0.25 animations:^{
        self.presentedView.transform = CGAffineTransformMakeTranslation(0, self.presentedView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:YES];
        if (self.percentBlock) {
            self.percentBlock(1.0);
        }
    }];
}

- (void)_cancel {
    [self cancelInteractiveTransition];
    [UIView animateWithDuration:0.25 animations:^{
        self.presentedView.transform = CGAffineTransformIdentity;
        [self.toView removeFromSuperview];
        [self.transitionContext completeTransition:NO];
        if (self.percentBlock) {
            self.percentBlock(0.0);
        }
    }];
}

#pragma mark - UIPanGestureRecognizer
- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            // We have been dragging! Update the transition context accordingly.
            [self _panGestureChanged:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            [self _panGestureEnded:gestureRecognizer];
            break;
        default:
            // Something happened. cancel the transition.
            [self _cancel];
            break;
    }
}

@end
