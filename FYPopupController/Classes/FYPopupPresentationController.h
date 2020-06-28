//
//  FYPopupPresentationController.h
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FYPopupStyle) {
    FYPopupStyleDefault = 0,
    FYPopupStyleRoundedCorner = 1,
};


@interface FYPopupPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

// default 16
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) FYPopupStyle style;

@end

NS_ASSUME_NONNULL_END
