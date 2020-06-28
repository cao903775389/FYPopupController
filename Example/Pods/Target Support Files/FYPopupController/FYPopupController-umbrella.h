#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FYPopupDismissInteractiveTransition.h"
#import "FYPopupPresentationController.h"
#import "FYPopupPresentTransition.h"
#import "UIViewController+FYPopup.h"

FOUNDATION_EXPORT double FYPopupControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char FYPopupControllerVersionString[];

