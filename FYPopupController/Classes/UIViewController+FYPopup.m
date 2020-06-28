//
//  UIViewController+FYPopup.m
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/28.
//

#import "UIViewController+FYPopup.h"
#import "FYPopupPresentationController.h"
#import <objc/Runtime.h>

@implementation UIViewController (FYPopup)

- (void)setPopUpController:(FYPopupPresentationController *)popUpController {
    objc_setAssociatedObject(self, @selector(popUpController), popUpController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FYPopupPresentationController *)popUpController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)show:(UIViewController *)contentViewController {
    [self show:contentViewController style:FYPopupStyleDefault];
}

- (void)show:(UIViewController *)contentViewController style:(FYPopupStyle)style {
    self.popUpController = [[FYPopupPresentationController alloc] initWithPresentedViewController:contentViewController presentingViewController:self];
    self.popUpController.style = style;
    contentViewController.transitioningDelegate = self.popUpController;
    [self presentViewController:contentViewController animated:YES completion:^{
    }];
}

@end
