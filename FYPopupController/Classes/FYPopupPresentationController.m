//
//  FYPopupPresentationController.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/12.
//

#import "FYPopupPresentationController.h"
#import "FYPopupPresentTransition.h"
#import "FYPopupDismissInteractiveTransition.h"

static CGFloat const kDefaultDimAlpha = 0.5;

@interface FYPopupPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationWrappingView;
@property (nonatomic, weak) UIView *presentedViewControllerView;
@property (nonatomic, strong) UIPanGestureRecognizer *interactivePanGesture;
@property (nonatomic, strong) FYPopupPresentTransition *presentTransition;
@property (nonatomic, strong) FYPopupDismissInteractiveTransition *interactiveTransition;

@end

@implementation FYPopupPresentationController

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        _presentTransition = [[FYPopupPresentTransition alloc] init];
    }
    return self;
}

- (FYPopupDismissInteractiveTransition *)interactiveTransition {
    if (!_interactiveTransition) {
        _interactiveTransition = [[FYPopupDismissInteractiveTransition alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        _interactiveTransition.percentBlock = ^(CGFloat percent) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.dimmingView.alpha = kDefaultDimAlpha * (1.0 - percent);
        };
    }
    return _interactiveTransition;
}

- (void)setStyle:(FYPopupStyle)style {
    _style = style;
    switch (style) {
        case FYPopupStyleDefault:
            self.cornerRadius = 0.f;
            break;
        case FYPopupStyleRoundedCorner:
            self.cornerRadius = 16;
        default:
            break;
    }
}

#pragma mark - Over load
- (UIView*)presentedView {
    return self.presentationWrappingView;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
    self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView;
}

- (void)presentationTransitionWillBegin {
    // The default implementation of -presentedView returns
    // self.presentedViewController.view.
    UIView *presentedViewControllerView = [super presentedView];
    self.presentedViewControllerView = presentedViewControllerView;
    {
        // WrapperView
        UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
        self.presentationWrappingView = presentationWrapperView;
        
        // Corner Mask
        UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -_cornerRadius, 0))];
        presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;        
        presentationRoundedCornerView.layer.cornerRadius = _cornerRadius;
        presentationRoundedCornerView.layer.masksToBounds = YES;
        
        // Present ContentView WrapperView
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, _cornerRadius, 0))];
        presentedViewControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Add presentedViewControllerView -> presentedViewControllerWrapperView.
        presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds;
        [presentedViewControllerWrapperView addSubview:presentedViewControllerView];
        
        // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
        [presentationRoundedCornerView addSubview:presentedViewControllerWrapperView];
        
        // Add presentationRoundedCornerView -> presentationWrapperView.
        [presentationWrapperView addSubview:presentationRoundedCornerView];
        
        // Add Gesture
        self.interactivePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
        [presentationWrapperView addGestureRecognizer:_interactivePanGesture];
    }
    
    {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.opaque = NO;
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
        self.dimmingView = dimmingView;
        [self.containerView addSubview:dimmingView];
        
        // Get the transition coordinator for the presentation so we can
        // fade in the dimmingView alongside the presentation animation.
        id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
        
        self.dimmingView.alpha = 0.f;
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = kDefaultDimAlpha;
        } completion:NULL];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    // 交互式present可能会cancel
    if (completed == NO) {
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin {
    if (!_interactivePanGesture) {
        // 点击收回
        id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 0.f;
        } completion:NULL];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed == YES) {
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    //设置contentView的frame
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    CGRect presentedViewFrame = containerViewBounds;
    presentedViewFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    presentedViewFrame.size.height = presentedViewContentSize.height;
    return presentedViewFrame;
}

#pragma mark - UIContentContainer
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    if (container == self.presentedViewController) {
        return ((UIViewController*)container).preferredContentSize;
    } else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    if (container == self.presentedViewController) {
        [self.containerView setNeedsLayout];
    }
}

#pragma mark - Event Response
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender {
    self.interactivePanGesture = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPanGestureRecognizer
- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
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
    if (_interactivePanGesture) {
        self.interactiveTransition.gestureRecognizer = _interactivePanGesture;
        self.interactiveTransition.presentedView = self.presentationWrappingView;
        return _interactiveTransition;
    }
    return nil;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}
@end
